import Foundation
import Darwin

extension BinaryInteger{
    static func arc4random_uniform(_ upper_bound:Self)->Self{
        precondition(upper_bound > 0 && UInt32(upper_bound) < UInt32.max,
                     "arc4random_uniform only callable up to \(UInt32.max)")
        return Self(Darwin.arc4random_uniform(UInt32(upper_bound)))
    }
}
extension MutableCollection where Self:RandomAccessCollection{
    mutating func shuffle(){
        var i = startIndex
        let beforeEndIndex = index(before: endIndex)
        while i < beforeEndIndex {
            let dist = distance(from: i, to: endIndex)
            let randomDistance = IndexDistance.arc4random_uniform(dist)
            let j = index(i, offsetBy: randomDistance)
            self.swapAt(i, j)
            formIndex(after: &i)
        }
    }
}
extension Sequence {
    func shuffled()->[Element]{
        var clone = Array(self)
        clone.shuffle()
        return clone
    }
}

var numbers = Array(1...10).shuffled()
