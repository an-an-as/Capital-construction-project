//:  IndexDistance 不确定具体类型 不一定是Int32 需要创建一个对所有实现了 BinaryInteger 协议的整型类型都适用的 arc4random_uniform
//:  arc4random_uniform only 接收UInt32 类型 callable up to UInt32.max
//:  BinaryInteger 面向协议的整数实现 IndexDistance 遵循该协议
//:  RangeReplaceableCollection 可以创建一个新的空集合，以及可以将任意序列 (在这里，就是 self) 添加到空集合的后面。这保证了可以进行完全的复制。
import Foundation
extension BinaryInteger{
    static func arc4random_uniform(_ upper_bound:Self)->Self{
        precondition(upper_bound > 0 && UInt32(upper_bound) < UInt32.max,
                     "arc4random_uniform only callable up to \(UInt32.max)")
        return Self(Darwin.arc4random_uniform(UInt32(upper_bound)))
    }
}
extension MutableCollection where Self:RandomAccessCollection{
    mutating func shuffle(){
        var cursor = startIndex
        let beforeEndIndex = index(before: endIndex)
        while cursor < beforeEndIndex {
            let dist = distance(from: cursor, to: endIndex)
            let randomDistance = Int.arc4random_uniform(dist)
            ///IndexDistance' is deprecated: all index distances are now of type Int
            let randomOffset = index(cursor, offsetBy: randomDistance)
            self.swapAt(cursor, randomOffset)
            formIndex(after: &cursor)
        }
    }
}
extension MutableCollection where Self: RandomAccessCollection, Self: RangeReplaceableCollection  {
    func shuffled() -> Self {
        var clone = Self()
        clone.append(contentsOf: self)
        clone.shuffle()
        return clone
    }
}
var arr = [1,2,3,4,5]
let out = arr.shuffled()
print(arr,out, separator: "\n", terminator: "\n")
///[1, 2, 3, 4, 5]
///[4, 1, 5, 3, 2]
