import RxSwift

let disposeBag = DisposeBag()

print("-------startWith-------")
let yellowClass = Observable<String>.of("Tom", "John", "Chris")

yellowClass
    .enumerated()
    .map { index, element in
        element + " Student" + "\(index)"
    }
    .startWith("Teacher") // 위 of와 동일한 자료형을 사용해야 함
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------concat1-------")
let redClass = Observable<String>.of("Tom", "John", "Chris")
let teacher = Observable<String>.of("Teacher")

let lineUp = Observable
    .concat([teacher, redClass])

lineUp
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------concat2-------")
teacher
    .concat(redClass)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------concatMap-------")
let kinderGarden: [String: Observable<String>] = [
    "yellowClass": Observable<String>.of("Tom", "John", "Chris"),
    "redClass": Observable<String>.of("July", "Michael")
]

Observable.of("yellowClass", "redClass")
    .concatMap { whichClass in
        kinderGarden[whichClass] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------merge1-------")
let kangbuk = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let kangnam = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(kangbuk, kangnam)
    .merge() // 순서를 보장하지 않음. 2개의 Observable이 그냥 합쳐짐.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------merge2-------")
Observable.of(kangbuk, kangnam)
    .merge(maxConcurrent: 1) // 한번에 받아낼 observable의 최대 개수
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------combineLatest1-------")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let name = Observable
    .combineLatest(lastName, firstName) { lastName, firstName in
        lastName + firstName
    }

name
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("장")
firstName.onNext("준수")  // 장준수
firstName.onNext("민수")  // 장민수
firstName.onNext("만득")  // 장만득
lastName.onNext("김")    // 김만득
lastName.onNext("이")    // 이만득
lastName.onNext("최")    // 최만득

print("-------combineLatest2-------")
let dateFormat = Observable<DateFormatter.Style>.of(.short, .long)
let currentDate = Observable<Date>.of(Date())

let currentDateShow = Observable
    .combineLatest(
        dateFormat,
        currentDate,
        resultSelector: { format, date -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = format
            return dateFormatter.string(from: date)
        }
    )

currentDateShow
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------combineLatest3-------")
let lastName2 = PublishSubject<String>()    // 성
let firstName2 = PublishSubject<String>()   // 이름

let fullName = Observable
    .combineLatest([firstName2, lastName2]) { name in
        name.joined(separator: " ")
    }

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName2.onNext("Kim")
firstName2.onNext("Paul")
firstName2.onNext("Stella")
firstName2.onNext("Lily")

print("-------zip-------")
enum WinOrLose {
    case win
    case lose
}

let battle = Observable<WinOrLose>.of(.win, .win, .lose, .win, .lose)
let fighter = Observable<String>.of("Korea", "Taiwan", "America", "Brazil", "Japan", "China")

let battleResult = Observable
    .zip(battle, fighter) { result, fighter in
        return fighter + " fighter" + " \(result)"
    } // 둘 중 하나의 element가 끝나면, Observable 전체가 종료됨

battleResult
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------withLatestFrom1-------")
let trigger = PublishSubject<Void>()
let runner = PublishSubject<String>()

trigger
    .withLatestFrom(runner)
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

runner.onNext("🏃‍♂️")
runner.onNext("🏃‍♂️🏃‍♂️")
runner.onNext("🏃‍♂️🏃‍♂️🏃‍♂️")
trigger.onNext(Void())
trigger.onNext(Void())

print("-------sample-------")
let flag = PublishSubject<Void>()
let F1Player = PublishSubject<String>()

F1Player
    .sample(flag) // 한 번만 방출함
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

F1Player.onNext("🏎️")
F1Player.onNext("🏎️    🚗")
F1Player.onNext("🏎️.      🚗   🛻")
flag.onNext(Void())
flag.onNext(Void())
flag.onNext(Void())

print("-------amb-------")
let bus1 = PublishSubject<String>()
let bus2 = PublishSubject<String>()

let busStop = bus1.amb(bus2) // 두 개를 구독하고, 요소를 먼저 방출하는 Observable에 대해서만 계속 구독함

busStop
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

bus2.onNext("bus2-passenger0: 👸")
bus1.onNext("bus1-passenger0: 🙆🏻")
bus1.onNext("bus1-passenger1: 🕴🏽")
bus2.onNext("bus2-passenger1: 💃🏻")
bus1.onNext("bus1-passenger1: 👨🏼‍🦰")
bus2.onNext("bus2-passenger2: 👩🏾")

print("-------switchLatest-------")
let student1 = PublishSubject<String>()
let student2 = PublishSubject<String>()
let student3 = PublishSubject<String>()

let raiseHand = PublishSubject<Observable<String>>()

let raiseHandtoAskSomething = raiseHand.switchLatest() // source-Observable

raiseHandtoAskSomething
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

raiseHand.onNext(student1)
student1.onNext("student1: 저는 1번입니다") // student1 의 event만 구독,
student2.onNext("student2: 저요!") // student2 의 event는 무시

raiseHand.onNext(student2)
student2.onNext("student2: 저는 2번이에요")
student1.onNext("student1: 내 말 안 끝났는데")

raiseHand.onNext(student3)
student2.onNext("student2: 아니 잠깐만! 내가")
student1.onNext("student1: 언제 말할 수 있죠")
student3.onNext("student3: 저는 3번입니다~ 아무래도 제가 이긴 것 같네요.")

raiseHand.onNext(student1)
student1.onNext("student1: 아니, 틀렸어. 승자는 나야")
student2.onNext("student2: ㅠㅠ")
student3.onNext("student3: 이긴 줄 알았는데")
student2.onNext("student2: 이기고 지는게 어디있어요")

print("-------reduce-------") // 최종 결과만을 방출
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newValue in
//        return summary + newValue
//    })
//    .reduce(0) { summary, newValue in
//        return summary + newValue
//    }
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-------scan-------") // 각 연산의 결과마다 방출
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
