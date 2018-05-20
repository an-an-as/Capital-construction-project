/**:
 1.数据结构整体可以分为物理结构和逻辑结构，物理结构指的是数据在磁盘、内存等硬件上的存储结构，主要包括顺序结构和链式结构
   而逻辑结构是数据本身所形成的结构，包括集合结构、线性结构、树形结构以及图形结构
 2.数组是相同数据类型的元素按一定顺序排列的集合,是物理上存储在一组连续的地址
 3.线性表是数据结构中的逻辑结构。可以存储在数组上(顺序存储)，也可以存储在链表上(链式存储),用数组来存储的线性表就是顺序表
 4.数组通过系统给数组分配了一块内存。线性表的大小是可变动态分配
 - 末尾追加元素
 - 根据下标索引元素
 - 根据下标修改元素
 - 根据下标插入值
 - 根据下标移除元素
 */
import Foundation
public class SequenceList<Element> {
    private var list: NSMutableArray
    private(set) public var count = 0
    public var capacity = 0
    public init(capacity: Int) {
        self.capacity = capacity
        list = NSMutableArray(capacity: capacity)
    }
}
extension SequenceList {
    func append(_ newElement: Element) {
        list[count] = newElement
        count += 1
    }
    @discardableResult
    func fetchValue(_ index: Int) -> Element? {
        assert(index >= 0 && index < count, "Invalid index")
        return list[index] as? Element /// NSMutableArray: Any
    }
    @discardableResult
    func updateValue(_ index: Int, value: Element) -> Element? {
        assert(index >= 0 && index < count, "Invalid index")
        let oldValue = list[index]
        list[index] = value
        return oldValue as? Element
    }
    func insert(_ newElement: Element, index: Int)  {
        assert(index >= 0 && index < count, "Invalid index")
        var endIndex = count
        ///元素后移操作0 1 2 3 endIndex index = 1 < 4
        while index < endIndex {
            list[endIndex] = list[endIndex-1]
            endIndex -= 1
        }
        list[index] = newElement
        count += 1
    }
    func remove(_ index: Int)  {
        assert(index >= 0 && index < count, "Invalid index")
        for i in index..<count-1 {
            list[i] = list[i+1]
        }
        count -= 1
        list.removeLastObject()
    }
}
extension SequenceList:CustomDebugStringConvertible {
    public var debugDescription: String {
        var str = ""
        for (index,value) in list.enumerated(){
            str += "index:\(index) -> \(value)" + "\n"
        }
        return str
    }
}
///test
var arr = SequenceList<Int>(capacity: 5)
arr.append(3)
arr.append(1)
arr.remove(0)
arr.updateValue(0, value: 10)
arr.insert(100, index: 0)
arr.fetchValue(0)
print(arr.debugDescription,arr.count)
