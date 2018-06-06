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
  let disposeBag = DisposeBag();
  let o1 = Observable.of(episodeII, episodeIV, episodeV)
  let subscription = o1.subscribe(onNext: {
    print($0)
  })
  subscription.disposed(by: disposeBag);
}














































