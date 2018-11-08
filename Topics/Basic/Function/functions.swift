/*********************** Defining and Calling Functions ***********************/
/// Functions are self-contained chunks of code that perform a specific task.

/******************** Function Parameters and Return Values ********************/
//Functions Without Parameters
func sayHelloWorld() -> String {
    return "hello, world"
}
print(sayHelloWorld())

//Functions With Multiple Parameters
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return greetAgain(person: person)
    } else {
        return greet(person: person)
    }
}
print(greet(person: "Tim", alreadyGreeted: true))

//Functions Without Return Values
func greet(person: String) {
    print("Hello, \(person)!")
}
greet(person: "Dave")

///The return value of a function can be ignored when it is called:
func printAndCount(string: String) -> Int {
    print(string)
    return string.count
}
func printWithoutCounting(string: String) {
    let _ = printAndCount(string: string)
}
printAndCount(string: "hello, world")
/// prints "hello, world" and returns a value of 12
printWithoutCounting(string: "hello, world")
/// prints "hello, world" but does not return a value



//Functions with Multiple Return Values
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
let bounds = minMax(array: [8, -6, 2, 109, 3, 71])
print("min is \(bounds.min) and max is \(bounds.max)")
/// Prints "min is -6 and max is 109"

//Optional Tuple Return Types
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
if let bounds = minMax(array: [8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}
/// Prints "min is -6 and max is 109"


/**********************  Function Argument Labels and Parameter Names     ***********************/
func someFunction(firstParameterName: Int, secondParameterName: Int) {
    /// In the function body, firstParameterName and secondParameterName
    /// refer to the argument values for the first and second parameters.
}
someFunction(firstParameterName: 1, secondParameterName: 2)

//Specifying Argument Labels
///providing a function body that is readable and clear in intent
///argument name  为了在调用函数的时候呈现更好的语意
///argument lable 为了在函数实现的时候呈现更好的逻辑
///如果argument name可以兼顾两者，你也就无须再单独定义arargument lable
func someFunction(argumentLabel parameterName: Int) {
    /// In the function body, parameterName refers to the argument value
    /// for that parameter.
}
func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))
/// Prints "Hello Bill!  Glad you could visit from Cupertino."

//Omitting Argument Labels
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
    /// In the function body, firstParameterName and secondParameterName
    /// refer to the argument values for the first and second parameters.
}
someFunction(1, secondParameterName: 2)

//Default Parameter Values
///拥有默认值的函数参数必须从右向左依次排列，有默认值的参数不能出现在无默认值的参数的左边
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    /// If you omit the second argument when calling this function, then
    /// the value of parameterWithDefault is 12 inside the function body.
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) /// parameterWithDefault is 6
someFunction(parameterWithoutDefault: 4) /// parameterWithDefault is 12

//Variadic Parameters
///A variadic parameter accepts zero or more values of a specified type.
///A function may have at most one variadic parameter.
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
/// returns 3.0, which is the arithmetic mean of these five numbers
arithmeticMean(3, 8.25, 18.75)
/// returns 10.0, which is the arithmetic mean of these three numbers


//In-Out Parameters
///inout参数的语义并不是直接传递了外部变量的引用，而是在函数内部修改完成之后，再拷贝回去的.
///In-out parameters cannot have default values, and variadic parameters cannot be marked as inout.
///In-out parameters are an alternative way for a function to have an effect outside of the scope of its function body.
///An in-out parameter has a value that is passed in to the function, is modified by the function, and is passed back out of the function to replace the original value.
///这个参数叫做inout并不是在传递变量地址，被inout修饰的参数只是被传递给函数，被修改后，再替换了初始值而已。当然，也许按引用传递是编译器采取的某种优化手段，但是你不能依赖这个特性。总之，inout就真的只是in out而已
///只有左值（l-value）才可以当作inout参数使用,左值需要用一块内存来表达，它的值就是内存区域中存放的内容,右值则仅仅表示值本身，通常它们不需要特定的内存空间存储，编译器可以把它们优化成某种形式的符号在程序中被使用
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
/// Prints "someInt is now 107, and anotherInt is now 3"

func incremental(_ i: inout Int) -> Int {
    i = i + 1
    return i
}
var i = 0 /// let 不可
incremental(&i) /// 1

///如果一个集合类型不是常量，它的下标操作符也可以作为inout参数：
var numbers = [1, 2, 3]
incremental(&numbers[0])
numbers

/// 如果一个自定义类型的属性同时有get和set方法，也可以作为inout参数:
/// 但是，对于一个只读的computed property，虽然它也是用var定义的，但是却不能作为inout参数
struct Color {
    var r: Int
    var g: Int
    var b: Int
}

var red = Color(r: 254, g: 0, b: 0)
incremental(&red.r)

/// 自定义操作符的inout参数在传递的时候，不需要使用&
prefix func ++(i: inout Int) -> Int {
    i += 1
    return i
}
++i /// 2

// 可以被修改，但却不能逃逸的inout参数
func doubleIncrement(_ i: inout Int) {
    func increment() {
        i += 1
    }
    [0, 1].forEach { _ in increment() } /// 调用2次
}
doubleIncrement(&i) /// 4
///但是，我们却不能通过内嵌函数，让inout参数逃离函数的作用域：
/// !!! Error !!!
func increment(_ i: inout Int) -> () -> Void {
    return {
        i += 1
    }
 }


//UnsafeMutablePointer
///在Swift里，有一种情况，&表示读取对象的引用，而不是执行inout语义
func incrementByReference(_ pointer: UnsafeMutablePointer<Int>) {
    pointer.pointee += 1
}
incrementByReference(&i) /// 5
func incrementByReference2( _ pointer: UnsafeMutablePointer<Int>) -> () -> Int {
    return { _ in
        pointer.pointee += 1
        return pointer.pointee
    }
}
let boom: () -> Int
if true {
    var j = 0
    boom = incrementByReference(&j) /// closure 带走了变量
}
boom()
/// !!! BOOM here
///因为boom访问了一个可能已经不存在的地址空间 和编译器不允许返回的函数捕获inout参数类似
///只不过这次，由于我们使用了类似原生指针这样的底层类型，逃过了编译器的检查 所以不要让接受指针参数的函数返回另外一个函数。


/**********************  Function Types     ***********************/
///Every function has a specific function type, made up of the parameter types and the return type of the function.
///对于一个函数来说，把它的参数和返回值放在一起，就形成了它的签名，这是用于描述函数自身属性的一种类型
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}
///(Int, Int) -> Int
func printHelloWorld() {
    print("hello, world")
}
///() -> Void

//Using Function Types
var mathFunction: (Int, Int) -> Int = addTwoInts
print("Result: \(mathFunction(2, 3))")  /// Prints "Result: 5"

mathFunction = multiplyTwoInts
print("Result: \(mathFunction(2, 3))")  /// Prints "Result: 6"

let anotherMathFunction = addTwoInts    /// anotherMathFunction is inferred to be of type (Int, Int) -> Int


//Function Types as Parameter Types
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
/// Prints "Result: 8"



//Function Types as Return Types
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}
var currentValue = 3
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// moveNearerToZero now refers to the stepBackward() function
print("Counting to zero:")/// Counting to zero:
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
// 3...
// 2...
// 1...
// zero!

//基于函数类型的函数式编程
func mul(m: Int, of n: Int) -> Int { return m * n }
func calc<T>(_ first: T, _ second: T, _ fn: (T, T) -> T) -> T {
    return fn(first, second)
}
calc(2, 3, mul)
func mul2(_ a: Int)->  (Int)->Int {
    func innerMul(_ b: Int) -> Int { return a * b }
    return innerMul
}
let mul2By = mul2(2)
mul2By(3)
mul2(2)(3)


/**********************   Nested Functions    ***********************/
///define functions inside the bodies of other functions, known as nested functions.
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = -4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
/// moveNearerToZero now refers to the nested stepForward() function
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
/// -4...
/// -3...
/// -2...
/// -1...
/// zero!


/******************************** 通过函数类型模拟OC运行时 **************************/
///通过返回函数类型其参数接受sorted遍历元素扩展其功能

//Objective-C
import Foundation
final class Episode: NSObject {
    var title: String
    @objc var type: String
    @objc var length: Int
    
    override var description: String {
        return title + "\t" + type + "\t" + String(length)
    }
    init(title: String, type: String, length: Int) {
        self.title = title
        self.type = type
        self.length = length
    }
}
let episodes = [
    Episode(title: "title 1", type: "Free", length: 520),
    Episode(title: "title 4", type: "Paid", length: 500),
    Episode(title: "title 2", type: "Free", length: 330),
    Episode(title: "title 5", type: "Paid", length: 260),
    Episode(title: "title 3", type: "Free", length: 240),
    Episode(title: "title 6", type: "Paid", length: 390),
]
let typeDescriptor = NSSortDescriptor( key: #keyPath(Episode.type), ascending: true, selector: #selector(NSString.localizedCompare(_:)))
let descriptors = [ typeDescriptor ]
let sortedEpisodes = (episodes as NSArray).sortedArray(using: descriptors)
sortedEpisodes.forEach { print($0 as! Episode) }

let lengthDescriptor = NSSortDescriptor( key: #keyPath(Episode.length), ascending: true)
let descriptors2 = [ typeDescriptor, lengthDescriptor ] ///同时排序
let sortedEpisodes2 = (episodes as NSArray).sortedArray(using: descriptors2)
sortedEpisodes2.forEach { print($0 as! Episode) }
/**
 title 3    Free    240
 title 2    Free    330
 title 1    Free    520
 title 5    Paid    260
 title 6    Paid    390
 title 4    Paid    500*/
s
// Swift
struct Episode {
    var title: String
    var type: String
    var length: Int
    init(title: String, type: String, length: Int) {
        self.title = title
        self.type = type
        self.length = length
    }
}
extension Episode: CustomStringConvertible {
    var description: String {
        return title + "\t" + type + "\t" + String(length)
    }
}
let episodes =
[
        Episode(title: "title 1", type: "Free", length: 520),
        Episode(title: "title 4", type: "Paid", length: 500),
        Episode(title: "title 2", type: "Free", length: 330),
        Episode(title: "title 5", type: "Paid", length: 260),
        Episode(title: "title 3", type: "Free", length: 240),
        Episode(title: "title 6", type: "Paid", length: 390),
]
typealias SortDescriptor<T> = (T, T) -> Bool
let stringDescriptor: SortDescriptor<String> = {
    $0.localizedCompare($1) == .orderedAscending
    /// localizedCompare: Compares the string and the given string using a localized comparison.
    ///.orderedAscending: The left operand is smaller than the right operand.
}
let flag = stringDescriptor("a","d") ///true
/// 通过闭包取得数组内对象的属性 和排序规则 用闭包表达式返回一个函数
/// - Parameters:
/// - key: 根据key返回value
/// - isAscending: 根据得到的Value返回函数表达式 该表达式可接受sorted 遍历出的Episode对象
/// - Returns:SortDescriptor<Key>
func makeDescriptor<Key, Value>( getValue: @escaping (Key) -> Value, _ isAscending: @escaping (Value, Value) -> Bool)  -> SortDescriptor<Key> {
    return {  (x:Key,y:Key) in
        return isAscending(getValue(x), getValue(y))
    }
}
let lengthDescriptor: SortDescriptor<Episode> = makeDescriptor(key: { $0.length }, <)
/// 函数返回闭包表达式 参数类型为Episode  即x：Episode y：Episode
let titlDescriptor: SortDescriptor<Episode> = makeDescriptor(key: { $0.title }, <)
let typeDescriptor: SortDescriptor<Episode> = makeDescriptor(key: { $0.type }, { $0.localizedCompare($1) == .orderedDescending })
episodes.sorted(by:lengthDescriptor).forEach { print($0) }
/// 如果某个descriptor可以比较出大小，那么后面的所有descriptor就都不再比较了；
/// 只有某个descriptor的比较结果为相等时，才继续用后一个descriptor进行比较；
/// 如果所有的descriptor的比较结果都相等，则返回false；
func combine<T>(rules: [SortDescriptor<T>]) -> SortDescriptor<T> {
    return { leftElementParament, rightElementParament in
        for rule in rules {
            if rule(leftElementParament, rightElementParament) {
                return true
            }
            if rule(rightElementParament, leftElementParament) {
                return false
            }
        }
        return false
    }
}
let mixDescriptor = combine(rules: [titlDescriptor,lengthDescriptor])
episodes.sorted(by: mixDescriptor).forEach { print($0) }

infix operator |>: LogicalDisjunctionPrecedence
/// 两个操作数中间，所以，我们把它定义为了infix operator
/// 由于我们要定义的操作符在语义上，有逻辑上逐层深入的含义，我们还把它的优先级定义为了LogicalDisjunctionPrecedence，也就是说，它和||以及&&的优先级是相同的。
/// 如果我们不指定优先级，Swift会为它设置默认的DefaultPrecedence
/// 避免暴露了我们本不需要的实现细节
///: [操作符优先级 SE0077-operator-precedence](https://github.com/apple/swift-evolution/blob/master/proposals/0077-operator-precedence.md)
func |><T>(operandL: @escaping SortDescriptor<T>,operandR: @escaping SortDescriptor<T>) -> SortDescriptor<T> {
    return {
        if operandL($0, $1) {
            return true
        } else if operandR($1, $0) {
            return false
        } else if operandR($0, $1) {
            return true
        }
        /// $0 and $1 is the same, try the second descriptor
        return false
    }
}
let new = episodes.sorted(by: typeDescriptor |> lengthDescriptor)
print(new)

// 处理可选项
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
///makeDescriptor闭包Int($0) 返回可选的V  此时isAccending @escaping (V?, V?) -> Bool) 传入 shift shift进一步compare比较

/// 排序枚举
enum HTTPResponse {
    case ok
    case error(Int)
}
let responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
let sortedResponses = responses.sorted {
    switch ($0, $1) {
    // Order errors by code
    case let (.error(aCode), .error(bCode)):
        return aCode < bCode
        
    // All successes are equivalent, so none is before any other
    case (.ok, .ok): return false
        
    // Order errors before successes
    case (.error, .ok): return true
    case (.ok, .error): return false
    }
}
print(sortedResponses)
// Prints "[.error(403), .error(404), .error(500), .ok, .ok]"


//Key Value Coding
///键路径是一个指向属性的未调用的引用
class Foo: NSObject {
    @objc var bar = "bar"
    @objc var baz = [1, 2, 3, 4]
}

var foo = Foo()
print(foo.bar)
foo.bar = "BAR"

var bar = foo.value(forKeyPath: #keyPath(Foo.bar))
foo.setValue("BAR", forKeyPath: #keyPath(Foo.bar))
///value(forKeyPath:)方法返回的类型是Any?，这样我们就失去了类型信息，错误的赋值会直接导致运行时错误
///只有NSObject的派生类才支持这种访问机制，进而导致了只有在Darwin平台上才可以使用

let barKeyPath = \Foo.bar
///\Foo.bar是Swift 4中新的key path用法，它是一个独立的类型，带有属性的类型信息,因此，编译器会发现错误类型的赋值，而不会把这个错误推迟到运行时
var bar = foo[keyPath: barKeyPath]
foo[keyPath: barKeyPath] = "BAR"



struct Address {
    var street: String
    var city: String
    var zipCode: Int
}
struct Person {
    let name: String
    var address: Address
    
}
let streetKeyPath = \Person.address.street /// WritableKeyPath<Person, String> 这个键路径的所有属性都是可变的，所以这个可写键路径本身允许其中的值发生变化
let nameKeyPath = \Person.name /// KeyPath<Person, String>  这个键路径是强类型的，它表示该键路径可以作用于 Person，并返回一个 String。
/// 反斜杠是为了将键路径和同名的类型属性区分开来 (假如 String 也有一个 static count 属性的话，String.count 返回的就会是这个属性值了)
/// 类型推断对键路径也是有效的，在上下文中如果编译器可以推断出类型的话，你可以将类型名省略，只留下 \.count
/// 键路径可以由任意的存储和计算属性组合而成，其中还可以包括可选链操作符。编译器会自动为所有类型生成 [keyPath:] 的下标方法,通过该方法来“调用”某个键路径
/// 对键路径的调用，也就是在某个实例上访问由键路径所描述的属性。所以，"Hello"[keyPath: \.count] 等效于 "Hello".count
let simpsonResidence = Address(street: "1094 Evergreen Terrace",city: "Springfield", zipCode: 97475)
var lisa = Person(name: "Lisa Simpson", address: simpsonResidence)
_ = lisa[keyPath: nameKeyPath]
lisa[keyPath: streetKeyPath] = "742 Evergreen Terrace"

//可以通过函数建模的键路径
///一个将基础类型 Root 映射为类型为 Value 的属性的键路径，和一个具有 (Root) -> Value 类型的方法十分类似
///相对于这样的函数，键路径除了在语法上更简洁外，最大的优势在于它们是值。可以测试键路径是否相等，也可以将它们用作字典的键 (因为它们遵守 Hashable)。
///另外，不像函数，键路径是不包含状态的，所以它也不会捕获可变的状态。如果使用普通的函数的话，这些都是无法做到的。
///键路径还可以通过将一个键路径附加到另一个键路径的方式来生成。
///这么做时，类型必须要匹配；如果你有一个从 A 到 B 的键路径，那么你要附加的键路径的根类型必须为 B，得到的将会是一个从 A 到 C 的键路径，其中 C 是所附加的键路径的值的类型
/// KeyPath<Person, String> + KeyPath<String, Int> = KeyPath<Person, Int>
let nameCountKeyPath = nameKeyPath.appending(path: \.count)/// Swift.KeyPath<Person, Swift.Int>” 等同于let nameKeyPath = \Person.name.count
print(lisa[keyPath:nameCountKeyPath])///12
///基于函数表达式
typealias SortDescriptor<Value> = (Value, Value) -> Bool
func sortDescriptor<Value, Key>(key: @escaping (Value) -> Key) -> SortDescriptor<Value> where Key: Comparable {
    return { key($0) < key($1) } ///获取Person的Value作为Sorted的Key
}
let streetSD: SortDescriptor<Person> = sortDescriptor { $0.address.street }
///通过键路径来添加一种排序描述符的构建方式 失去函数的灵活度
func sortDescriptor<Value, Key>(key: KeyPath<Value, Key>) -> SortDescriptor<Value> where Key: Comparable {
    return { $0[keyPath: key] < $1[keyPath: key] }
}
let streetSDKeyPath: SortDescriptor<Person> = sortDescriptor(key: \.address.street)

//可写键路径
///可写的键路径比较特殊：可以用它来读取或者写入一个值。
///因此，它和一对函数等效：一个负责获取属性值 ((Root) ->Value)，另一个负责设置属性值 ((inout Root, Value) -> Void)。
///相比于只读的键路径，可写键路径要复杂的多。首先，它将很多代码包括在了简洁的语法中。
///streetKeyPath 与等效的 getter 和 setter 对进行比较：
let getStreet: (Person) -> String = { person in return person.address.street }   /// let streetKeyPath = \Person.address.street
let setStreet: (inout Person, String) -> () = { person, newValue in person.address.street = newValue }

setStreet(&lisa,"------")
print(getStreet(lisa) )

///如果将两个属性互相绑定：当属性 1 发生变化的时候，属性 2 的值会自动更新，反之亦然。可写的键路径在这种数据绑定的过程中会特别有用。
///比如，你可以将一个 model.name 属性绑定到 textField.text 上。API 的用户需要知道如何读写 model.name 和 textField.text，而键路径所解决的正是这个问题
///还需要对属性的变化进行观察。在 Cocoa 中，使用键值观察机制来达到这个目的
///不过这样的方式只能工作在 Apple 平台上。Foundation 提供了一种新的类型安全的 KVO 的 API，它们可以将 Objective-C 世界中基于字符串的键路径隐藏起来。
///NSObject 上的 observe(_:options:changeHandler:) 方法将会对一个 (Swift 的强类型) 键路径进行观察，并在属性发生变化的时候调用 handler。
///不要忘记你还需要将要观察的属性标记为 @objc dynamic，否则 KVO 将不会工作。

///在两个 NSObject 之间实现双向绑定，从单项绑定开始：每当 self 上的被观察值变更，我们就同时变更另一个对象。
///键路径可以让我们的代码更加泛用，而不必拘泥于某个特定的属性：调用者只需要指定两个对象以及两个键路径，这个方法就可以处理其他的事情：
extension NSObjectProtocol where Self: NSObject {
    /// 对所有 NSObject 的子类定义了这个方法，通过扩展 NSObjectProtocol 而不是 NSObject，我们可以使用 Self
    func observe<A, Other>(_ keyPath: KeyPath<Self, A>,writeTo other: Other,_ otherKeyPath: ReferenceWritableKeyPath<Other, A>)-> NSKeyValueObservation
        /// ReferenceWritableKeyPath 和 WritableKeyPath 很相似，不过它可以让我们对 (other 这样的) 使用 let 声明的引用变量进行写操作
        /// 为了避免不必要的操作，在值发生改变时才对 other 进行写入。返回值 NSKeyValueObservation 是一个 token，
        /// 调用者使用这个 token 来控制观察的生命周期：属性观察会在这个 token 对象被销毁或者调用者调用了它的 invalidate 方法时停止
        where A: Equatable, Other: NSObjectProtocol {
            return observe(keyPath, options: .new) { _, change in  ///@escaping (Self, NSKeyValueObservedChange<Value>) -> Void
                guard let newValue = change.newValue,other[keyPath: otherKeyPath] != newValue else {
                    return /// prevent endless feedback loop
                }
                other[keyPath: otherKeyPath] = newValue
            }
    }
}

/// 有了 observe(_:writeTo:_:)，双向绑定就也很直接了：我们对两个对象都调用 observe，它们将返回两个观察 token：
extension NSObjectProtocol where Self: NSObject {
    func bind<A, Other>(_ keyPath: ReferenceWritableKeyPath<Self,A>,to other: Other,_ otherKeyPath: ReferenceWritableKeyPath<Other,A>)
        -> (NSKeyValueObservation, NSKeyValueObservation)
        where A: Equatable, Other: NSObject {
            let one = observe(keyPath, writeTo: other, otherKeyPath)
            let two = other.observe(otherKeyPath, writeTo: self, keyPath)
            return (one,two)
    }
}
final class Sample: NSObject {
    @objc dynamic var name: String = ""
}
class MyObj: NSObject {
    @objc dynamic var test: String = ""
}
let sample = Sample()
let other = MyObj() /// ReferenceWritableKeyPath inout 特性可改写let
let observation = sample.bind(\Sample.name, to: other, \.test)
sample.name = "NEW"
print(other.test) /// NEW
other.test = "HI"
print(sample.name) /// HI
//键路径层级
///AnyKeyPath 和 (Any) -> Any? 类型的函数相似
///PartialKeyPath<Source> 和 (Source) -> Any? 函数相似
///KeyPath<Source, Target> 和 (Source) -> Target 函数相似
///WritableKeyPath<Source, Target> 和 (Source) -> Target 与 (inout Source, Target) -> () 这一对函数相似
///ReferenceWritableKeyPath<Source, Target> 和 (Source) -> Target 与 (Source, Target) -> ()
///这一对函数相似。第二个函数可以用 Target 来更新 Source 的值，且要求 Source 是一个引用类型。
///对 WritableKeyPath 和 ReferenceWritableKeyPath 进行区分是必要的，前一个类型的 setter 要求它的参数是 inout 的


/**内联函数inline
 + 内联函数是指那些定义在类体内的成员函数，即该函数的函数体放在类体内
 + 引入内联函数的主要目的是：解决程序中函数调用的效率问题
 + inline 定义的类的内联函数，函数的代码被放入符号表中，在使用时直接进行替换，（像宏一样展开），没有了调用的开销，效率也很高
 + 很明显，类的内联函数也是一个真正的函数，编译器在调用一个内联函数时，会首先检查它的参数的类型，保证调用正确。然后进行一系列的相关检查，就像对待任何一个真正的函数一样。这样就消除了它的隐患和局限性。
 + inline 可以作为某个类的成员函数，当然就可以在其中使用所在类的保护成员及私有成员。
 + 内联函数和宏的区别在于，宏是由预处理器对宏进行替代，而内联函数是通过编译器控制来实现的。而且内联函数是真正的函数，只是在需要用到的时候，内联函数像宏一样的展开，所以取消了函数的参数压栈，减少了调用的开销。
 + 你可以象调用函数一样来调用内联函数，而不必担心会产生于处理宏的一些问题。
 + 内联函数与带参数的宏定义进行下比较，它们的代码效率是一样，但是内联欢函数要优于宏定义，因为内联函数遵循的类型和作用域规则，它与一般函数更相近，在一些编译器中，一旦关上内联扩展，将与一般函数一样进行调用，比较方便
 + 我们可以把它作为一般的函数一样调用，但是由于内联函数在需要的时候，会像宏一样展开，所以执行速度确比一般函数的执行速度要快。当然，内联函数也有一定的局限性。就是函数中的执行代码不能太多了，如果，内联函数的函数体过大，一般的编译器会放弃内联方式，而采用普通的方式调用函数。(换句话说就是，你使用内联函数，只不过是向编译器提出一个申请，编译器可以拒绝你的申请）这样，内联函数就和普通函数执行效率一样了。
 + 使用inline修饰的函数，在编译的时候，会把代码直接嵌入调用代码中。就相当于用#define 宏定义来定义一个add 函数那样！与#define的区别是:
 + #define定义的格式要有要求，而使用inline则就行平常写函数那样，只要加上`inline即可！
 + 使用#define宏定义的代码，编译器不会对其进行参数有效性检查，仅仅只是对符号表进行替换。
 + #define宏定义的代码，其返回值不能被强制转换成可转换的适合的转换类型
 + 用来降低程序的运行时间。当内联函数收到编译器的指示时，即可发生内联：编译器将使用函数的定义体来替代函数调用语句，这种替代行为发生在编译阶段而非程序运行阶段。
 + 值得注意的是，内联函数仅仅是对编译器的内联建议，编译器是否觉得采取你的建议取决于函数是否符合内联的有利条件。如何函数体非常大，那么编译器将忽略函数的内联声明，而将内联函数作为普通函数处理。
 + 有时候我们会写一些功能专一的函数，这些函数的函数体不大，包含了很少的执行语句 经常会使用
 + 当遇到普通函数的调用指令时，程序会保存当前函数的执行现场，将函数中的局部变量以及函数地址压入堆栈，然后再将即将调用的新函数加载到内存中，这要经历复制参数值、跳转到所调用函数的内存位置、执行函数代码、存储函数返回值等过程，当函数执行完后，再获取之前正在调用的函数的地址，回去继续执行那个函数，运行时间开销简直太多了。
 + 通过inline声明，编译器首先在函数调用处使用函数体本身语句替换了函数调用语句，然后编译替换后的代码。因此，通过内联函数，编译器不需要跳转到内存其他地址去执行函数调用，也不需要保留函数调用时的现场数据
 + 它通过避免函数调用所带来的开销来提高你程序的运行速度。
 + 当函数调用发生时，它节省了变量弹栈、压栈的开销。
 + 它避免了一个函数执行完返回原现场的开销。
 + 通过将函数声明为内联，你可以把函数定义放在头文件内。
 + 缺点: 因为代码的扩展，内联函数增大了可执行程序的体积。C++内联函数的展开是中编译阶段，这就意味着如果你的内联函数发生了改动，那么就需要重新编译代码
 + 使用时机: 当程序设计需要时，每个函数都可以声明为inline。当对程序执行性能有要求时，那么就使用内联函数吧。当你想宏定义一个函数时，那就果断使用内联函数吧。
 + 内联声明只是一种对编译器的建议，编译器是否采用内联措施由编译器自己来决定。甚至在汇编阶段或链接阶段，一些没有inline声明的函数编译器也会将它内联展开。
 + @inline(__always) @inline后面的括号里面可以有两种关键词“never”和“__always”never是可以避免这个替代的时候使用了过大的代码块。
 + 这个到底使用普通函数还是内联函数是由编译器决定的（如果内联函数里面有循环和开关语句）就直接和普通函数没什么区别了
 + __always其实就是程序的运行效率优先了，不管什么，直接按照内联函数对待了
 
 */






