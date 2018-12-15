// 值的大小取的是绝对值
let x = -200
/// x.magnitude == 200

// 取绝对值
let x2 = Int8.min
/// x == -128
let y = abs(x)
/// Overflow error
/// x的绝对值必须在同一类型中可表示。不能表示有符号、固定宽度整数类型的最小值。

// 检测是否为负值
// 如果此值为负值返回-1,如果值为正数返回1,否则返回0.
print(-100.signum()) // -1

print(Int.max, Int.min, Int.isSigned, separator: "\n", terminator: "\n")
/// 127 -128 true

//Double
print(Double.pi)
/// Prints "3.141592653589793"

let x = Double.greatestFiniteMagnitude /// 大于或等于所有有限数, 但小于infinity.
let y = x * 2
/// y == Double.infinity
/// y > x

//不是一个数字
print(Double.nan)
print(Double.leastNonzeroMagnitude)

let x2 = -0.0
x2.isZero               /// true
x2 == 0.0               /// true
print(11.2.isFinite)    /// true  除nan 和无穷大之外的所有值都被认为是有限的
print(0.0.isNormal)     /// false 正常值是可用的全部精度的有限数字。0既不是一个正常数字, 也不是一个超常数字

let lessThanFive = 0.0..<5.0
print(lessThanFive.contains(3.14))  // Prints "true"
print(lessThanFive.contains(5.0))   // Prints "false"

