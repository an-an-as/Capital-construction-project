/** ____________________________________________________________________________________________________
 
 1. 数据结构整体可以分为物理结构和逻辑结构，物理结构指的是数据在磁盘、内存等硬件上的存储结构，主要包括顺序结构和链式结构
    而逻辑结构是数据本身所形成的结构，包括集合结构、线性结构、树形结构以及图形结构
 2. 数组是相同数据类型的元素按一定顺序排列的集合,是物理上存储在一组连续的地址
 3. 线性表是数据结构中的逻辑结构。可以存储在数组上(顺序存储)，也可以存储在链表上(链式存储),用数组来存储的线性表就是顺序表
 4. 数组通过系统给数组分配了一块内存。线性表的大小是可变动态分配
 ________________________________________________________________________________________________________*/
public final class SequenceList<T> {
    private var list = [T]()
    private(set) var count = 0
}
extension SequenceList: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        return AnyIterator { self.list.popLast() }
    }
}
extension SequenceList {
    public subscript(pos: Int) -> T {
        get {
            return getValue(at: pos)
        }
        set {
            replace(newValue, at: pos)
        }
    }
}
extension SequenceList {
    @discardableResult
    public func getValue(at index: Int) -> T {
        assert(index >= 0 && index < count)
        return list[index]
    }
}
extension SequenceList {
    public func replace(_ newValue: T, at index: Int) {
        assert(index >= 0 && index < count)
        list[index] = newValue
    }
}
extension SequenceList {
    public func append(_ newValue: T) {
        list[count] = newValue
        count += 1
    }
    public func insert(_ newValue: T, at index: Int) {
        assert(index >= 0 && index <= count)
        var endIndex = count
        while index < endIndex {
            list[endIndex] = list[endIndex - 1]
            endIndex -= 1
        }
        list[index] = newValue
        count += 1
    }
}
extension SequenceList where T: Comparable {
    public func remove(_ value: T) {
        guard var index = list.index(of: value) else { return }
        while index < count - 1 {
            list[index] = list[index + 1]
            index += 1
        }
        list.removeLast()
        count -= 1
    }
}
extension SequenceList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init()
        list.append(contentsOf: elements)
        count = elements.count
    }
}
extension SequenceList: CustomStringConvertible {
    public var description: String {
        return list.map { "\($0)" }.joined(separator: "\t")
    }
}
extension SequenceList: CustomDebugStringConvertible {
    public var debugDescription: String {
        return list.enumerated().map { "\($0.offset)\t\($0.element)" }.joined(separator: "\n")
    }
}
