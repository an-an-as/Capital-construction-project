import Foundation
// Int
// 从给定的浮点值创建一个整数, 舍入到零。作为source传递的值的任何小数部分都将被删除。
let x = Int(21.5)
/// x == 21
let y = Int(-21.5)
/// y == -21
///let z = UInt(-21.5)
/// Error: ...outside the representable range

// 转换精确表示的浮点数(无小数)
let x2 = Int(exactly: 21.0)
/// x2 == Optional(21)
let y2 = Int(exactly: 21.5)
/// y2 == nil

// CGFloat
let x3 = Int(21.5 as CGFloat)
// x3 == 21
let y3 = Int(-21.5 as CGFloat)
// y3 == -21

// NSNumber
let w = 21.0 as NSNumber
let x4 = Int(exactly: w)
// x4 == Optional(21)
let y4 = 21.5 as NSNumber
let z4 = Int(exactly: y)
// z4 == nil


// Double
let x: Double = 21.25
let y = Double(x)
// y == 21.25

let z = Double(Double.nan)
// z.isNaN == true

let x2 = Double(sign: .plus, exponent: 3, significand: 5) // 2^3 * 5
print(x2)


let a = -2.0
let b = 111.11
let c = Double(signOf: a, magnitudeOf: b)
print(c)
// Prints "-111.11" 使用a的符号 使用b的大小

