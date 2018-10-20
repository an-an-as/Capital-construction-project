import Foundation
//例如:
protocol Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool
}
//使用:
struct MonetaryAmount: Equatable {
    var currency: String
    var amountInCents: Int
    static func == (lhs: MonetaryAmount, rhs: MonetaryAmount) -> Bool {
        return lhs.currency == rhs.currency && lhs.amountInCents == rhs.amountInCents
    }
}
/// 不能简单地用 Equatable 来作为类型进行变量声明 (不同的类型存在不同的变量 相互存在着不可比较的可能 所以只能通过Self限定在自身)
//  let x: Equatable = MonetaryAmount(currency: "EUR", amountInCents: 100)
/// 错误：因为 'Equatable' 中有 Self 或者关联类型的要求, 所以它只能被用作泛型约束
/// 如果 Equatable 能够被用作独立的类型，那我们就能够写这样的代码：
//  let x: Equatable = MonetaryAmount(currency: "EUR", amountInCents: 100)
//  let y: Equatable = "hello"
//  x == y
/// 而 == 并不能接受一个字符串作为输入。你要怎么比较它们两者呢？虽然不能用作独立类型，不过我们可以将 Equatable 用作泛型约束

//用作泛型约束:
func allEqual<E: Equatable>(array: [E]) -> Bool {
    guard let firstElement = array.first else { return true }
    for element in array {
        guard element == firstElement else { return false }
    }
    return true
}
///或
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        guard let firstElement = first else { return true }
        for element in self {
            guard element == firstElement else { return false }
        }
        return true
    }
}
/// == 运算符被定义为了类型的静态函数。换句话说，它不是成员函数，对该函数的调用将被静态派发。与成员函数不同，我们不能对它进行重写。



class IntegerRef: NSObject {
    let int: Int
    init(_ int: Int) {
        self.int = int
    }
}
func == (lhs: IntegerRef, rhs: IntegerRef) -> Bool {
    return lhs.int == rhs.int
}
let one = IntegerRef(1)
let otherOne = IntegerRef(1)
one == otherOne /// true

let two: NSObject = IntegerRef(2)
let otherTwo: NSObject = IntegerRef(2)
two == otherTwo /// false
///NSObject 的 == 就将被使用，而这个运算符在底层使用的是 === 来检查引用是否指向同一个对象  (除非你留意到静态派发的行为)


