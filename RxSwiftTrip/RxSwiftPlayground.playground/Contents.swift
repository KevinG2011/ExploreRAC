//: Playground - noun: a place where people can play

import UIKit
import RxSwift

public func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

public let episodeI = "The Phantom Menace"
public let episodeII = "Attack of the Clones"
public let theCloneWars = "The Clone Wars"
public let episodeIII = "Revenge of the Sith"
public let solo = "Solo"
public let rogueOne = "Rogue One"
public let episodeIV = "A New Hope"
public let episodeV = "The Empire Strikes Back"
public let episodeVI = "Return Of The Jedi"
public let episodeVII = "The Force Awakens"
public let episodeVIII = "The Last Jedi"
public let episodeIX = "Episode IX"


let disposeBag = DisposeBag()


example(of: "observable") {
  _ = Observable.of("Hello world!")
  let o1 = Observable.just(episodeI)
  let o2 = Observable.of(episodeII, episodeIII)
  let o3 = Observable.of([episodeII, episodeIV, episodeV])
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










































