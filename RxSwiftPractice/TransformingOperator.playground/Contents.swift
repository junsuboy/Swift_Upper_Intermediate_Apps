import RxSwift
import Foundation

let disposeBag = DisposeBag()

print("-------toArray-------")
Observable.of("A", "B", "C") // Observable.just(["A", "B", "C"])
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------map-------")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })

print("-------flatMap-------")
protocol Athlete {
    var score: BehaviorSubject<Int> { get }
}

struct ArcheryAthlete: Athlete {
    var score: BehaviorSubject<Int>
}

let koreanArcheryAthlete = ArcheryAthlete(score: BehaviorSubject<Int>(value: 10))
let chineseArcheryAthlete = ArcheryAthlete(score: BehaviorSubject<Int>(value: 8))

let olympicGame = PublishSubject<Athlete>()

olympicGame
    .flatMap { athlete in
        athlete.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

olympicGame.onNext(koreanArcheryAthlete)
koreanArcheryAthlete.score.onNext(10)

olympicGame.onNext(chineseArcheryAthlete)
koreanArcheryAthlete.score.onNext(10)
chineseArcheryAthlete.score.onNext(9)

print("-------flatMapLatest-------")
struct HarkeyAthlete: Athlete {
    var score: BehaviorSubject<Int>
}

let seoul = HarkeyAthlete(score: BehaviorSubject<Int>(value: 7))
let jeju = HarkeyAthlete(score: BehaviorSubject<Int>(value: 6))

let asianGame = PublishSubject<Athlete>()

asianGame
    .flatMapLatest { athlete in
        athlete.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

asianGame.onNext(seoul)
seoul.score.onNext(9)

asianGame.onNext(jeju)
seoul.score.onNext(10) // 제주의 변화, 즉 가장 최근에 추가된 요소만 변화를 감지함. 네트워크에서 주로 사용
jeju.score.onNext(8)

print("-------meterialize and dematerialize-------")
enum Cheating: Error {
    case cheatingStart
}

struct RunningAthlete: Athlete {
    var score: BehaviorSubject<Int>
}

let runnerJunsu = RunningAthlete(score: BehaviorSubject<Int>(value: 0))
let runnerKim = RunningAthlete(score: BehaviorSubject<Int>(value: 1))

let running100M = BehaviorSubject<Athlete>(value: runnerJunsu)

running100M
    .flatMapLatest { athlete in
        athlete.score
            .materialize() // 값 뿐만 아니라 event까지 함께 전송
    }
    .filter {
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

runnerJunsu.score.onNext(1)
runnerJunsu.score.onError(Cheating.cheatingStart)
runnerJunsu.score.onNext(2)

running100M.onNext(runnerKim)

print("-------전화번호 11자리-------")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap {
        $0 == nil
        ? Observable.empty()
        : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0})
    .take(11)       // 010-1234-5678
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)" }
    }
    .map { numbers -> String in
        var numberList = numbers
        numberList.insert("-", at: 3)   // 010-
        numberList.insert("-", at: 8)   // 010-1234-
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(1)
