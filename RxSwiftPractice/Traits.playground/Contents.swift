import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("-------Single1-------")
Single<String>.just("✅")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0)")
        },
        onDisposed: {
            print("disposed")
        })
    .disposed(by: disposeBag)

//Observable<String>.just("✅")
//    .subscribe(
//        onNext: {},
//        onError: {},
//        onCompleted: {},
//        onDisposed: {}
//    )
