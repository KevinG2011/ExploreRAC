//: Playground - noun: a place where people can play

import UIKit
import RxSwift

let disposeBag = DisposeBag()

example(of: "observable") {
  _ = Observable.of("Hello world!")
  let _ = Observable.just(episodeI)
  let _ = Observable.of(episodeII, episodeIII)
  let _ = Observable.of([episodeII, episodeIV, episodeV])
}

example(of: "subscribe") {
  let o1 = Observable.of(episodeII, episodeIV, episodeV)
  o1.subscribe(onNext: { ele in
    print(ele)
  }, onCompleted: {
    print("success")
  })
}

example(of: "disposeBag") {
  let o1 = Observable.of(episodeII, episodeIV, episodeV)
  let subscription = o1.subscribe(onNext: {
    print($0)
  })
  subscription.disposed(by: disposeBag);
}

example(of: "create") {
  enum Driod: Error {
    case OU812
  }
  Observable<String>.create({ observer -> Disposable in
    observer.onNext("R2-D2");
    observer.onCompleted();
    return Disposables.create()
  })
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)
}

example(of: "challenge") {
  Observable.never()
    .do(onSubscribe: {
      print("do Next")
    })
    .subscribe(onNext: {
      print("on Next");
    })
    .disposed(by: disposeBag)
}

example(of: "BehaviorSubject") {
  let quotes = BehaviorSubject(value: episodeV);
  let subscription = quotes
    .subscribe {
      print($0);
    }
  subscription.disposed(by: disposeBag);
}

example(of: "ReplaySubject") {
  let quotes = ReplaySubject<String>.create(bufferSize: 2);
  quotes.onNext(episodeVI);
  quotes.onNext(episodeVII);
  quotes.subscribe(onNext: {
    print($0);
  })
    .disposed(by: disposeBag)
  
  quotes.onNext(episodeVIII);
}

example(of: "Dealt") {
  let disposeBag = DisposeBag()
  
  let dealtHand = PublishSubject<[(String, Int)]>()
  
  func deal(_ cardCount: UInt) {
    var deck = cards
    var cardsRemaining: UInt32 = 52
    var hand = [(String, Int)]()
    
    for _ in 0..<cardCount {
      let randomIndex = Int(arc4random_uniform(cardsRemaining))
      hand.append(deck[randomIndex])
      deck.remove(at: randomIndex)
      cardsRemaining -= 1
    }
    
    // Add code to update dealtHand here
    if points(for: hand) > 21 {
      dealtHand.onError(HandError.busted)
    } else {
      dealtHand.onNext(hand)
    }
  }
  
  // Add subscription to dealtHand here
  dealtHand.subscribe(onNext:  { hand in
    print(cardString(for: hand), "for", points(for: hand), "points")
  },
  onError: { error in
    print(String(describing: error))
  })
  .disposed(by: disposeBag)
  
  deal(3)
}







































