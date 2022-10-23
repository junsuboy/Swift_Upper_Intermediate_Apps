import RxSwift

print("-------ignoreElements-------")
let 취침모드😴 = PublishSubject<String>()

취침모드😴
    .ignoreElements()
    .subscribe { _ in
        print()
    }
