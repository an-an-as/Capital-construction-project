/**** Closure Expressions ****/
///Closures are self-contained blocks of functionality that can be passed around and used in your code.
///Nested functions, are a convenient means of naming and defining self-contained blocks of code as part of a larger function.
///Closure expressions are a way to write inline closures in a brief, focused syntax.
///闭包是自包含的函数代码块，可以在代码中被传递和使用
///闭包可以捕获和存储其所在上下文中任意常量和变量的引用。被称为包裹常量和变量
///
///一个函数加上它捕获的变量一起，才算一个closure

//The Sorted Method
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
///The sorted(by:) the sorting closure needs to be a function of type (String, String) -> Bool.

//Closure Expression Syntax
{ (parameters) -> return type in
    statements
}
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )

//Inferring Type From Context
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

//Implicit Returns from Single-Expression Closures
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

//Shorthand Argument Names
reversedNames = names.sorted(by: { $0 > $1 } )

//Operator Methods
reversedNames = names.sorted(by: >)

//Trailing Closures
///If you need to pass a closure expression to a function as the function’s final argument and the closure expression is long,
///it can be useful to write it as a trailing closure instead.
func someFunctionThatTakesAClosure(closure: () -> Void) { // function body goes here}
/// Here's how you call this function without using a trailing closure:
someFunctionThatTakesAClosure(closure: { /**closure's body goes here}*/} )
someFunctionThatTakesAClosure() { /**trailing closure's body goes here*/ }
reversedNames = names.sorted() { $0 > $1 }
reversedNames = names.sorted { $0 > $1 }
    
let digitNames = [
        0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
        5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
/// strings is inferred to be of type [String]
///its value is ["OneSix", "FiveEight", "FiveOneZero"]


//Capturing Values
///A closure can capture constants and variables from the surrounding context in which it is defined.
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen()/// 返回的值为10
incrementByTen()/// 返回的值为20
incrementByTen()/// 返回的值为30
let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
incrementByTen()
/// 返回的值为40

//Closures Are Reference Types
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
/// returns a value of 50

/******************************** Escaping Closures **********************************/
///A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the function returns.
///当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。一种能使闭包“逃逸”出函数的方法是，将这个闭包保存在一个函数外部定义的变量中
///escaping closure和non escaping closure。对于后者而言，使用它们相对是安全的，我们无需过多关心循环引用的问题
///当把一个closure用作函数参数时，默认都是non escaping属性的，也就是说，它们只负责执行逻辑，但不会被外界保存和使用
///之所以要使用@escaping来修饰closure参数，是为了时刻提醒不要让它们成为脱缰的野马,把一个外部的closure传递给@escaping参数的时候，你也要时刻记着可能会创建循环引用
///认真考虑是否需要在closure内使用capture list来避免这个问题。
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
///Marking a closure with @escaping means you have to refer to self explicitly within the closure
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}
class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }/// 逃逸延迟执行
        someFunctionWithNonescapingClosure { x = 200 }  /// 先执行
    }
}
let instance = SomeClass()
instance.doSomething()
print(instance.x)
/// 打印出 "200"
completionHandlers.first?()
print(instance.x)
/// 延迟赋值 打印出 "100"

//默认为escaping的情况
///如果closure被封装在一个optional里，它默认是escaping的
func calc(_ n: Int, by: ((Int) -> Int)?) -> Int {
    guard let by = by else { return n }
    return by(n)
}
    

/************************** Autoclosures **************************/
///An autoclosure is a closure that is automatically created to wrap an expression that’s being passed as an argument to a function.
///It doesn’t take any arguments, and when it’s called, it returns the value of the expression that’s wrapped inside of it
///The code below shows how a closure delays evaluation.
/**
 概念：print("Now serving \(customerProvider())!")
 - 自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。
 - 这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。
 - 这种便利语法让你能够省略闭包的花括号，用一个普通的表达式来代替显式的闭包。
 - 我们经常会调用采用自动闭包的函数，但是很少去实现这样的函数。
 作用：
 - 自动将表达式包装传递给函数
 特点：
 - 不接受任何参数
 - 自动闭包让你能够延迟求值，因为直到你调用这个闭包，代码段才会被执行。
 - 延迟求值对于那些有副作用（Side Effect）和高计算成本的代码来说是很有益处的，因为它使得你能控制代码的执行时机。
 副作用
 - 过度使用 autoclosures 会让你的代码变得难以理解。上下文和函数名应该能够清晰地表明求值是被延迟执行的*/
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)/// Prints "5"
    
let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)/// Prints "5"
    
print("Now serving \(customerProvider())!")/// Prints "Now serving Chris!"
print(customersInLine.count)/// Prints "4"
/// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
    
/// same behavior of delayed evaluation when you pass a closure as an argument to a function:
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
/// Prints "Now serving Alex!"
/// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
/// Prints "Now serving Ewa!

/// customersInLine is ["Barry", "Daniella"]
/// autoclosure that is allowed to escape, use both the @autoclosure and @escaping attributes.
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))
print("Collected \(customerProviders.count) closures.")
/// Prints "Collected 2 closures."
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")
}
/// Prints "Now serving Barry!"
/// Prints "Now serving Daniella!"

//模拟short circuit
func logicAnd(_ l: Bool, _ r: Bool) -> Bool {
    guard l else { return false }
    return r
}
let numbers: [Int] = []
if !numbers.isEmpty && numbers[0] > 0 {
    /// This works
    /// 对于多个逻辑与&&串联的情况，如果某一个表达式的值为false就不再继续评估后续的表达式了
    /// 对于多个逻辑或||串联的情况，如果某一个表达式的值为true就不再继续评估后续的表达式了
}
if logicAnd(!numbers.isEmpty, numbers[0] > 0) {
    /// This failed
}
///原因: 函数在执行前，要先评估它的所有参数，在评估到numbers[0]的时候，发生了运行时异常。
///解决: 把通过第二个参数获取Bool值的过程，封装在一个函数里。在评估logicAnd参数的时候，会评估到一个函数类型。把真正获取Bool的动作，推后到函数执行的时候
let numbers2: [Int] = []
func logicAnd(_ l: Bool, _ r:  () -> Bool) -> Bool {
    ///不方便的是要时刻记着第二个Bool表达式要通过一个closure来表示。这显然是一个有违直觉的事情 所以@autoclosure
    guard l else { return false }
    return r()
}
if logicAnd(!numbers.isEmpty, { numbers[0] > 0 }) {}
