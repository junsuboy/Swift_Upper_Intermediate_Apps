import RxSwift

let disposeBag = DisposeBag()

print("-------ignoreElements-------")
let sleeping = PublishSubject<String>()

sleeping
    .ignoreElements()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

sleeping.onNext("💎")
sleeping.onNext("💎")
sleeping.onNext("💎")

sleeping.onCompleted()

print("-------elementAt-------")
let atTwo = PublishSubject<String>()

atTwo
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

atTwo.onNext("💎")  // index0
atTwo.onNext("💎")  // index1
atTwo.onNext("✅")  // index2
atTwo.onNext("💎")  // index3

