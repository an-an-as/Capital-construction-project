/** ____________________________________________________________________________________________________
 
 1. 数据结构整体可以分为物理结构和逻辑结构，物理结构指的是数据在磁盘、内存等硬件上的存储结构，主要包括顺序结构和链式结构
    而逻辑结构是数据本身所形成的结构，包括集合结构、线性结构、树形结构以及图形结构
 2. 数组是相同数据类型的元素按一定顺序排列的集合,是物理上存储在一组连续的地址
 3. 线性表是数据结构中的逻辑结构。可以存储在数组上(顺序存储)，也可以存储在链表上(链式存储),用数组来存储的线性表就是顺序表
 4. 数组通过系统给数组分配了一块内存。线性表的大小是可变动态分配
 ________________________________________________________________________________________________________*/
public struct SequenceList<Element:Comparable> {
    typealias Index = Int
    fileprivate var list: ContiguousArray<Element>
    fileprivate(set) var count = 0
    init(capacity: Int) {
        list = ContiguousArray.init()
        list.reserveCapacity(capacity)
    }
    mutating func append(_ newElement:Element) {
        list[count] = newElement
        count += 1
    }
    mutating func insert(_ newElement: Element, at index: Index) {
        assert(index >= 0 && index <= count)
        var endIndex = count
        while index < endIndex {
            defer{ endIndex -= 1 }
            list[endIndex] = list[endIndex - 1]
        }
        list[index] = newElement
        count += 1
    }
    mutating func remove(_ element: Element) {
        findIndex(of: element).map{ index in
            (index ..< count - 1).forEach {
                list[$0] = list[$0 + 1]
            }
            list.removeLast()
            count -= 1
        }
    }
    fileprivate func findIndex(of element: Element) -> Index? {
        var cursor = 0
        while cursor < count {
            if list[cursor] == element {
                return cursor
            } else {
                cursor += 1
            }
        }
        return nil
    }
}
extension SequenceList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(capacity: elements.count)
        list.append(contentsOf: elements)
        count = elements.count
    }
}
extension SequenceList: CustomStringConvertible {
    public var description: String {
        return list.enumerated().map { " \($0.offset) -> \($0.element) " }.joined(separator: "\n")
    }
}
