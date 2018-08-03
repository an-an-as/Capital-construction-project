/**
 ## 概念
 + 链表是线性表的一种，所谓的线性表包含顺序线性表和链表，顺序线性表是用数组实现的，在内存中有顺序排列，通过改变数组大小实现。
 + 链表允许插入和删除表上任意位置上的节点，但是不允许随即存取。链表主要类型有：单向链表、双向链表及循环链表。
 
 ## 作用
 + 链表本质上就是一种数据结构，主要用来动态放置数据。也可用来构建许多数据结构，比如堆栈、队列及它们的派生(相对于数组的插入删除更快)。
 
 ## 区别
 + A singly linked list uses a little less memory than a doubly linked list because it doesn't need to store all those previous pointers.
 + 在数组中所有元素在内存中是连续，所以只需要知道数组中第一个元素的地址以及要获取元素的index就能算出该index内存的地址
 + 因为数组中所有元素的内存是连续的，所以如果想在中间插入一个新的元素，那么这个位置后面的所有元素都要后移，显然是非常低效的。
 + 而链表不是用顺序实现的，用指针实现，在内存中不连续。意思就是说，链表就是将一系列不连续的内存联系起来，将那种碎片内存进行合理的利用，解决空间的问题。
 + 如果使用链表，只要把要插入到的index前后节点的指针赋给这个新的节点就可以了，不需要移动原有节点在内存中的位置
 
 ## Note:
 在计算机科学的理论中，链表对一些常用操作会比数组高效得多。但是实际上，在当代的计算机架构上，CPU 缓存速度非常之快，相对来说主内存的速度要慢一些，这让链表的性能很难与数组相媲美。
 因为数组中的元素使用的是连续的内存，处理器能够以更高效的方式对它们进行访问。
 
 ## Feat
 Persistent data structure
 + 每个节点一旦被创建不可变,将另一个元素添加到链表中并不会复制这个链表，它仅仅只是一个链接在既存的链表的前端的节点
 + 由于enum值语意可共享链表结尾 虽然节点的值通过引用的方式相互关联
 + Most operations on a linked list have O(n) time ,insert new items at the front whenever possible O(1) operation
 
 
 ````
 +--------+    +--------+    +--------+    +--------+
 |        |    |        |    |        |    |        |
 | node 0 |--->| node 1 |--->| node 2 |--->| node 3 |
 |        |    |        |    |        |    |        |
 +--------+    +--------+    +--------+    +--------+
 
 
          +--------+    +--------+    +--------+    +--------+
 head --->|        |--->|        |--->|        |--->|        |  ---> nil
          | node 0 |    | node 1 |    | node 2 |    | node 3 |
 nil <--- |        |<---|        |<---|        |<---|        |  <--- tail
          +--------+    +--------+    +--------+    +--------+
 
 ````
 */
public final class DoubleLinkedList<T> {
    var head: Node?
    init() {}
}
extension DoubleLinkedList {
    public typealias Node = DoubleLinkedListNode<T>
    public class DoubleLinkedListNode<T> {
        var value: T
        var previous: Node?
        var next: Node?
        init(value: T) {
            self.value = value
        }
    }
}
extension DoubleLinkedList {
    convenience init(with array: [T]) {
        self.init()
        array.forEach {
            append($0)
        }
    }
}
extension DoubleLinkedList {
    public var isEmpty: Bool {
        return head == nil
    }
    public var count: Int {
        guard var node = head else { return 0 }
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }
        return count
    }
    public var last: Node? {
        guard var node = head else { return nil }
        while let next = node.next {
            node = next
        }
        return node
    }
}
extension DoubleLinkedList {
    public func findNode(at index: Int) -> Node {
        assert(index > 0 && index < count)
        var current = head
        var initial = 0
        while initial < index {
            current = current?.next
            initial += 1
        }
        return current!
}
extension DoubleLinkedList {
    public func append(_ node: Node) {
        if let last = last {
            last.next = node
            node.previous = last
        } else {
            head = node
        }
    }
    public func append(_ value: T) {
        let node = Node(value: value)
        append(node)
    }
    public func append(_ list: DoubleLinkedList<T>) {
        var current = list.head
        while let next = current {
            append(next)
            current = next.next
        }
    }
}
extension DoubleLinkedList {
    public func insert(_ newNode: Node, at index: Int) {
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            let previousNode = findNode(at: index - 1)
            let currentNode = previousNode.next
            previousNode.next = newNode
            newNode.previous = previousNode
            newNode.next = currentNode
            currentNode?.previous = newNode
        }
    }
    public func insert(_ value: T, at index: Int) {
        let node = Node(value: value)
        insert(node, at: index)
    }
}
extension DoubleLinkedList {
    public func remove(_ node: Node) -> T {
        let prev = node.previous
        let next = node.next
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        node.next = nil
        node.previous = nil
        return node.value
    }
    public func remove(at index: Int) -> T {
        let node = findNode(at: index)
        return remove(node)
    }
    public func removeAll() {
        head = nil
    }
}
// MARK: COMFORMING COLLECTION PROTOCOl
public struct DoubleLinkedListIndex<T>: Comparable {
    fileprivate var node: DoubleLinkedList<T>.DoubleLinkedListNode<T>?
    fileprivate var tag: Int
    public static func == <T> (lhs: DoubleLinkedListIndex<T>, rhs: DoubleLinkedListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    public static func < <T> (lhs: DoubleLinkedListIndex<T>, rhs: DoubleLinkedListIndex<T>) -> Bool {
        return lhs.tag < rhs.tag
    }
}
extension DoubleLinkedList: Collection {
    public typealias Index = DoubleLinkedListIndex<T>
    public var startIndex: Index {
        return DoubleLinkedListIndex(node: head, tag: 0)
    }
    public var endIndex: Index {
        if let head = head {
            return DoubleLinkedListIndex(node: head, tag: count)
        } else {
            return DoubleLinkedListIndex(node: nil, tag: startIndex.tag)
        }
    }
    public func index(after index: Index) -> Index {
        return DoubleLinkedListIndex(node: index.node?.next, tag: index.tag + 1)
    }
    public subscript(position: Index) -> T {
        return position.node!.value
    }
}
extension DoubleLinkedList {
    public func reverse() {
        var currentNode = head
        while let current = currentNode {
            currentNode = current.next
            swap(&current.next, &current.previous)
            head = currentNode
        }
    }
}
extension DoubleLinkedList {
    public func map(transform: (T) -> T) -> DoubleLinkedList {
        let list = DoubleLinkedList()
        var currentNode = head
        while let current = currentNode {
            list.append(transform(current.value))
            currentNode = current.next
        }
        return list
    }
    public func filter(predicate: (T) -> Bool ) -> DoubleLinkedList {
        let list = DoubleLinkedList()
        var currentNode = head
        while let current = currentNode {
            if predicate(current.value) {
                list.append(current)
                currentNode = current.next
            }
        }
        return list
    }
}
extension DoubleLinkedList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init()
        elements.forEach { append($0) }
    }
}
extension DoubleLinkedList: CustomStringConvertible {
    public var description: String {
        return self.map { "\($0)" }.joined(separator: ",\t")
    }
}
extension Sequence where Iterator.Element: Hashable {
    public func selectDictinct() -> [Iterator.Element] {
        var result: Set<Iterator.Element> = []
        return filter {
            return result.insert($0).inserted
        }
    }
}
public struct DoubleLinkedListIterator<T>: IteratorProtocol {
    var head: DoubleLinkedList<T>.DoubleLinkedListNode<T>?
    public mutating func next() -> T? {
        let result = head?.value
        head = head?.next
        return result
    }
}
extension DoubleLinkedList: Sequence {
    public func makeIterator() -> DoubleLinkedListIterator<T> {
        return DoubleLinkedListIterator(head: head)
    }
}
var list = DoubleLinkedList<Int>()
list.append(1)
list.append(1)
list.append(2)
print(list.description)
print(list.selectDictinct())
