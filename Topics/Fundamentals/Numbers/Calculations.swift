// Int
var x = 21
x.negate()
/// x == -21
///var y = Int8.min
///y.negate()
/// Overflow error

// 将商和整数分离
let x2 = 10
let tuple = x2.quotientAndRemainder(dividingBy: 3)
print(tuple.quotient) /// 3
print(tuple.remainder)/// 1

let value = 89.advanced(by: 1)     // 90
let value2 = 100.distance(to: 200) // 100


// Double
// 加上一个乘数
var value = 1.0
value.addProduct(3.0, 3.0) // value + 3.0 * 3.0 = 10
let value2 = 2.3.addingProduct(3.12, 3.33)

// 平方根
func hypotenuse(_ a: Double, _ b: Double) -> Double {
    return (a * a + b * b).squareRoot()
}
let (dx, dy) = (3.0, 4.0)
let distance = hypotenuse(dx, dy)
/// distance == 5.0

// 取余
print(10 % 3)                                         /// 1
print(10.0.remainder(dividingBy: 3.1415926))          /// 0.5752221999999998
print(10.0.truncatingRemainder(dividingBy: 3.1415926))/// 0.5752221999999998

let x = 8.625
print(x / 0.75)                              /// 11.5
let q = (x / 0.75).rounded(.toNearestOrEven) /// q == 12.0
let r = x.remainder(dividingBy: 0.75)        /// r == -0.375
let x1 = 0.75 * q + r                        /// x1 == 8.625

var x2 = 8.625
print(x2 / 0.75)                                 /// 11.5
let q2 = (x2 / 0.75).rounded(.towardZero)        /// q2 == 11.0
let r2 = x2.truncatingRemainder(dividingBy: 0.75)/// r2 == 0.375
let xx = 0.75 * q + r                            /// xx == 8.625

//四舍五入
///使用.toNearestOrAwayFromZero规则
_ = (5.2).rounded() /// 5.0
_ = (5.5).rounded() /// 6.0
_ = (-5.2).rounded()/// -5.0
_ = (-5.5).rounded()/// -6.0
let z = 6.5
/// Equivalent to the C 'round' function:
print(z.rounded(.toNearestOrAwayFromZero)) /// 7.0
/// Equivalent to the C 'trunc' function:
print(z.rounded(.towardZero))              /// 6.0
/// Equivalent to the C 'ceil' function:
print(z.rounded(.up))                      /// 7.0
/// Equivalent to the C 'floor' function:
print(z.rounded(.down))                    /// 6.0

// 比较
let x3 = 15.0
_ = x3.isEqual(to: 15.0)                       /// true
_ = x3.isEqual(to: .nan)                       /// false
_ = Double.nan.isEqual(to: .nan)               /// false
print(x3.isLess(than: Double.infinity))        /// true
print(x3.isLessThanOrEqualTo(Double.infinity)) /// true

var numbers = [2.5, 21.25, 3.0, .nan, -9.5]
numbers.sort { $0.isTotallyOrdered(belowOrEqualTo: $1) }/// numbers == [-9.5, 2.5, 3.0, 21.25, NaN]
print(numbers.sort()) // nil

_ = Double.minimum(10.0, -25.0)/// -25.0
_ = Double.minimum(10.0, .nan) /// 10.0
_ = Double.minimum(.nan, -25.0)/// -25.0
_ = Double.minimum(.nan, .nan) /// nan

_ = Double.minimumMagnitude(10.0, -25.0) /// 10.0  以数字大小为准
_ = Double.minimumMagnitude(10.0, .nan)  /// 10.0
_ = Double.minimumMagnitude(.nan, -25.0) /// -25.0
_ = Double.minimumMagnitude(.nan, .nan)   //// nan

//[浮点数精度](https://www.cnblogs.com/davidwang456/p/4050465.html)i
import Foundation
var x: Double = 1.0
var numFloats = 0
while x <= 2.0 {
    numFloats += 1
    x = x.nextUp
}
print(numFloats) ///结果是 1.0 和 2.0 之间包含 8,388,609 个浮点数,
/// 相邻数字的距离为 0.0000001
/// 这个距离称为 ULP，它是最小精度单位（unit of least precision）或 最后位置单位（unit in the last place）的缩略。
print(1.0.nextUp)   /// 1.0000000000000002
print(1.0.nextDown) /// 0.9999999999999999
print(1.0.ulp)

let y: Double = 21.5
/// y.significand == 1.34375
/// y.exponent == 4
/// Double.radix == 2
/// 2 * 2 * * 2 * 1.24375
print(16 * 1.34375)


/**
 比方说2.0和3.0之间有多少个数，在数学中是无限的，但是在计算机中是有限的，
 因为计算机需要用一堆字节来表示double或者float，但是因为计算机表示不了无限的数（因为没有无限内存,所以就有了ulp
 假设在float 2.0和3.0之间有8,388,609个数，那么在2.0和3.0之间的数的ulp就是8,388,609/1.0约等于0.0000001。
 
 实数是非常密集的。任意两个不同的实数中间都可以出现其他实数。但浮点数则不是这样。
 对于浮点数和双精度数，也存在下一个浮点数；连续的浮点数和双精度数之间存在最小的有限距离。nextUp()方法返回比第一个参数大的最近浮点数
 */

let x2 = 21.5
/// x2.significand == 1.34375
/// x2.exponent == 4

let y2 = x.binade
/// y2 == 16.0
/// y2.significand == 1.0
/// y2.exponent == 4
