import RxSwift

let disposeBag = DisposeBag()
enum SubjectError: Error {
    case error1
}

print("-------publishSubject-------")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1") // 구독 이전이기 때문에 출력되지 않음

let subscriber1 = publishSubject
    .subscribe(onNext: {
        print("첫번째 구독: \($0)")
    })

publishSubject.onNext("2")
publishSubject.on(.next("3"))

subscriber1.dispose()

let subscriber2 = publishSubject
    .subscribe(onNext: {
        print("두번째 구독: \($0)")
    })

publishSubject.onNext("4")
publishSubject.onCompleted()

publishSubject.onNext("5") // completed 되었기 때문에 출력되지 않음

subscriber2.dispose()

publishSubject
    .subscribe {
        print("세번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6") // complete 이후엔 신규 구독이 불가능함

print("-------behaviorSubject-------")
let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")

behaviorSubject.onNext("1. 첫번째값")

behaviorSubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

let value = try? behaviorSubject.value()
print(value) // 마지막 값이 error였다면, nil 출력

print("-------ReplaySubject-------")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. apple") // 버퍼 사이즈가 2개이므로 출력되지 않음
replaySubject.onNext("2. banana")
replaySubject.onNext("3. carrot")

replaySubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4. dog")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세번째구독:", $0.element ?? $0) // disposed 되어 error 발생
}
.disposed(by: disposeBag)
