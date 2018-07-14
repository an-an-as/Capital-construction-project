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
 SinglyLinkedLis    IndirectStorage        SinglyLinkedListNode
 +--------+          +--------+            +--------+          +--------+           +--------+
 indeirect           head:                 |        |          |        |           |        |
 storage  ------>    tail:        -------> | node 0 |------->  | node 1 |------->   | node 3 |-------> nil
 |        |  next    |        |  next      |        |  next    |        |           |        |
 +--------+          +--------+            +--------+          +--------+           +--------+
 ^                                                 ^
 |                                                 |
 Head                                           Tail
 
 ````
 
 */
protocol  Queue {
    associatedtype Element
    mutating func enqueue(_ value: Element)
    mutating func dequeue() -> Element?
    func getFirst() -> Element?
}
public class SinglyLinkedListNode<T> {
    var value: T
    var next: SinglyLinkedListNode<T>?
    init(value: T) {
        self.value = value
    }
}
private class IndirectStorage<T> {
    var head: SinglyLinkedListNode<T>?
    var tail: SinglyLinkedListNode<T>?
    init(head: SinglyLinkedListNode<T>?, tail: SinglyLinkedListNode<T>?) {
        self.head = head
        self.tail = tail
    }
    convenience init() {
        self.init(head: nil, tail: nil)
    }
}
public struct SinglyLinkedList<T: Equatable> {
    typealias Node = SinglyLinkedListNode<T>
    private var storage: IndirectStorage<T>
    init() {
        storage = IndirectStorage()
    }
}
extension SinglyLinkedList {
    public var lastValue: T? {
        return storage.tail?.value
    }
}
extension SinglyLinkedList {
    private var storageForWritting: IndirectStorage<T> {
        mutating get {
            if isKnownUniquelyReferenced(&self.storage) {
                storage = copyStorage()
            }
            return storage
        }
    }
    private func copyStorage() -> IndirectStorage<T> {
        guard storage.head != nil && storage.tail != nil else { return IndirectStorage() }
        let copiedHead = storage.head
        var previousCopied = copiedHead
        var current = storage.head?.next
        while current != nil {
            let currentCopied = Node(value: current!.value)
            previousCopied?.next = currentCopied
            current = current?.next
            previousCopied = currentCopied
        }
        return IndirectStorage(head: copiedHead, tail: previousCopied)
    }
}
extension SinglyLinkedList {
    func containsLoop() -> Bool {
        var current = storage.head
        var runner = storage.head
        while current != nil && runner != nil {
            current = current?.next
            runner = runner?.next
            if current === runner {
                return true
            }
        }
        return false
    }
}
extension SinglyLinkedList {
    func findTail(node: Node) -> (tail: Node, count: Int) {
        var current: Node? = node
        var count = 1
        while current?.next != nil {
            current = current?.next
            count += 1
        }
        if current != nil {
            return (current!, count)
        } else {
            return (node, 1)
        }
    }
}
extension SinglyLinkedList {
    private mutating func append(node: Node) {
        if storage.tail != nil {
            storageForWritting.tail?.next = node
            if containsLoop() {
                storageForWritting.tail = nil
            } else {
                storageForWritting.tail = findTail(node: node).tail
            }
        } else {
            storageForWritting.head = node
            if containsLoop() {
                storageForWritting.tail = nil
            } else {
                storageForWritting.tail = findTail(node: node).tail
            }
        }
    }
    public mutating func append(value: T) {
        let node = Node(value: value)
        append(node: node)
    }
    private mutating func prepend(node: Node) {
        let (tail, _) = findTail(node: node)
        tail.next = storageForWritting.head
        storageForWritting.head = node
        if storage.tail == nil {
            storageForWritting.tail = tail
        }
    }
    public mutating func prepend(value: T) {
        let node = Node(value: value)
        prepend(node: node)
    }
}
extension SinglyLinkedList {
    public mutating func delete(at index: Int) -> T {
        assert(index >= 0 && index < findTail(node: storage.head!).count)
        var current = storage.head
        var previous: Node?
        var initial = 0
        while initial < index {
            previous = current
            current = current?.next
            initial += 1
        }
        if storage.head === current {
            storageForWritting.head = current?.next
        }
        if storage.tail === current {
            storageForWritting.tail = previous
        }
        previous?.next = current?.next
        return current!.value
    }
    public mutating func delete(value: T) {
        guard storage.head != nil else { return }
        var current = storage.head
        var previous: Node?
        while current != nil && current?.value != value {
            previous = current
            current = current?.next
        }
        if let found = current {
            if storage.head === found {
                storageForWritting.head = found.next
            }
            if storage.tail === found {
                storageForWritting.tail = previous
            }
            previous?.next = found.next
            found.next = nil
        }
    }
    public func deleteDuplicatesInPlace() {
        var current = storage.head
        while current != nil {
            var previous = current
            var next = current?.next
            while next != nil {
                if current?.value == next?.value {
                    if storage.head === next {
                        storage.head = next?.next
                    }
                    if storage.tail === next {
                        storage.tail = previous
                    }
                    previous?.next = next?.next
                }
                previous = next
                next = next?.next
            }
            current = current?.next
        }
    }
}
public struct SinglyLinkedListIterator<T>: IteratorProtocol {
    var head: SinglyLinkedListNode<T>?
    public mutating func next() -> T? {
        let result = head?.value
        head = head?.next
        return result
    }
}
extension SinglyLinkedList: Sequence {
    public func makeIterator() -> SinglyLinkedListIterator<T> {
        return SinglyLinkedListIterator(head: storage.head)
    }
}
public struct SinglyLinkedListIndex<T>: Comparable {
    fileprivate var node: SinglyLinkedListNode<T>?
    fileprivate var tag: Int
    public static func == <T> (lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    public static func < <T> (lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
        return lhs.tag < rhs.tag
    }
}
extension SinglyLinkedList: Collection {
    public typealias Index = SinglyLinkedListIndex<T>
    public var startIndex: SinglyLinkedListIndex<T> {
        return SinglyLinkedListIndex(node: storage.head, tag: 0)
    }
    public var endIndex: SinglyLinkedListIndex<T> {
        if let head = storage.head {
            let (tail, count) = findTail(node: head)
            return SinglyLinkedListIndex(node: tail, tag: count)
        } else {
            return SinglyLinkedListIndex(node: nil, tag: startIndex.tag)
        }
    }
    public func index(after index: SinglyLinkedListIndex<T>) -> SinglyLinkedListIndex<T> {
        return SinglyLinkedListIndex(node: index.node?.next, tag: index.tag + 1)
    }
    public subscript(pos: Index) -> T {
        return pos.node!.value
    }
}
extension SinglyLinkedList: Queue {
    public typealias Element = T
    mutating func enqueue(_ value: T) {
        append(value: value)
    }
    mutating func dequeue() -> T? {
        guard count > 0 else { return nil }
        return delete(at: 0)
    }
    func getFirst() -> T? {
        return storage.head?.value
    }
}
extension SinglyLinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        var headSeted = false
        var current: Node?
        self.init()
        elements.forEach {
            if headSeted == false {
                storage.head = Node(value: $0)
                current = storage.head
                headSeted = true
            } else {
                let newNode = Node(value: $0)
                current?.next = newNode
                current = newNode
            }
        }
        storage.tail = current
    }
}
extension SinglyLinkedList: CustomStringConvertible {
    public var description: String {
        var current = storage.head
        var tempArr = [T]()
        while current != nil {
            tempArr.append(current!.value)
            current = current?.next
        }
        return tempArr.map { "\($0)" }.joined(separator: ",\t")
    }
}
