/**:
 1.数据结构整体可以分为物理结构和逻辑结构，物理结构指的是数据在磁盘、内存等硬件上的存储结构，主要包括顺序结构和链式结构
   而逻辑结构是数据本身所形成的结构，包括集合结构、线性结构、树形结构以及图形结构
 2.数组是相同数据类型的元素按一定顺序排列的集合,是物理上存储在一组连续的地址
 3.线性表是数据结构中的逻辑结构。可以存储在数组上(顺序存储)，也可以存储在链表上(链式存储),用数组来存储的线性表就是顺序表
 4.数组通过系统给数组分配了一块内存。线性表的大小是可变动态分配
 - 末尾追加元素
 - 索引元素下标
 - 根据下标修改元素
 - 根据下标插入元素
 - 移除元素
 */
import Foundation
public struct SequenceList<Element:Equatable> {
    private var list: NSMutableArray
    private(set) public var count = 0
    public var capacity = 0
    init(capacity:Int){
        self.capacity = capacity
        list = NSMutableArray(capacity: capacity)
    }
    func fetchValue(_ index:Int) -> Element? {
        assert(index >= 0 && index < count)
        
        return list[index] as? Element
    }
    mutating func append(newValue value:Element) {
        list[count] = value
        count += 1
    }
    mutating func insert(newElement element:Element, at index:Int) {
        assert(index >= 0 && index <= count)
        var endIndex = count
        while index < endIndex {
            list[endIndex] = list[endIndex - 1]
            endIndex -= 1
        }
        list[index] = element
        count += 1
    }
    mutating func remove(element:Element) {
        if index != 0 {
            for cursor in index..<count - 1 {
                list[cursor] = list[cursor + 1 ]
            }
        }
        list.removeLastObject()
        count -= 1
        list.removeLastObject()
        count -= 1
    }
    private func index(element:Element) -> Int? {
        var currentIndex = 0
        while currentIndex < count - 1 {
            if list[currentIndex] as! Element == element  {
                return currentIndex
            } else {
                currentIndex += 1
            }
        }
        return nil
    }
}
extension SequenceList: CustomDebugStringConvertible {
    public var debugDescription: String{
        return list.enumerated().map { "\($0.offset) = \($0.element)" }.joined(separator: ", ") + "\n"
    }
}
var arr = SequenceList<Int>(capacity: 5)
arr.append(newValue: 1)
arr.append(newValue: 3)
arr.insert(newElement: 2, at: 1)
arr.remove(element: 1)
print(arr.debugDescription,arr.count,arr.capacity)
