/************* Terminology ***************/
///Unary operators (Unary Minus Operator , Unary Plus Operator)
///Binary operators
///Ternary operators
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)

//Assignment Operator(Compound Assignment Operators)
let b = 10
var a = 5
a = b
/// a is now equal to 10
let (x, y) = (1, 2)
/// x is equal to 1, and y is equal to 2
if x = y {
/// This is not valid, because x = y does not return a value.
}
var a = 1
a += 2
/// a is now equal to 3 复合赋值运算没有返回值

//Arithmetic Operators
///Addition (+)
///Subtraction (-)
///Multiplication (*)
///Division (/)

//Remainder Operator
9 % 4    /// equals 1

//Comparison Operators
///Equal to (a == b)
///Not equal to (a != b)
///Greater than (a > b)
///Less than (a < b)
///Greater than or equal to (a >= b)
///Less than or equal to (a <= b)
///每个比较运算都返回了一个标识表达式是否成立的布尔值
1 == 1   /// true because 1 is equal to 1
2 != 1   /// true because 2 is not equal to 1
2 > 1    /// true because 2 is greater than 1
1 < 2    /// true because 1 is less than 2
1 >= 1   /// true because 1 is greater than or equal to 1
2 <= 1   /// false because 2 is not less than or equal to 1
let name = "world"
if name == "world" {
    print("hello, world")
} else {
    print("I'm sorry \(name), but I don't recognize you")
}
/// Prints "hello, world", because name is indeed equal to "world".
///比较元组大小会按照从左到右、逐值比较的方式，直到发现有两个值不等时停止。
///Swift 标准库只能比较七个以内元素的元组比较函数。如果你的元组元素超过七个时，你需要自己实现比较运算符。
///Bool 不能被比较
(1, "zebra") < (2, "apple")   /// true，因为 1 小于 2
(3, "apple") < (3, "bird")    /// true，因为 3 等于 3，但是 apple 小于 bird
(4, "dog") == (4, "dog")      /// true，因为 4 等于 4，dog 等于 dog
/// Swift 也提供恒等（===）和不恒等（!==）这两个比较符来判断两个对象是否引用同一个对象实例。


//Nil Coalescing Operator
let defaultColorName = "red"
var userDefinedColorName: String?   ///默认值为 nil
var colorNameToUse = userDefinedColorName ?? defaultColorName
/// userDefinedColorName 的值为空，所以 colorNameToUse 的值为 "red"
userDefinedColorName = "green"
colorNameToUse = userDefinedColorName ?? defaultColorName
/// userDefinedColorName 非空，因此 colorNameToUse 的值为 "green"

//Range Operators
///Closed Range Operator
///闭区间运算符（a...b）定义一个包含从 a 到 b（包括 a 和 b）的所有值的区间。a 的值不能超过 b。 ‌
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}
/// 1 * 5 = 5
/// 2 * 5 = 10
/// 3 * 5 = 15
/// 4 * 5 = 20
/// 5 * 5 = 25

///Half-Open Range Operator
///半开区间运算符（a..<b）定义一个从 a 到 b 但不包括 b 的区间。 之所以称为半开区间，是因为该区间包含第一个值而不包括最后的值。
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    print("第 \(i + 1) 个人叫 \(names[i])")
}
/// 第 1 个人叫 Anna
/// 第 2 个人叫 Alex
/// 第 3 个人叫 Brian
/// 第 4 个人叫 Jack

///One-Sided Ranges
for name in names[2...] {
    print(name)
}
/// Brian
/// Jack
for name in names[...2] {
    print(name)
}
/// Anna
/// Alex
/// Brian
for name in names[..<2] {
    print(name)
}
/// Anna
/// Alex

let range = ...5
range.contains(7)   /// false
range.contains(4)   /// true
range.contains(-1)  /// true


//Logical Operators
///Logical NOT (!a)
let allowedEntry = false
if !allowedEntry {
    print("ACCESS DENIED")
}/// Prints "ACCESS DENIED"

///Logical AND (a && b)
let enteredDoorCode = true
let passedRetinaScan = false
if enteredDoorCode && passedRetinaScan {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}/// Prints "ACCESS DENIED"

///Logical OR (a || b)
let hasDoorKey = false
let knowsOverridePassword = true
if hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}/// Prints "Welcome!"

///Combining Logical Operators
if enteredDoorCode && passedRetinaScan || hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
/// Prints "Welcome!"

///Explicit Parentheses
///使用括号明确优先级
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
/// Prints "Welcome!"
