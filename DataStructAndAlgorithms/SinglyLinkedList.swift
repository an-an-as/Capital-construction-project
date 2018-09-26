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
 

 
                                        Linked list                       Array    Dynamic array    Balanced tree    Random access list    Hashed array tree
 
 Indexing                                Θ(n)                             Θ(1)     Θ(1)             Θ(log n)         Θ(log n)              Θ(1)
 Insert/delete at beginning              Θ(1)                             N/A      Θ(n)             Θ(log n)         Θ(1)                  Θ(n)
 Insert/delete at end                    Θ(1) when last element is known  N/A      Θ(1) amortized   Θ(log n)         Θ(log n) updating     Θ(1) amortized
                                         Θ(n) when last element is unknown
 Insert/delete in middle                 search time + Θ(1)               N/A      Θ(n)             Θ(log n)         Θ(log n) updating     Θ(n)
 Wasted space (average)                  Θ(n)                              0       Θ(n)             Θ(n)             Θ(n)                  Θ(√n)
 
````*/
public protocol KeyValuePair: Comparable {
    associatedtype Key: Comparable, Hashable
    associatedtype Value: Comparable, Hashable
    var key: Key { get set }
    var value: Value { get set }
    init(key: Key, value: Value)
    func copy() -> Self
}
extension KeyValuePair {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.key == rhs.key
    }
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.key < rhs.key
    }
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.key <= rhs.key
    }
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.key >= rhs.key
    }
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.key > rhs.key
    }
}
struct IntegerPair: KeyValuePair {
    var key: Int
    var value: Int
    func copy() -> IntegerPair {
        return IntegerPair(key: self.key, value: self.value)
    }
}
protocol Queue {
    associatedtype Item
    mutating func enqueue(item: Item) throws
    mutating func dequeue() -> Item?
    func getFirst() -> Item?
}
public class SinglyLinkedListNode<T> {
    public var value: T
    public var next: SinglyLinkedListNode<T>?
    public init(value: T) {
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
    private var storage: IndirectStorage<T>
    public var lastValue: T? {
        return self.storage.tail?.value
    }
    public init() {
        self.storage = IndirectStorage()
    }
    internal init(head: SinglyLinkedListNode<T>) {
        self.storage = IndirectStorage()
        self.append(node: head)
    }
    public init(value: T) {
        let node = SinglyLinkedListNode<T>(value: value)
        self.init(head: node)
    }
}
extension SinglyLinkedList {
    private var storageForWritting: IndirectStorage<T> {
        mutating get {
            if !isKnownUniquelyReferenced(&self.storage) {
                self.storage = self.copyStorage()
            }
            return self.storage
        }
    }
}
extension SinglyLinkedList {
    private func copyStorage() -> IndirectStorage<T> {
        guard self.storage.head != nil && self.storage.tail != nil else {
            return IndirectStorage(head: nil, tail: nil)
        }
        let copiedHead = SinglyLinkedListNode<T>(value: self.storage.head!.value)
        var previousCopied = copiedHead
        var current = self.storage.head?.next
        while current != nil {
            let currentCopy = SinglyLinkedListNode<T>(value: current!.value)
            previousCopied.next = currentCopy
            current = current?.next
            previousCopied = currentCopy
        }
        return IndirectStorage(head: copiedHead, tail: previousCopied)
    }
}                                                          /// head A  B 判断AB是否引用自同一对象
extension SinglyLinkedList {                               /// let node1 = SinglyLinkedListNode(value: 1)
    public func containsLoop() -> Bool {                   /// let node2 = SinglyLinkedListNode(value: 2)
        var current = self.storage.head                    /// node1.next = node2
        var runner = self.storage.head                     //  node1.next?.next = node2 || node1.next?.next = nil
        while (runner != nil) && (runner?.next != nil) {   /// let test1 = node1.next
            current = current?.next                        /// let test2 = node1.next?.next
            runner = runner?.next?.next                    /// test1 === test2 true
            if runner === current {                        /// node1 === node2 false
                return true
            }
        }
    }
}
extension SinglyLinkedList {
    func findTail<T>(in node: SinglyLinkedListNode<T>) -> (tail: SinglyLinkedListNode<T>, count: Int) {
        var current: SinglyLinkedListNode<T>? = node            /// case1 node: head
        var count = 1                                           /// case2 node: newNode
        while current?.next != nil {                            /// newNode.next = nil tail: newNode
            current = current?.next
            count += 1
        }
        if current != nil {
            return (tail: current!, count: count)
        } else {
            return (tail: node, count: 1)
        }
    }
}
extension SinglyLinkedList {
    public mutating func append(value: T) {
        let node = SinglyLinkedListNode<T>(value: value)
        self.append(node: node)
    }
    private mutating func append(node: SinglyLinkedListNode<T>) {
        if self.storage.tail != nil {
            self.storageForWritting.tail?.next = node
            if !self.containsLoop() {
                let (tail, _) = findTail(in: node)
                self.storageForWritting.tail = tail
            } else {
                self.storageForWritting.tail = nil
            }
        } else {
            self.storageForWritting.head = node               ///  head - A - A   tail: nil
            if !self.containsLoop() {                         ///  copy on write (head != nil && tail != nil)  else head = nil tail = nil
                let (tail, _) = findTail(in: node)            ///  B - C - D      head: B tail: D
                self.storageForWritting.tail = tail
            } else {
                self.storageForWritting.tail = nil
            }
        }
    }
}
extension SinglyLinkedList {
    public mutating func prepend(value: T) {
        let node = SinglyLinkedListNode<T>(value: value)
        self.prepend(node: node)
    }
    private mutating func prepend(node: SinglyLinkedListNode<T>) {
        let (tailFromNewNode, _) = findTail(in: node)
        tailFromNewNode.next = self.storageForWritting.head
        self.storageForWritting.head = node
        if self.storage.tail == nil {
            self.storageForWritting.tail = tailFromNewNode
        }
    }
}
extension SinglyLinkedList {
    public mutating func deleteItem(at index: Int) -> T {
        precondition((index >= 0) && (index < self.count))
        var previous: SinglyLinkedListNode<T>? = nil
        var current = self.storageForWritting.head
        var initial = 0
        var elementToDelete: SinglyLinkedListNode<T>
        while initial < index {
            previous = current
            current = current?.next
            initial += 1
        }
        elementToDelete = current!
        if self.storage.head === current {
            self.storageForWritting.head = current?.next
        }
        if self.storage.tail === current {
            self.storageForWritting.tail = previous
        }
        previous?.next = current?.next
        return elementToDelete.value
    }
    public mutating func deleteNode(withValue value: T) {
        guard self.storage.head != nil else { return }
        var previous: SinglyLinkedListNode<T>? = nil
        var current = self.storage.head
        while current != nil && current?.value != value {
            previous = current
            current = current?.next
        }
        if let foundNode = current {
            if self.storage.head === foundNode {
                self.storageForWritting.head = foundNode.next
            }
            if self.storage.tail === foundNode {
                self.storage.tail = previous
            }
            previous?.next = foundNode.next
            foundNode.next = nil
        }
    }
}
extension SinglyLinkedList {
    /// - Complexity: O(N^2)
    public mutating func deleteDuplicatesInPlace() {
        var current = self.storageForWritting.head
        while current != nil {
            var previous: SinglyLinkedListNode<T>? = current
            var next = current?.next
            while next != nil {
                if current?.value == next?.value {
                    if self.storage.head === next {
                        self.storage.head = next?.next
                    }
                    if self.storage.tail === next {
                        self.storage.tail = previous
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
public struct SinglyLinkedListForwardIterator<T> : IteratorProtocol {
    public typealias Element = T
    private(set) var head: SinglyLinkedListNode<T>?
    mutating public func next() -> T? {
        let result = self.head?.value
        self.head = self.head?.next
        return result
    }
}
extension SinglyLinkedList: Sequence {
    public func makeIterator() -> SinglyLinkedListForwardIterator<T> {
        return SinglyLinkedListForwardIterator(head: storage.head)
    }
}
extension Sequence where Element: Hashable {
    public func selectDistinct() -> [Element] {
        var tempSet = Set<Element>()
        return filter { tempSet.insert($0).inserted }
    }
}
extension SinglyLinkedList: Collection {
    public typealias Index = SinglyLinkedListIndex<T>
    public var startIndex: Index {
        return SinglyLinkedListIndex<T>(node: self.storage.head, tag: 0)
    }
    public var endIndex: Index {
        if let head = self.storage.head {
            let (_, numberOfElements) = findTail(in: head)
            return SinglyLinkedListIndex<T>(node: head, tag: numberOfElements)
        } else {
            return SinglyLinkedListIndex<T>(node: nil, tag: self.startIndex.tag)
        }
    }
    public subscript(position: Index) -> T {
        get {
            return position.node!.value
        }
    }
    public func index(after idx: Index) -> Index {
        return SinglyLinkedListIndex<T>(node: idx.node?.next, tag: idx.tag + 1)
    }
}
extension SinglyLinkedList: Queue {
    typealias Item = T
    func getFirst() -> T? {
        return self.storage.head?.value
    }
    mutating func enqueue(item: T) throws {
        self.append(node: SinglyLinkedListNode<T>(value: item))
    }
    mutating func dequeue() -> T? {
        guard self.count > 0 else {
            return nil
        }
        return self.deleteItem(at: 0)
    }
}
extension SinglyLinkedList: ExpressibleByArrayLiteral {
    public typealias Element = T
    public init(arrayLiteral elements: Element...) {
        var headSet = false
        var current: SinglyLinkedListNode<T>?
        var numberOfElements = 0
        self.storage = IndirectStorage()
        for element in elements {
            numberOfElements += 1
            if headSet == false {
                self.storage.head = SinglyLinkedListNode<T>(value: element)
                current = self.storage.head
                headSet = true
            } else {
                let newNode = SinglyLinkedListNode<T>(value: element)
                current?.next = newNode
                current = newNode
            }
        }
        self.storage.tail = current
    }
}
extension SinglyLinkedList where T: KeyValuePair {
    public func find(elementWithKey key: T.Key) -> T? {
        let searchResults = self.filter { (keyValuePair) -> Bool in
            return keyValuePair.key == key
        }
        return searchResults.first
    }
}
extension SinglyLinkedList: CustomStringConvertible {
    public var description: String {
        var current = self.storage.head
        var str = [T]()
        while current != nil {
            str.append(current!.value)
            current = current?.next
        }
        return str.map { "\($0)" }.joined(separator: ", ")
    }
}
var list1: SinglyLinkedList<Int> = [1, 2, 2, 2]
var list2 = list1
try list2.enqueue(item: 3)
print( list1.selectDistinct())
print(list1)
print(list2)

/********************************************  VERSION 2  *************************************************************************/
public struct SinglyLinkedList<T> {
    private var storage: IndirectStorge<T>
}
extension SinglyLinkedList {
    typealias Node = SinglyLinkedListNode<T>
    class SinglyLinkedListNode<T> {
        var value: T
        var next: Node?
        init(value: T) {
            self.value = value
        }
    }
}
extension SinglyLinkedList {
    private class IndirectStorge<T> {
        var head: Node?
        var tail: Node?
        init(head: Node?, tail: Node?) {
            self.head = head
            self.tail = tail
        }
    }
}
extension SinglyLinkedList {
    private  var storageForWritting: IndirectStorge<T> {
        mutating get {
            func copy() -> IndirectStorge<T> {
                guard storage.head != nil && storage.tail != nil else { return IndirectStorge(head: nil, tail: nil) }
                let copiedHead = Node(value: storage.head!.value)
                var previousCopied = copiedHead
                var current = storage.head?.next
                while current != nil {
                    let currentCopied = Node(value: current!.value)
                    previousCopied.next = currentCopied
                    previousCopied = currentCopied
                    current = current?.next
                }
                return IndirectStorge(head: copiedHead, tail: previousCopied)
            }
            if !isKnownUniquelyReferenced(&storage) {
                storage = copy()
            }
            return storage
        }
    }
}
extension SinglyLinkedList {
    func findNode(at index: Int) -> Node {
        assert(index >= 0 && index < count)
        var current = storage.head
        var initial = 0
        while initial < index {
            current = current?.next
            initial += 1
        }
        return current!
    }
}
extension SinglyLinkedList {
    private mutating func appendNode(node: Node) {
        if storage.tail != nil {
            storageForWritting.tail?.next = node
        } else {
            storageForWritting.head = node
        }
        storageForWritting.tail = node
    }
    private mutating func prependNode(node: Node) {
        node.next = storageForWritting.head
        storageForWritting.head = node
        if storage.tail == nil {
            storageForWritting.tail = node
        }
    }
    public mutating func append(_ newValue: T) {
        self.appendNode(node: Node(value: newValue))
    }
    public mutating func prepend(_ newValue: T) {
        self.prependNode(node: Node(value: newValue))
    }
}
extension SinglyLinkedList where T: Comparable {
    @discardableResult
    public mutating func remove(_ value: T) -> T? {
        var current = storage.head
        var previous: Node?
        while current != nil && current?.value != value {
            previous = current
            current = current?.next
        }
        if let found = current {
            if found === storage.head {
                storageForWritting.head = found.next
            }
            if found === storage.tail {
                storageForWritting.tail = previous
            }
            previous?.next = found.next
            found.next = nil
        }
        return current?.value
    }
    @discardableResult
    public mutating func remove(at index: Int) -> T? {
        assert(index >= 0 && index < count)
        var current = storage.head
        var previous: Node?
        var initial = 0
        while initial < index {
            previous = current
            current = current?.next
            initial += 1
        }
        if let found = current {
            if found === storage.head {
                storageForWritting.head = found.next
            }
            if found === storage.tail {
                storageForWritting.tail = previous
            }
            previous?.next = found.next
            found.next = nil
        }
        return current?.value
    }
}
public struct ListIndex<T>: Comparable {
    fileprivate var node: SinglyLinkedList<T>.Node?
    fileprivate var tag: Int
    static public func == (lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    static public func < (lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag < rhs.tag
    }
}
extension SinglyLinkedList: Collection {
    public typealias Index = ListIndex<T>
    public var startIndex: Index {
        return Index(node: storage.head, tag: 0)
    }
    public var endIndex: ListIndex<T> {
        if storage.head != nil {
            var count = 1
            var current = storage.head
            while let nextNode = current?.next {
                current = nextNode
                count += 1
            }
            return ListIndex(node: storage.head, tag: count)
        }
        return ListIndex(node: nil, tag: startIndex.tag)
    }
    public func index(after index: ListIndex<T>) -> ListIndex<T> {
        return ListIndex(node: index.node?.next, tag: index.tag + 1)
    }
    public subscript (pos: Index) -> T {
        return pos.node!.value
    }
}
extension SinglyLinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(storage: IndirectStorge(head: nil, tail: nil))
        var headSet  = false
        var previous: Node?
        elements.forEach {
            if !headSet {
                storage.head = Node(value: $0)
                previous = storage.head
                headSet = true
            } else {
                let newNode = Node(value: $0)
                previous?.next = newNode
                previous = newNode
            }
        }
        storage.tail = previous
    }
}
public struct ListIterator<T>: IteratorProtocol {
    fileprivate(set) var current: SinglyLinkedList<T>.Node?
    public mutating func next() -> T? {
        let result = current?.value
        current = current?.next
        return result
    }
}
extension SinglyLinkedList: Sequence {
    public func makeIterator() -> ListIterator<T> {
        return ListIterator(current: storage.head)
    }
}
extension Sequence where Element: Hashable {
    public func selectDistinct() -> [Element] {
        var temp = Set<Element>()
        return filter { temp.insert($0).inserted }
    }
}
extension SinglyLinkedList: CustomStringConvertible {
    public var description: String {
        var temp = [T]()
        var current = storage.head
        while current != nil {
            temp.append(current!.value)
            current = current?.next
        }
        return temp.map { "\($0)" }.joined(separator: " -----> ")
    }
}
extension SinglyLinkedList {
    public subscript(pos: Int) -> T {
        get {
            return findNode(at: pos).value
        }
        set {
            findNode(at: pos).value = newValue
        }
    }
}
var list: SinglyLinkedList = [1, 2, 3, 4, 5, 5, 5]
list.append(6)
list.prepend(0)
list.remove(3)
list.remove(at: list.count - 1)
print(list[0])
list[0] = 1_000
print(list)            // 1000 -----> 1 -----> 2 -----> 4 -----> 5 -----> 5 -----> 5
print(list.reversed()) // [5, 5, 5, 4, 2, 1, 0]
print(list.contains(2))// true
