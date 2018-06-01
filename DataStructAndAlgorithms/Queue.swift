///因为线性队列分为顺序存储和链式存储，所以栈可以分为链栈和顺序栈，队列也可分为顺序队列和链队列。
///队列就是进行排队的数据结构，一个队列肯定是线性结构了，之所以称之为队列，是因为有着先入先出（FIFO ----first in first out）的特性
///而栈就与队列相反了，栈具有先入后出（FILO -- first in last out）的特性
///因为数组是在连续的内存中持有元素的，所以移除非数组尾部元素时，其他每个元素都需要移动去填补空白，这个操作的复杂度会是 O(n) (而出栈最后一个元素只需要常数的时间就能完成)
import Foundation
protocol Queue {
    associatedtype Element
    mutating func enQueue(_ value:Element)
    mutating func deQueue() -> Element?
}
struct FIFOQueue<Element>:Queue {
    fileprivate var operationArray = [Element]()
    fileprivate var storageArray = [Element]()
    mutating func enQueue(_ value: Element) {
        storageArray.append(value)
    }
    mutating func deQueue() -> Element? {
        if operationArray.isEmpty {
            operationArray = storageArray.reversed()//O(n)
            storageArray.removeAll()
        }
        return operationArray.popLast()//O(1) 平摊耗时
    }
}
extension FIFOQueue: MutableCollection {
    var startIndex: Int { return 0 }
    var endIndex: Int {
        return storageArray.count + operationArray.count
    }
    func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    subscript(position:Int) -> Element {
        get {
            precondition((0...endIndex).contains(position), "out of range")
            if position < operationArray.count {
                return operationArray[operationArray.count - position - 1]
                //// operation逆向索引: 1 2 3  -> 3 2 >1< -> 3 2   storage正向索引:4,5
            } else {
                return storageArray[position - operationArray.count]
                ///超出operation range
            }
        }
        set {
            precondition((0...endIndex).contains(position), "out of range")
            if position < operationArray.count {
                operationArray[operationArray.count - position - 1] = newValue
            } else {
                storageArray[position - operationArray.count] = newValue
            }
        }
    }
}
extension FIFOQueue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.init(operationArray: elements.reversed(), storageArray: [])
    }
}
extension FIFOQueue: CustomStringConvertible {
    var description: String {
        let element1 = operationArray.reversed().map{ "\($0)" }.joined(separator: ", ")
        let element2 = storageArray.map{ "\($0)" }.joined(separator: ", ")
        return "\(element1),\(element2)"
    }
}
extension FIFOQueue: TextOutputStreamable {
    func write<Target>(to target: inout Target) where Target : TextOutputStream {
        target.write("[")
        target.write(map{ String(describing: $0) }.joined(separator: ", "))
        target.write("]")
    }
}
var list: FIFOQueue = [1,2,3,4,5]
let out = list.deQueue() ///Optional(1)
list.enQueue(6)
print(list)///[2, 3, 4, 5,6]
