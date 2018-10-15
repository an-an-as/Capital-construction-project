import Foundation
infix operator **:
func ** (lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}
func ** (lhs: Float, rhs: Float) -> Float {
    return powf(lhs, rhs)
}
func **<I: BinaryInteger>(lhs: I, rhs: I) -> I {
    let result = Double(Int64(lhs)) ** Double(Int64(rhs))
    return I(result)
}
// 2 ** 3 error
let intResult: Int = 2 ** 3

func raise(_ base: Double, to exponent: Double) -> Double {
    return pow(base, exponent)
}
_ = raise(2, to: 3)

prefix operator &&&
postfix operator ***

