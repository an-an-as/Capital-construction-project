/** ____________________________________________________________________________________________________
 
 1. 数据结构整体可以分为物理结构和逻辑结构，物理结构指的是数据在磁盘、内存等硬件上的存储结构，主要包括顺序结构和链式结构
    而逻辑结构是数据本身所形成的结构，包括集合结构、线性结构、树形结构以及图形结构
 2. 数组是相同数据类型的元素按一定顺序排列的集合,是物理上存储在一组连续的地址
 3. 线性表是数据结构中的逻辑结构。可以存储在数组上(顺序存储)，也可以存储在链表上(链式存储),用数组来存储的线性表就是顺序表
 4. 数组通过系统给数组分配了一块内存。线性表的大小是可变动态分配
 ________________________________________________________________________________________________________*/
import Foundation
public struct SequenceList<Element: Equatable> {
    private var list: NSMutableArray
    private(set) var count = 0
    init(capacity: Int) {
        list = NSMutableArray(capacity: capacity)
    }
}
extension SequenceList {
    public mutating func append(newValue: Element) {
        list[count] = newValue
        count += 1
    }
    public mutating func insert(newValue: Element, at index: Int) {
        assert(index >= 0 && index <= count)
        var endIndex = count
        while index < endIndex {
            list[endIndex] = list[endIndex - 1]
            endIndex -= 1
        }
        list[index] = newValue
        count += 1
    }
    public mutating func remove(_ value: Element) {
        assert(list.contains(value))
        var index = list.index(of: value)
        while index < count - 1 {
            list[index] = list[index + 1]
            index += 1
        }
        list.removeLastObject()
        count -= 1
    }
    public mutating func replace(newValue: Element, at index: Int) {
        assert(index >= 0 && index <= count)
        list[index] = newValue
    }
}
extension SequenceList {
    public subscript (index: Int) -> Element? {
        get {
            assert(index >= 0 && index <= count)
            return list[index] as? Element
        }
        set {
            newValue.map {
                replace(newValue: $0, at: index)
            }
        }
    }
}
extension SequenceList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(capacity: elements.count)
        elements.forEach {
            append(newValue: $0)
        }
        count = elements.count
    }
}
extension SequenceList: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "[" + list.map { "\($0)" }.joined(separator: ", ") + "]"
    }
    public var debugDescription: String {
        return list.enumerated().map { "\($0.offset) -> \($0.element)" }.joined(separator: "\n")
    }
}
var list: SequenceList = [1]
list.append(newValue: 2)
list.insert(newValue: 0, at: 0)
list[0] = 1_000
list.remove(1)
print(list.description, list.debugDescription, separator: "\n", terminator: "\n")
