/************************************  Optional关键实现技术模拟 ***************************/
//哨兵值
///函数返回一个不确定的魔法数 而不是真实的值,或者是都使用了一个同类型的特殊值来表示某种特殊的含义，通常管这样的值叫做“哨兵值（sentinal value）

//返回魔法值
[[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&e]
///解释: url 为 nil 这个时候检查错误指针 ;非 nil 错误指针并不一定会是有效值 即魔法数
///弊端: 这种错误处理的方式是被动的，它们都在各自的签名以及调用上，无法得知它有可能发生错误
///解决：将正确和错误合并为一个独立的类型 避免正确调用后 错误处理中的魔法值

//使用相同类型
NSString *tmp = nil;
if ([tmp rangeOfString: @"Swift"].location != NSNotFound) {
    NSLog(@"Something about swift");
}
print(NSNotFound.description) ///9223372036854775807
Int.max                       ///9223372036854775807
///解释: temp 为 nil rangeOfSstring 消息返回一个值为0 的NSRange结构体 .location 也为0 NSNotFound 定义为 NSIntegerMax 使用了 一个同类型的特殊值 来表示特殊的含义 这样If 语句会被执行
///弊端: 无法通过编译器来强制错误处理的行为,这些“哨兵值”的类型，和正常情况下函数返回的类型是一样的,悄无声息的混入正常业务逻辑代码的时候
///解决: 独立类型内定义正确执行的结果，定义一个和正确类型不同的错误结果 ,这样来避免同一类型的特殊值问题，这样编译器就能识别出类型不匹配

// 模拟数组index(of:)
enum Optional<T> {
    case some(T)
    case none
}
extension Array where Element: Equatable {
    func findIndex(_ element: Element) -> Optional<Index> {
        var index = startIndex
        while index != endIndex {
            if self[index] == element {
                return .some(index)
            }
            formIndex(after: &index)
        }
        return .none
    }
}
var numbers = [1, 2, 3]
let result = numbers.findIndex(2)
type(of: result)           /// Optinal<Int>
numbers.remove(at: index)  /// !!! Compile time error !!! 需要Int 却传入 Optinal<Int>

switch result {
    case .some(let index): numbers.remove(at: index)
    case .none: print("Not exist")
}

// Swift简化处理
func find(_ element: Element) -> Index? {
    var index = startIndex
    while index != endIndex {
        if self[index] == element {
            return index
            /// Simplified for .some(index)
        }
        formIndex(after: &index)
    }
    return nil
    /// Simplified for .none
}
switch index {
    case let index?: numbers.remove(at: index)
    ///简化读取.some的关联值， let  Option<Index> -> .some(value) 代表可选值当中的index
    case nil: print("Not exist")
}

/**********************************    Optionals   *********************************/
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
/// convertedNumber is inferred to be of type "Int?", or "optional Int"

// nil
var serverResponseCode: Int? = 404
/// serverResponseCode contains an actual Int value of 404
serverResponseCode = nil
/// serverResponseCode now contains no value
/// can’t use nil with nonoptional constants and variables.
var surveyAnswer: String?
/// surveyAnswer is automatically set to nil

// If Statements and Forced Unwrapping
if convertedNumber != nil {
    print("convertedNumber contains some integer value.")
}
if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
    
}
/// 确保绝对安全的条件下才会有能使用 希望如果意外地是 nil 的话，这句程序直接挂掉
let episodes = [
    "The fail of sentinal values": 100,
    "Common optional operation": 150,
    "Nested optionals": 180,
    "Map and flatMap": 220,
]
episodes.keys.filter { episodes[$0]! > 100 }.sorted()
episodes.filter { (_, duration) in duration > 100 } .map { (title, _) in title } .sorted()
///对整个Dictionary进行筛选，首先找到所有时长大于100的视频形成新的Dictionary，然后，把所有的标题，map成一个普通的Array，最后，再对它排序。这样不用force unwrapping
episodes.filter { (_, durations) in durations > 100 }.map { (name, _) in name }.sorted()



//自定义发生运行时错误的消息
///改进强制解包返回的信息
infix operator !!
func !!<T>(loptional: T?, errorMsg: @autoclosure () -> String) -> T {
    if let value = optional { return value }
    fatalError(errorMsg)
}
var record = ["name": "11"]
record["type"] !! "Do not have a key named type"

///通常可能会选择在调试版本或者测试版本中进行断言，让程序崩溃，但是在最终产品中，可能会把它替换成像是零或者空数组这样的默认值
infix operator !?
func !?<T: ExpressibleByStringLiteral>( optional: T?,nilDefault: @autoclosure () -> (errorMsg: String, value: T)) -> T {
///在debug mode得到和之前同样的运行时错误，而在release mode，则会得到一个默认值(显示提供)
    assert(optional != nil, nilDefault().errorMsg)
    return optional ?? nilDefault().value
}
record["type"] !? ("Do not have a key named type", "Free")

func !?(optional: Void?, errorMsg: @autoclosure () -> String) {
    ///在debug mode调试Optional<Void>了  对于返回 Void 的函数，使用可选链进行调用时将返回 Void?
    assert(optional != nil, errorMsg())
}
record["type"]?.write(" account") !? "Do not have a key named type" ///mutating func write(_ other: String)
/// 想要挂起一个操作我们有三种方式。首先，fatalError 将接受一条信息，并且无条件地停止操作。
/// 第二种选择，使用 assert 来检查条件，当条件结果为 false 时，停止执行并输出信息。在发布版本中，assert 会被移除掉，条件不会被检测，操作也永远不会挂起。
/// 第三种方式是使用 precondition，它和 assert 比较类型，但是在发布版本中它不会被移除，也就是说，只要条件被判定为 false，执行就会被停止。

// Implicitly Unwrapped Optionals
///隐式解包可选值 是那些不论何时你使用它们的时候就自动强制解包的可选值 它们依然是可选值, 当可选值是 nil 的时候强制解包会造成应用崩溃
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! /// requires an exclamation mark
let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString /// no need for an exclamation mark     ImplicitlyUnwrappedOptional<String>
///关于optional的所有操作，对于implicitly unwrapped optional来说，都是适用的。if let，map和flatMap，optional chaining统统都没问题
if assumedString != nil {
    print(assumedString!)
}
if let definiteString = assumedString {
    print(definiteString)
}
/// 使用场景:
/// 用来传承Objective-C中对象指针的语义,在绝大多数时候，Objective-C的API并不会返回一个空对象 但是在纯的原生 Swift API 中，不应该使用隐式可选值，也不应该将它们在回调中进行传递
/// 用来定义那些经过既定流程之后，就再也不会为nil的变量 添加UI控件的时候，XCode会把添加进来的@IBOutlet设置成implicitly unwrapped optional
class ViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    /// ...
}
///尽管在创建ViewController对象的时候，btn的值会是nil，但你知道，viewDidLoad方法一定会被调用，btn也一定会被初始化，并且，一旦初始化完成，在ViewController对象的生命周期里，它就再也不会变成nil了
///implicitly unwrapped optional获得的值是一个右值，因此，它也不能作为函数的inout参数：
var eleven: Int! = 11
func double(_ i: inout Int) {
    i = i * 2
}
double(&eleven) /// Error

// Optional Binding
///if let
if let actualNumber = Int(possibleNumber) {
    print("\'\(possibleNumber)\' has an integer value of \(actualNumber)")
} else {
    print("\'\(possibleNumber)\' could not be converted to an integer")
}
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
if let firstNumber = Int("4") {
    if let secondNumber = Int("42") {
        if firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
    }
}
///if while
let number = "1"
if var i = Int(number) {
    i += 1
    print(i)
} /// 2
///不过注意，i 会是一个本地的复制。任何对 i 的改变将不会影响到原来的可选值。可选值是值类型，解包一个可选值做的事情是将它里面的值复制出来。


///while let 代表遇到一个nil时终止循环
let numbers = [1, 2, 3, 4, 5, 6]
var iterator = numbers.makeIterator()
/// for ... in ....
while let element = iterator.next() {
    print("\(element)",terminator:"-")
}
for element in numbers {
    print("\(element)",terminator:"+ ")
}
var fnArray: [()->()] = []
for i in 0...2 {
    fnArray.append( {print(i)} )
}
fnArray[0]() // 0
fnArray[1]() // 1
fnArray[2]() // 2
///在Swift的for循环里，通过wile let 每一次循环变量都是一个“新绑定”的结果 无论任何时间调用这个closure，closure捕获到的变量都是不同的对象,不会出现类似JavaScript中都是2的问题

// 嵌套Optional
///通过双重可选值返回.some(nil) 可以识别出 nil
let stringOnes: [String] = ["1", "One"]
let intOnes = stringOnes.map { Int($0) }
intOnes.forEach { print($0) }
/// Optional(1)  nil
var i = intOnes.makeIterator()
while let i = i.next() {
    ///由于next()自身返回一个optional，而intOnes中元素的类型又是Optional<Int>，因此intOnes的迭代器指向的结果是一个Optional<Optional<Int>>
    ///当intOnes中的元素不为nil时，通过while let得到的结果，是经过一层unwrapping之后的Optional(1)
    ///当intOnes中的元素为nil时，我们可以看到while let的到的结果并不是Optional(nil)，而直接是nil；这个值是 .some(nil)
    ///这说明Swift对嵌套在optional内部的nil进行了识别，当遇到这类情况时，可以直接把nil提取出来，表示结果为nil
    print(i)
}/// Optional(1)  nil
///遍历数组内可选元素
for case let one? in intOnes {  /// 这里使用了 x? 这个模式，它只会匹配那些非 nil 的值。这个语法是 .Some(x) 的简写形式
    print(one) /// 1
}
for case nil in intOnes {
    print("got a nil value")
}
for case let .some(i) in intOnes { print("\(i)") } ///1

///if case
let j = 5
if case 0..<10 = j {
    print("\(j) 在范围内")
} /// 5 在范围内

// 可选项解包后的作用域
///利用编译器对optional的识别机制来为变量的访问创造一个安全的使用环境
func arrayProcess(array: [Int]) -> String? {
    let firstNumber: Int
    if let first = array.first { ///延迟初始化
        firstNumber = first
    } else {
        return nil
    }
    /// `firstNumber` could be used here safely
    return String(firstNumber)
}

//map
let swift: String? = "swift"
let out = swift.map { $0.uppercased() } /// Optional("SWIFT")
extension Optional {
    func myMap<T>(_ transform: (Wrapped) -> T) -> T? {
        ///Wrapped，这是Optional类型的泛型参数，表示optional实际包装的值的类型
        if let value = self {
            return transform(value)
        }
        return nil
    }
}
let numbers = [1, 2, 3, 4]
let sum = numbers.reduce(0, +) // 10
extension Array {
    func reduce(_ nextResult: (Element, Element) -> Element) -> Element? {
        guard let first = first else { return nil }
        return dropFirst().reduce(first, nextResult)
    }
}
let sum = numbers.reduce(+) // 10
///map方法可以根据optional变量的值自动执行后续的行为从而整合guard
extension Array {
    func reduce2(_ nextResult:(Element, Element) -> Element) -> Element? {
        return first.map { dropFirst().reduce($0, nextResult) }
    }
}

//flatMap
///如果map方法返回的也是一个optional，通过flatMap来处理双层嵌套optional类型的变换
let stringOne: String? = "1"
let ooo = stringOne.map { Int($0) }
type(of: ooo) /// Optional<Optional<Int>>

let oo = stringOne.flatMap { Int($0) }
type(of: oo) /// Optional<Int>

if let stringOne = stringOne, let o = Int(stringOne) {
    print(o)    /// 1
    type(of: o) /// Int
}

extension Optional {
    func myFlatMap<T>(_ transform: (Wrapped) -> T?) -> T? {
        if let value = self, let mapped = transform(value) { /// 解开第一层
            return mapped
        }
        return nil
    }
}

//遍历一个包含optional的集合
let ints = ["1", "2", "3", "4", "five"]
var all = 0
for case let int? in ints.map({ Int($0) }) {
/// ints.map -> [1?,2?,3?,4?,nil
/// int? 读取数组中的每一个非nil值
    all += int
}
all /// 10
///Swift标准库中，已经为序列类型提供了一个flatMap方法，专门用来处理“在序列中变换并筛选所有非nil元素”的任务
///Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
///ints.flatMap(<#T##transform: (String) throws -> ElementOfResult?##(String) throws -> ElementOfResult?#>) ⚠️弃用  compactMap
///ints.flatMap(<#T##transform: (String) throws -> Sequence##(String) throws -> Sequence#>)
///两个 flatMap 了：一个作用在数组上展平一个序列，另一个作用在可选值上展平可选值。这里的 flatMap 是两者的混合：它将把一个映射为可选值的序列进行展平。
let intOnes = ints.flatMap { Int($0) }.reduce(0, +)
extension Sequence {
    func myOptionFlatMap<T>(_ transform:(Iterator.Element) -> T?) -> [T] {
        return self.map(transform).filter { $0 != nil }.map { $0! } //// Safely force unwrapping
        /// .map(transform) 将必报传递给myOptionflatMap
    }
}
let all2 = ints.myOptionFlatMap { Int($0) }.reduce(0,+)

//字符串差值中的Optional
let bodyTemperature: Double? = 37.0
let bloodGlucose: Double? = nil
print(bodyTemperature)
/// Optional(37.0) Expression implicitly coerced from 'Double?' to Any
/// 警告：表达式被隐式强制从 'Double?' 转换为 Any
print("Blood glucose level: \(bloodGlucose)")
/// Blood glucose level: nil
/// String interpolation produces a debug description for an optional value; did you mean to make this explicit?
/// 警告：字符串插值将使用调试时的可选值描述，
/// 请确认这是确实是你想要做的。
/// 这样的警告防止我们把 "Optional(...)" 或者 "nil" 这样的东西不小心弄到我们想要显示给用户的文本里

infix operator ???: NilCoalescingPrecedence
public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}
print("Body temperature: \(bodyTemperature ??? "n/a")")
/// Body temperature: 37.0
print("Blood glucose level: \(bloodGlucose ??? "n/a")")
/// Blood glucose level: n/a”


//可选值排序
let numbers = ["Five", "4", "3", "2", "1"]
typealias SortDescriptor<T> = (T, T) -> Bool
func makeDescriptor<O, V>( key: @escaping (O) -> V, _ isAscending: @escaping (V, V) -> Bool)  -> SortDescriptor<O> {
    return {  (x:O,y:O) in
        return isAscending(key(x), key(y))
    }
}
func shift<T: Comparable>(_ compare: @escaping (T, T) -> Bool) -> (T?, T?) -> Bool {
    return { leftElement, rightElement in
        switch (leftElement, rightElement) {
        case (nil, nil): return false
        case (nil, _): return false
        case (_, nil): return true
        case let (leftElement?, rightElement?):
            return compare(leftElement, rightElement)
        default: fatalError()
        }
    }
}
let intDescriptor: SortDescriptor<String> = makeDescriptor(key: { Int($0) }, shift(<))
numbers.sorted(by: intDescriptor)
/// sorted遍历数组 传入isAscending(key(x), key(y)) key 闭包转换处理{ Int($0) } 结果导入 isAscending
/// isAscending 的处理程序为shift 接受两参数 compare闭包转换处理 <

//Equatable
let a: [Int?] = [1, 2, nil]
let b: [Int?] = [1, 2, nil]
print( a == b )///true
extension Optional: Equatable where Wrapped: Equatable {
    func ==<T: Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
        return lhs.elementsEqual(rhs) { $0 == $1 }
    }
}

//可选项判等Otional隐式转换
let regex = "^Hello$"
if regex.first == "^" {
    /// 只匹配字符串开头
}
///原理
func ==<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case (nil, nil): return true
    case let (x?, y?): return x == y
    case (_?, nil), (nil, _?): return false
    }
}
///当你在使用一个非可选值的时候，如果需要匹配可选值类型，Swift 总是会将它“升级”为一个可选值然后使用
if regex.first == Optional("^") { /// or: == .some("^")
    /// 自动升级
}
///字典获取key返回为可选类型 为其赋值需要一个可选类型 如果没有隐式转换，你就必须写像是 myDict["someKey"] = Optional(someValue) 这样的代码
var dictWithNils: [String: Int?] = [
    "one": 1,
    "two": 2,
    "none": nil
]
dictWithNils["two"] = nil
/// ["none": nil, "one": Optional(1)]”

dictWithNils["two"] = .some(nil)
/// 或 dictWithNils["two"] = Optional(nil)
/// dictWithNils["two"]? = nil
/// 这种方式使用了可选链的方式来在获取成功后对值进行设置 如果不存在的key用这种方式赋值会不存在
dictWithNils["three"]? = nil
let result = dictWithNils.index(forKey: "three")/// nil
///["none": nil, "one": Optional(1), "two": nil]



/**********************  Chaining and Nil coalescing  ***********************/
/// 可选链式调用是一种可以在当前值可能为nil的可选值上请求和调用属性、方法及下标的方法。如果可选值有值，那么调用就会成功；如果可选值是nil，那么调用将返回nil。
/// 多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为nil，整个调用链都会失败，即返回nil
var swift: String? = "Swift"
let result = swift?.uppercased()                /// Optional("SWIFT") func uppercased() -> String
let result2 = swift?.uppercased().lowercased()  /// Optional("swift")

// 如果调用的方法自身也返回一个optional 在每一个串联的方法前面使用?.操作符
///可选链是一个“展平”操作 逻辑上得到可选值的可选值 编译器可以展平类型结果
extension String {
    func toUppercase() -> String? {
        guard self.isEmpty != 0 else { return nil }
        return self.uppercased()
    }
    
    func toLowercase() -> String? {
        guard self.characters.count != 0 else { return nil }
        return self.lowercased()
    }
}
 let result3 = swift?.toUppercase()?.toLowercase()

// []操作符本身也是通过函数实现，返回一个optional
let numbers = ["fibo6": [0, 1, 1, 2, 3, 5]]
numbers["fibo6"]?[0] /// Optional(0)

// 可选链用作函数
let dictOfFunctions: [String: (Int, Int) -> Int] = ["add": (+), "subtract": (-)]
dictOfFunctions["add"]?(1, 1) /// Optional(2)

class TextField {
    private(set) var text = ""
    var didChange: ((String) -> ())?
    private func textDidChange(newText: String) {
        text = newText
        /// 如果不是 nil 的话，触发回调
        didChange?(text)
    }
}

//可选链赋值
struct Person {
    var name: String
    var age: Int
}
var optionalLisa: Person? = Person(name: "Lisa Simpson", age: 8)
/// 如果不是 nil，则增加
if optionalLisa != nil {
    optionalLisa!.age += 1
}
if var lisa = optionalLisa {
    ///由于值类型 对 lisa 的变更不会改变 optionalLisa 中的属性
    lisa.age += 1
}
optionalLisa?.age += 1
///age -> Optional(9)


var a: Int? = 5
a? = 10
a
/// Optional(10)
var b: Int? = nil
b? = 10
b
/// nil
/// a = 10 和 a? = 10 的细微不同。前一种写法无条件地将一个新值赋给变量，而后一种写法只在 a 的值在赋值发生前不是 nil 的时候才生效。


//  Nil coalescing
/// 在optional的值为nil时设定一个默认值
var userInput: String? = nil
let username = userInput ?? "Jack"

let a: String? = nil
let b: String? = nil
let c: String? = "C"
let theFirstNonNilString = a ?? b ?? c  /// Optional("C")

let one: Int?? = nil    /// Optional<Optional<String>>
let two: Int? = 2
let three: Int? = 3
one ?? two ?? three     /// 2

let one: Int?? = .some(nil) /// .some(nil)并不是nil，
let two: Int? = 2
let three: Int? = 3
one ?? two ?? three         /// nil
(one ?? two) ?? three       /// 3

let s1: String?? = nil /// nil
(s1 ?? "inner") ?? "outer" /// inner
let s2: String?? = .some(nil) /// Optional(nil)
(s2 ?? "inner") ?? "outer" /// outer”

extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}
var temp = [1,2,3]
let new = temp[guarded:5] ?? 12
print(new)



/******************     Optional Chaining as an Alternative to Forced Unwrapping    *******************/
class Person {
    var residence: Residence?
}
class Residence {
    var numberOfRooms = 1
}

let john = Person()
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}


// Defining Model Classes for Optional Chaining
class Person {
    var residence: Residence?
}

class Residence {
    var rooms = [Room]()
    var address: Address?
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
 
}
class Room {
    let name: String
    init(name: String) { self.name = name }
}
class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        } else {
            return nil
        }
    }
}
//Accessing Properties Through Optional Chaining
let john = Person()
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
} ///“Unable to retrieve the number of rooms.”


let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
/// the attempt to set the address property of john.residence will fail, because john.residence is currently nil.
john.residence?.address = someAddress


// Calling Methods Through Optional Chaining
if john.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
} /// “It was not possible to print the number of rooms.”

if (john.residence?.address = someAddress) != nil {
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")
} /// “It was not possible to set the address.”




// Accessing Subscripts Through Optional Chaining
if let firstRoomName = john.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
} ///“Unable to retrieve the first room name.”

let johnsHouse = Residence()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
john.residence = johnsHouse

if let firstRoomName = john.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
} /// “The first room name is Living Room.”


// Accessing Subscripts of Optional Type
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72


// Linking Multiple Levels of Chaining
if let johnsStreet = john.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}


let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
john.residence?.address = johnsAddress

if let johnsStreet = john.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}


// Chaining on Methods with Optional Return Values
if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
    print("John's building identifier is \(buildingIdentifier).")
}
/// return String?
if let beginsWithThe =
    john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        print("John's building identifier begins with \"The\".")
    } else {
        print("John's building identifier does not begin with \"The\".")
    }
}
