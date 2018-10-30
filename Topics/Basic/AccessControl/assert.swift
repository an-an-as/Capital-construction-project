///概念:断言和先决条件是会在运行时进行的检查手段。在执行任何其他代码之前确保基本条件已经满足。
///    如果断言或前提条件中的布尔条件为true，则代码照常执行。
///    如果条件为false，那么程序当前处于无效状态；代码会结束执行，程序终止。
///作用:使用断言和先决条件你可以表达出你需要的期望条件
///    在开发过程中，断言可帮助你发现错误和不正确的假设条件，先决条件可帮助你检测发布后的问题
///    强制执行有效的数据，会使你的应用程序在错误发生并被强制终止时，更具备可监测性，而且有助于调试。
///    一旦检测到无效状态，停止执行也有助于将其引起的损坏最小化
///特点:断言和先决条件不用于可恢复的或期望的错误，因为失败的断言或先决条件表示无效的程序状态，所以无法捕获失败的断言
///区别:断言仅在调试版本中执行,在发布版本中，断言内的条件不再被执行。在调试和发布版本中先决条件都会被执行

//assert
let age = -3
assert(age >= 0, "A person's age can't be less than zero.")
/// This assertion fails because -3 is not >= 0.如果表达式的结果为false，则显示这段文字
if age > 10 {
    print("You can ride the roller-coaster or the ferris wheel.")
} else if age > 0 {
    print("You can ride the ferris wheel.")
} else {
    assertionFailure("A person's age can't be less than zero.")
    ///使用assertionFailure(_:file:line:)方法来标明断言失败了
}/// 运行时错误Thread 1: Assertion failed: A person's age can't be less than zero.


//Enforcing Preconditions
precondition(index > 0, "Index must be greater than zero.")
preconditionFailure(_:file:line:)


//fatalError()
///无条件执行 Unconditionally prints a given message and stops execution.


//自定义发生运行时错误的消息
///通常可能会选择在调试版本或者测试版本中进行断言，让程序崩溃，但是在最终产品中，可能会把它替换成像是零或者空数组这样的默认值
infix operator !!
func !!<T>(loptional: T?, errorMsg: @autoclosure () -> String) -> T {
    if let value = optional { return value }
    fatalError(errorMsg)
}
var record = ["name": "11"]
record["type"] !! "Do not have a key named type"

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
record["type"]?.write(" account") !? "Do not have a key named type"
/// 想要挂起一个操作我们有三种方式。首先，fatalError 将接受一条信息，并且无条件地停止操作。
/// 第二种选择，使用 assert 来检查条件，当条件结果为 false 时，停止执行并输出信息。在发布版本中，assert 会被移除掉，条件不会被检测，操作也永远不会挂起。
/// 第三种方式是使用 precondition，它和 assert 比较类型，但是在发布版本中它不会被移除，也就是说，只要条件被判定为 false，执行就会被停止。
