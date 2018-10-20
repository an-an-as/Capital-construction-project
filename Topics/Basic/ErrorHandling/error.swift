///Error handling is the process of responding to and recovering from error conditions in your program
///Swift provides first-class support for throwing, catching, propagating, and manipulating recoverable errors at runtime
///optional成功的时候，返回Value，错误的时候，返回nil,但如果可能会发生的错误不止一种情况，nil的表现力就很弱了，所以需要使用错误处理机制


/*********************  throw catch  **********************/
enum Result<T> {
    case success(T)
    case failure(Error)
}
enum CarError: Error {
    case outOfFuel
}
struct Car {
    var fuelInLitre: Double
    func start() -> Result<String> {
        guard fuelInLitre > 5 else {
            return .failure(CarError.outOfFuel) ///表示错误
        }
        return .success("Ready to go")
    }
}
let vw = Car(fuelInLitre: 6)
switch vw.start() {
case let .success(message): print(message)
case let .failure(error):
    if let carError = error as? CarError,
        carError == .outOfFuel { print("Cannot start due to out of fuel") }
    else {
        print(error.localizedDescription)
    }
}
///同一上述编程思路 提供一种编程语言层面的保障 而这就是throw关键字的用途
enum CarError: Error {
    case outOfFuel
}
struct Car {
    let fuel: Double
    func start() throws -> String {
        guard fuel > 5 else {
            throw CarError.outOfFuel /// return .failure(CarError.outOfFuel)
        }
        return "Ready to go"         /// return .success("Ready to go")
    }
}
///相比之前的版本，throws版本有了下面这些改进：
///通过throws关键字表示一个函数有可能发生错误相比Result更加统一和明确。
///通过throws，函数可以恢复返回正确情况下要返回的类型； func start() throws -> String
///遇到错误的情况时，通过throw关键字表示“抛出”一个“异常情况”，它有别于使用return返回正确的结果；
///在Swift中throw一个Error和return .failure(...)这种写法是没有任何区别的，“抛出”的错误没有明确的类型，这种“异常”也不会带来任何运行时成本。throw就是一个语法糖而已。
///因此，在Swift里，凡是声明中带有throws关键字的，通常都会在注释中标明这个函数有可能发生的错误。
///除了在表达方式上更为统一之外，使用throws声明函数还有一个好处，就是编译器会强制我们用“标准”的方法来调用可能会发生错误的函数:
///使用内建的错误处理还有一个好处，那就是编译器会确保你在调用一个可能抛出异常的函数时没有忽略那些错误

let vw = Car(fuel: 2)
do {
    let message = try vw.start()
    print(message)
}
catch CarError.outOfFuel {
    print("Cannot start due to out of fuel")
}
catch {
    print("We have something wrong")
}
///当我们调用start()时，要明确使用try关键字表示这种调用是个尝试，它有可能失败
///对于这种调用，我们必须把它包含在一个do...catch里，其中，每个catch用来匹配start有可能会返回的一种错误
///最后，我们用一个不匹配任何具体Error的catch表示匹配其他未列出的错误。虽然这并不是必要的，但是一旦start()返回了我们没有catch的错误，就会导致运行时错误。
///do...catch也是个语法糖 和之前使用的switch...case是没有任何区别的。


/*****************  Representing and Throwing Errors  *****************/
enum VendingMachineError: Error {
///conform to the Error protocol  通过enum和Error封装错误 只有遵从了Error的错误，才可以被throw。
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}
throw VendingMachineError.insufficientFunds(coinsNeeded: 5)

/************************   Handling Errors   **************************/
// Propagating Errors Using Throwing Functions
///一个 throwing 函数可以在其内部抛出错误，并将错误传递到函数被调用时的作用域
func canThrowErrors() throws -> String
func cannotThrowErrors() -> String

struct Item {
    var price: Int
    var count: Int
}
class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    func dispenseSnack(snack: String) {
        print("Dispensing \(snack)")
    }
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.InvalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.OutOfStock
        }
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        coinsDeposited -= item.price
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        print("Dispensing \(name)")
    }
}
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}


/// Throwing initializers can propagate errors in the same way as throwing functions.
struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {///throwing构造器能像throwing函数一样传递错误
        try vendingMachine.vend(itemNamed: name) ///在构造过程中调用了throwing函数,并且通过传递到它的调用者来处理这些错误
        self.name = name
    }
}

/*********************************** Handling Errors Using Do-Catch ************************************/
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack("Alice", vendingMachine: vendingMachine)
///vend(itemNamed:)方法能抛出错误，所以在调用的它时候在它前面加了try关键字
} catch VendingMachineError.InvalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.OutOfStock {
    print("Out of Stock.")
} catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
}
/// Insufficient funds. Please insert an additional 2 coins
///如果错误被抛出，相应的执行会马上转移到catch子句中，并判断这个错误是否要被继续传递下去。如果没有错误抛出，do子句中余下的语句就会被执行。




/************************** Converting Errors to Optional Values *******************************/
/// if an error is thrown while evaluating the try? expression, the value of the expression is nil.
func someThrowingFunction() throws -> Int {// ...}
let x = try? someThrowingFunction()
/// x and y have the same value and behavior
let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}

/// 用try?就可以让你写出简洁的错误处理代码 如果所有方式都失败了则返回nil
func fetchData() -> Data? {
    if let data = try? fetchDataFromDisk() { return data }
    if let data = try? fetchDataFromServer() { return data }
    return nil
}


/************************  Disabling Error Propagation  ************************/
///禁用错误传递 这会把调用包装在一个不会有错误抛出的运行时断言中。如果真的抛出了错误，你会得到一个运行时错误。
let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")

    
/************************ Specifying Cleanup Actions *************************/
///defer语句在即将离开当前代码块时执行一系列语句
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
        }
        /// close(file) 会在这里被调用，即作用域的最后。
    }
}
//defer
enum CarError: Error {
    case outOfFuel(no: String, fuelIn a: Double)
}
struct Car {
    let fuelInLitre: Double
    var no: String
    static var startCounter: Int = 0
    /// - Throws: `CarError` if the car is out of fuelInLitre
    func start() throws -> String {
        guard fuelInLitre > 5 else {
            throw CarError.outOfFuel(no: no, fuelInLitre: fuelInLitre)
        }
        defer { Car.startCounter += 1 } ///无论是否抛出错误都会执行
        return "Ready to go"
    }
    func selfCheck() throws -> Bool {
        _ = try start() /// try 如果失败发生运行时错误 try? 返回nil
        return true
    }
}
var vwGroup: [Car] = []
(1...100).forEach {
    let amount = Double(arc4random_uniform(70))
    vwGroup.append(Car(fuelInLitre: amount, no: "Car-\($0)"))
}
extension Sequence {
    func checkAll(by rule: (Iterator.Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            guard try rule(element) else { return false }
        }
        return true
    }
}
do {
    _ = try vwGroup.checkAll(by: {
        try $0.selfCheck()
    })
}
catch let CarError.outOfFuel(no, fuelInLitre) {
    print("\(no) is out of fuel. Current: \(fuelInLitre)L")
}
///延迟执行的操作会按照它们被指定时的顺序的相反顺序执行——也就是说，第一条defer语句中的代码会在第二条defer语句中的代码被执行之后才执行，以此类推。


/*********************************** closure参数错误 *******************************/
//case1 同步
enum CarError: Error {
    case outOfFuel(no: String, fuelInLitre: Double)
}
struct Car {
    let fuelInLitre: Double
    var no: String
    func start() throws -> String {
        guard fuelInLitre > 5 else {
            throw CarError.outOfFuel(no: no, fuelInLitre: fuelInLitre)
        }
        return "Ready to go"
    }
    func selfCheck() throws -> Bool {
        _ = try start()
        return true
    }
}
var vwGroup: [Car] = []
(1...100).forEach {
    let amount = Double(arc4random_uniform(70))
    vwGroup.append(Car(fuelInLitre: amount, no: "Car-\($0)"))
}
extension Sequence {
    func checkAll(by rule: (Iterator.Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            guard try rule(element) else { return false }
        }
        return true
    }
}
do {
    _ = try vwGroup.checkAll(by: {
        try $0.selfCheck()
    })
}
catch let CarError.outOfFuel(no, fuelInLitre) {
    print("\(no) is out of fuel. Current: \(fuelInLitre)L")
}
//case2 异步
enum CarError: Error {
    case outOfFuel(no: String, fuelInLitre: Double)
    case updateFailed
}
struct Car {
    let fuelInLitre: Double
    var no: String
    func osUpdate(postUpdate: @escaping ( () throws -> Int)  -> Void) {
        ///更新可能会出错 接收一个可以表示错误的参数
        DispatchQueue.global().async {
            // Some update staff
            let checksum = 20
            postUpdate {
                if checksum != 200 { throw CarError.updateFailed }
                return checksum
            }
        }
    }
}
var vwGroup: [Car] = []
(1...100).forEach {
    let amount = Double(arc4random_uniform(70))
    vwGroup.append(Car(fuelInLitre: amount, no: "Car-\($0)"))
}
vwGroup[0].osUpdate(postUpdate: {
    (getResult: (() throws -> Int)) in
    do {
        _ = try getResult()
    }
    catch CarError.updateFailed {
        print("Update failed")
    }
    catch {
    }
})
sleep(1)

/************   LocalizedError ************/
/// Swift-defined error types can provide localized error descriptions by adopting the new LocalizedError protocol.
/// LocalizedError: A specialized error that provides localized messages describing the error and why it occurred.
public enum MyError: Error {
    case customError
}
///You can provide even more information if the error is converted to NSError (which is always possible):
extension MyError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return NSLocalizedString("I failed.", comment: "")
        }
    }
    public var failureReason: String? {
        switch self {
        case .customError:
            return NSLocalizedString("I don't know why.", comment: "")
        }
    }
    public var recoverySuggestion: String? {
        switch self {
        case .customError:
            return NSLocalizedString("Switch it off and on again.", comment: "")
        }
    }
}
///By adopting the CustomNSError protocol the error can provide a userInfo dictionary (and also a domain and code)
extension MyError: CustomNSError {
    public static var errorDomain: String {
        return "myDomain"
    }
    public var errorCode: Int {
        switch self {
        case .customError:
            return 999
        }
    }
    public var errorUserInfo: [String : Any] {
        switch self {
        case .customError:
            return [ "line": 13]
        }
    }
}

let error0 = MyError.customError as NSError
if let line = error0.userInfo["line"] as? Int {
    print("Error in line", line) /// Error in line 13
}
print(error0.code) /// 999
print(error0.domain) /// myDomain

let error1: Error = MyError.customError
print(error1.localizedDescription)       /// I failed.

let error = MyError.customError as NSError
print(error.localizedDescription)        /// I failed.
print(error.localizedFailureReason)      /// Optional("I don\'t know why.")
print(error.localizedRecoverySuggestion) /// Optional("Switch it off and on again.")
