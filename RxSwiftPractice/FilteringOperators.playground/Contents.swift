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


print("-------filter-------")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)   // [1, 2, 3, 4, 5, 6, 7, 8]
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------skip-------")
Observable.of("가", "나", "다", "라", "마", "바")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------skipWhile-------")
Observable.of("가", "나", "다", "라", "마", "바", "사", "아")
    .skip(while: {
        $0 != "바"
    })
    .subscribe(onNext: {
        print($0)
    })

print("-------skipUntil-------")
let customer = PublishSubject<String>()
let openTime = PublishSubject<String>()

customer        // 현재 Observable
    .skip(until: openTime)  // 다른 Observable
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

customer.onNext("😀")
customer.onNext("😀")

openTime.onNext("OPEN")
customer.onNext("😍")

print("-------take-------")
Observable.of("🥇", "🥈", "🥉", "🥹", "😎")
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------takeWhile-------")
Observable.of("🥇", "🥈", "🥉", "🥹", "😎")
    .take(while: {
        $0 != "🥉"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------enumerated-------")
Observable.of("🥇", "🥈", "🥉", "🥹", "😎")
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------takeUntil-------")
let apply = PublishSubject<String>()
let applyEnded = PublishSubject<String>()

apply
    .take(until: applyEnded)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

apply.onNext("1")
apply.onNext("2")

applyEnded.onNext("ENDED")
apply.onNext("3")

print("-------distinctUntilChanged-------")
Observable.of("나는", "나는", "스위프트가", "스위프트가", "스위프트가", "스위프트가", "좋다", "좋다", "좋다", "좋다", "나는", "스위프트가", "좋을까?", "좋을까?")
    .distinctUntilChanged() // 연달아 반복되는 요소를 방지함
    .subscribe(onNext: {
        print($0)
    })
