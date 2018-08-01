/**
 Allen Newell, Cliff Shaw and Herbert A. Simon in 1955–1956
 
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
  nil <---|        |<---|        |<---|        |<---|        |  <--- tail
          +--------+    +--------+    +--------+    +--------+

 
 
 ````
 */
import Foundation
enum List<Element> {
    case end
    indirect case node(Element,next:List<Element>)
}
extension List {
    func cons(_ value:Element) -> List<Element> {
        return .node(value,next: self)
        ///  1 next self-> end
    }
}
extension List {
    mutating func push(_ value:Element) {
        self = cons(value)
    }
    mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(value,next):
            self = next
            return value
        }
    }
}
extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}
extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end){ $0.cons($1) }
    }
}
let emptyList = List<Int>.end
let oneElementList = List.node(1, next: emptyList)
print(oneElementList)   ///node(1, next: List<Swift.Int>.end)
let list = List.end.cons(1).cons(2)
let tail1 = list.cons(3)///共享链表结尾
let tail2 = list.cons(3)

var stack:List<Int> = [3,2,1]
var a = stack
var b = stack

a.pop() ///Optional(3)
a.pop() ///Optional(2)
a.pop() ///Optional(1)

stack.pop() ///Optional(3)
stack.push(4)

b.pop() ///Optional(3)
b.pop() ///Optional(2)
b.pop() ///Optional(1)

stack.pop() ///Optional(4)
stack.pop() ///Optional(2)
stack.pop() ///Optional(1)

list.map{"value:\($0)"}.joined(separator: ", ")

/********************* Comforming to the Collection Protocol *****************/
// swiftlint:disable identifier_name
import Foundation
private enum ListNode<Element> {
    case end
    indirect case node(Element, ListNode<Element>)
    nonmutating func append(_ value: Element) -> ListNode<Element> {
        return .node(value, self)
    }
}
public struct ListIndex<Element>:CustomStringConvertible {
    fileprivate var node: ListNode<Element>
    fileprivate var tag: Int
    public var description: String {
        return "ListIndexTag:\(tag)"
    }
}
extension ListIndex: Comparable {
    public static func == <T> (lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    public static func < <T> (lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag > rhs.tag
    }
}

struct List<Element>:Collection {
    typealias Index = ListIndex<Element>
    var startIndex: Index
    var endIndex: Index
    subscript(position: Index) -> Element {
        switch position.node {
        case .end: fatalError("Out of range")
        case let .node(value, _): return value
        }
    }
    public subscript(bounds: Range<Index>) -> List<Element> {
        return List(startIndex: bounds.lowerBound, endIndex: bounds.upperBound)
    }
    public func index(after i: ListIndex<Element>) -> ListIndex<Element> {
        switch i.node {
        case .end: fatalError("Out of range")
        case let .node(_, next): return ListIndex(node: next, tag: i.tag - 1)
        }
    }
    public var count: Int {
        return startIndex.tag - endIndex.tag
    }
    mutating func push(_ element: Element) {
        startIndex = Index(node: startIndex.node.append(element), tag: startIndex.tag + 1)
    }
    mutating func pop() -> Index {
        let current = startIndex
        startIndex = index(after: startIndex)
        return current
    }
}
extension List: ExpressibleByArrayLiteral, CustomStringConvertible {
    public init(arrayLiteral elements: Element...) {
        startIndex = ListIndex(node: elements.reversed().reduce(.end, {$0.append($1)}), tag: elements.count)
        endIndex = ListIndex(node: .end, tag: 0)
    }
    public var description: String {
        let elements = self.map { String(describing: $0)}.joined(separator: "- ")
        return "List: \(elements)"
    }
}
extension List: Sequence, IteratorProtocol {
    mutating func next() -> Element? {
        switch pop().node {
        case .end: return nil
        case .node(let value, _): return value
        }
    }
    static func == <T: Equatable> (lhs: List<T>, rhs: List<T>) -> Bool {
        return lhs.elementsEqual(rhs)
    }
}

var list: List = [5, 4, 3, 2, 1]
list.push(100)
let listIndex = list.index(of: 100)
let listIndex2 = list.index(of: 3)
print(listIndex?.tag)
print(list[listIndex!])
print(list[listIndex!...listIndex2!])
let num = list.pop()
let newArray = list.sorted()
print(list)

/*********************** doubly linked list ***************************/
public final class LinkedList<Element> {
    public init() {}
    fileprivate(set) var head: Node?
    public var isEmpty: Bool {
        return head == nil
    }
}
extension LinkedList {
    public typealias Node = LinkedListNode<Element>
    public class LinkedListNode<Element> {
        var element: Element
        var next: Node?
        var previous: Node?
        init(element: Element) {
            self.element = element
        }
    }
}
extension LinkedList {
    public var count: Int {
        guard var node = head else { return 0 }
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }
        return count
    }
}
extension LinkedList {
    public var last: Node? {
        guard var node = head else { return nil }
        while let next = node.next {
            node = next
        }
        return node
    }
}
extension LinkedList {
    public func node(index: Int) -> Node {
        assert(index >= 0 && head != nil)
        if index == 0 {
            return head!
        } else {
            var node = head?.next
            for _ in 1..<index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            guard  node != nil else { fatalError(" node index out of range ") }
            return node!
        }
    }
}
extension LinkedList {
    public subscript (index: Int) -> Element {
        let node = self.node(index: index)
        return node.element
    }
}
extension LinkedList {
    public func append(_ element: Element) {
        let node = Node(element: element)
        append(node)
    }
    public func append(_ node: Node) {
        let newNode = node
        if let lastNode = self.last {
            lastNode.next = newNode
            newNode.previous = lastNode
        } else {
            head = newNode
        }
    }
    public func append(_ list: LinkedList) {
        var copyNode = list.head
        while let next = copyNode {
            append(next.element)
            copyNode = next.next
        }
    }
}
extension LinkedList {
    public func insert(_ newElement: Element, at index: Int) {
        let node = Node(element: newElement)
        insert(node, at: index)
    }
    public func insert(_ newNode: Node, at index: Int) {
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            let prev = node(index: index - 1)
            let next = prev.next
            newNode.previous = prev
            newNode.next = next
            next?.previous = newNode
            prev.next = newNode
        }
    }
}
extension LinkedList {
    public func remove(node: Node) -> Element {
        let prev = node.previous
        let next = node.next
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        node.next = nil
        node.previous = nil
        return node.element
    }
    public func remove(at index: Int) -> Element {
        let node = self.node(index: index)
        return remove(node: node)
    }
    public func removeLast() -> Element? {
        return last.map { remove(node: $0) }
    }
    public func removeAll() {
        head = nil
    }
}
extension LinkedList: CustomStringConvertible {
    public var description: String {
        var str = "["
        var node = head
        while let current = node {
            str += "\(current.element)"
            node = current.next
            if node != nil { str += "," }
        }
        return str + "]"
    }
}
extension LinkedList {
    public func reverse() {
        var node = head
        while let current = node {                  ///     nil  1,  2,  3  Nil                                                                                  HEAD   NEXT
            node = current.next                     ///     current 1    node = current.next 2    current.previous = nil   swap   2   1  nil          ...  ->     1
            swap(&current.next, &current.previous)  ///     current 2    node = current.next 3    current.previous = 1     swap   3   2   1  nil      ...  ->     2     1
            head = current                          ///     current 3    node = current.next nil  current.previous = 2     swap   nil  3   2  1  nil  ...  ->     3     2   1
        }                                           ///
    }
}
extension LinkedList {
    public func map(transform: (Element) -> Element) -> LinkedList {
        let list = LinkedList<Element>()
        var node = head
        while let current = node {
            list.append(transform(current.element))
            node = current.next
        }
        return list
    }
    public func filter(predicate: (Element) -> Bool) -> LinkedList {
        let list = LinkedList<Element>()
        var node = head
        while let current = node {
            if predicate(current.element) {
                list.append(current.element)
            }
            node = current.next
        }
        return list
    }
}
extension LinkedList {
    convenience init(array: [Element]) {
        self.init()
        array.forEach { append($0) }
    }
}
extension LinkedList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: Element...) {
        self.init()
        elements.forEach { append($0) }
    }
}
extension LinkedList: Collection {
    public typealias Index = LinkedListIndex<Element>
    public var startIndex: Index {
        return LinkedListIndex(node: head, tag: 0)
    }
    public var endIndex: Index {
        if let head = self.head {
            return LinkedListIndex(node: head, tag: count)
        } else {
            return LinkedListIndex(node: nil, tag: startIndex.tag)
        }
    }
    public func index(after idx: Index) -> Index {
        return LinkedListIndex(node: idx.node?.next, tag: idx.tag + 1)
    }
    public subscript (position: Index) -> Element {
        return position.node!.element
    }
}
public struct LinkedListIndex<T>: Comparable {
    fileprivate let node: LinkedList<T>.LinkedListNode<T>?
    fileprivate let tag: Int
    static public func == <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag == lhs.tag)
    }
    static public func < <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag < lhs.tag)
    }
}

let list = LinkedList<String>()
print(list.isEmpty, list.head, list.last, separator: "\t", terminator: "\n")
///        true     nil        nil
list.append("Hello")
print(list.isEmpty, list.head?.element, list.last?.element, list.count, separator: "\t", terminator: "\n")
///        false    Optional("Hello")   Optional("Hello")   1
list.append("World")
print(list.isEmpty, list.head?.element, list.last?.element, list.count, separator: "\t", terminator: "\n")
///        false    Optional("Hello")   Optional("World")   2
print(list.head?.previous, list.head?.next?.element, separator: "\t", terminator: "\n")
///        nil      Optional("World")
print(list.node(index: 0).element, list[0], list.node(index: 1).element, list[1], separator: "\t", terminator: "\n")
///        Hello    Hello    World    World   list[2] crash!
list.insert("Swift", at: 1)
print(list[0], list[1], list[2], separator: "\t", terminator: "\n")
///        Hello    Swift    World
list.reverse()
print(list[0], list[1], list[2], separator: "\t", terminator: "\n")
///        World    Swift    Swift

// Conformance to the Collection protocol
let collection: LinkedList<Int> = [1, 2, 3, 4, 5]
let index2 = collection.index(collection.startIndex, offsetBy: 2)
let value = collection[index2]
// Iterating in a for loop, since the Sequence protocol allows this.
var sum = 0
for element in collection {
    sum += element
}
print(value,sum, separator: "\t", terminator: "\n")
///3    0

/*********************** Single linked list ***************************/
/**
 SinglyLinkedLis    IndirectStorage        SinglyLinkedListNode
 +--------+          +--------+            +--------+
 indeirect           head:                 |        |          |        |           |        |
 storage  ------>    tail:        -------> | node 0 |------->  | node 1 |------->   | node 3 |-------> nil
 |        |  next    |        |  next      |        |  next
 +--------+          +--------+            +--------+
 ^                                                 ^
 |                                                 |
 Head                                           Tail              */

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
/// Data structure that provides FIFO access
protocol Queue {
    associatedtype Item
    mutating func enqueue(item: Item) throws
    mutating func dequeue() -> Item?
    func getFirst() -> Item?
}
/// Helper class to implement copy-on-write
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
public class SinglyLinkedListNode<T> {
    public var value: T
    public var next: SinglyLinkedListNode<T>?
    public init(value: T) {
        self.value = value
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
/// copy-on-write
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
/// 1. 首尾不为nil 2.复制头节点 3.创建前驱节点变量 4.遍历原有节点,根据每个节点的值创建新节点 5.前驱变量连接新节点 6.前驱变量为当前节点
extension SinglyLinkedList {
    private func copyStorage() -> IndirectStorage<T> {
        guard (self.storage.head != nil) && (self.storage.tail != nil) else {
            return IndirectStorage(head: nil, tail: nil)
        }
        let copiedHead = SinglyLinkedListNode<T>(value: self.storage.head!.value)
        var previousCopied = copiedHead         ///  新建头节点
        var current = self.storage.head?.next   ///  原有
        /// 每遍历到一个节点新建出该节点建立连接到另一个复制出的原始节点上
        while current != nil {
            let currentCopy = SinglyLinkedListNode<T>(value: current!.value)  ///新建当前节点
            previousCopied.next = currentCopy
            current = current?.next
            previousCopied = currentCopy
        }
        return IndirectStorage(head: copiedHead, tail: previousCopied)
    }
}
/// A singly linked list contains a loop if one node references back to a previous node.
extension SinglyLinkedList {
    public func containsLoop() -> Bool {
        /// Advances a node at a time
        var current = self.storage.head
        /// Advances twice as fast
        var runner = self.storage.head
        while (runner != nil) && (runner?.next != nil) {
            current = current?.next
            runner = runner?.next?.nex
            if runner === current {
                return true
            }
        }
        return false
    }
}
extension SinglyLinkedList {
    func findTail<T>(in node: SinglyLinkedListNode<T>) -> (tail: SinglyLinkedListNode<T>, count: Int) {
        var current: SinglyLinkedListNode<T>? = node
        var count = 1
        while current?.next != nil {
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
            self.storageForWritting.head = node
            if !self.containsLoop() {
                let (tail, _) = findTail(in: node)
                self.storageForWritting.tail = tail
            } else {
                self.storageForWritting.tail = nil
            }
        }
    }
}
extension SinglyLinkedList {
    ///前置节点
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
        // Current is now the element to delete (at index position.tag)
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
    private func find(kthToLast: UInt, startingAt node: SinglyLinkedListNode<T>?,
                      count: UInt) -> SinglyLinkedListNode<T>? {
        guard kthToLast <= count else { return nil }
        guard node != nil else { return nil }
        let idx = count - kthToLast
        if idx == 0 { return node }
        return find(kthToLast: kthToLast, startingAt: node?.next, count: (count - 1))
    }
    public func find(kthToLast: UInt) -> SinglyLinkedListNode<T>? {
        return self.find(kthToLast: kthToLast, startingAt: self.storage.head, count: UInt(self.count))
    }
}
extension SinglyLinkedList {
    /// 去除重复的值
    /// Deletes duplicates without using additional structures like a set to keep track the visited nodes.
    /// - Complexity: O(N^2)
    public mutating func deleteDuplicatesInPlace() {
        var current = self.storageForWritting.head
        while current != nil {
            /// 每遍历到一个值 该值的下一个值等于该值
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
                    // Delete next
                    previous?.next = next?.next
                }
                previous = next
                next = next?.next
            }
            current = current?.next
        }
    }
}
// MARK: - ITERATOR -
public struct SinglyLinkedListForwardIterator<T> : IteratorProtocol {
    public typealias Element = T
    private(set) var head: SinglyLinkedListNode<T>?
    mutating public func next() -> T? {
        let result = self.head?.value
        self.head = self.head?.next
        return result
    }
}
// MARK: - FORWARD-INDEX -
public struct SinglyLinkedListIndex<T> : Comparable {
    fileprivate let node: SinglyLinkedListNode<T>?
    fileprivate let tag: Int
    public static func == <T>(lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
        return (lhs.tag == rhs.tag)
    }
    public static func < <T>(lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
        return (lhs.tag < rhs.tag)
    }
}
// MARK: - COLLECTION -
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
// MARK: - QUEUE -
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
// MARK: - EXPRESSIBLE-BY-ARRAY-LITERAL -
extension SinglyLinkedList: ExpressibleByArrayLiteral {
    public typealias Element = T
    public init(arrayLiteral elements: Element...) {
        var headSet = false
        var current: SinglyLinkedListNode<T>?
        var numberOfElements = 0
        self.storage = IndirectStorage()
        for element in elements {
            numberOfElements += 1
            if headSet == false { ///第一个元素创建后变成true
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
            str.append(current!.value)
            current = current?.next
        }
        return str.map { "\($0)" }.joined(separator: ", ")
    }
}

var list1: SinglyLinkedList<Int> = [1, 2, 3, 4, 5, 6, 7, 7]
var list2 = list1
list2.append(value: 67)
let list3 = list2.dropLast()

/**
 + 节点 中间层 链表
 + 写时复制
 + 是否相互引用
 + 从某个节点开始找到尾节点并记录期间节点数量
 + 从链表前后添加
 + 遵循序列迭代协议
 + 遵循集合类型协议
 + 删除节点(下标,值)
 + 去掉重复值
 + 实现入棧出棧协议
 */
protocol Queue {
    associatedtype Item
    mutating func enqueue(_ value: Item)
    mutating func dequeueu() -> Item?
    func getFirst() -> Item?
}
public class SinglyLinkedListNode<T> {
    var value: T
    var next: SinglyLinkedListNode?
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
    private var  storage: IndirectStorage<T>
    public init() {
        self.storage = IndirectStorage()
    }
    internal init(head node: SinglyLinkedListNode<T>) {
        storage = IndirectStorage()
        append(node: node)
    }
    public init(value: T) {
        let node = SinglyLinkedListNode(value: value)
        self.init(head: node)
    }
    var lastValue: T? {
        return storage.tail?.value
    }
}
extension SinglyLinkedList {
    private var storageForWritting: IndirectStorage<T> {
        mutating get {
            if !isKnownUniquelyReferenced(&self.storage) {
                storage = copyStorage()
            }
            return storage
        }
    }
    private func copyStorage() -> IndirectStorage<T> {
        guard storage.head != nil && storage.tail != nil else {
            return IndirectStorage(head: nil, tail: nil)
        }
        let copiedHead = SinglyLinkedListNode(value: storage.head!.value)
        var preivousCopied = copiedHead
        var currentNode = storage.head?.next
        while currentNode != nil {
            let currentCopied = SinglyLinkedListNode(value: currentNode!.value)
            preivousCopied.next = currentCopied
            currentNode = currentNode?.next
            preivousCopied = currentCopied
        }
        return IndirectStorage(head: copiedHead, tail: preivousCopied)
    }
}
extension SinglyLinkedList {
    func containsLoop() -> Bool {
        var current = storage.head
        var runner = storage.head
        while runner?.next != nil && runner != nil {
            current = current?.next
            runner = runner?.next?.next
            if current === runner {
                return true
            }
        }
        return false
    }
}
extension SinglyLinkedList {
    func findTail(in node: SinglyLinkedListNode<T>) -> (tail: SinglyLinkedListNode<T>, count: Int) {
        var current: SinglyLinkedListNode? = node
        var count = 1
        while current?.next != nil {
            current = current?.next
            count += 1
        }
        if current == nil {
            return (node, 1)
        } else {
            return (current!, count)
        }
    }
}
extension SinglyLinkedList {
    private mutating func append(node: SinglyLinkedListNode<T>) {
        if self.storageForWritting.tail != nil {
            self.storageForWritting.tail?.next = node
            if !self.containsLoop() {
                let (tail, _) = findTail(in: node)
                self.storageForWritting.tail = tail
            } else {
                storageForWritting.tail = nil
            }
        } else {
            self.storageForWritting.head = node
            if !self.containsLoop() {
                let (tail, _) = findTail(in: node)
                self.storageForWritting.tail = tail
            } else {
                storageForWritting.tail = nil
            }
        }
    }
    public mutating func append(value: T) {
        let node = SinglyLinkedListNode(value: value)
        append(node: node)
    }
}
extension SinglyLinkedList {
    private mutating func prepende(node: SinglyLinkedListNode<T>) {
        let (tailFromNode, _) = findTail(in: node)
        tailFromNode.next = self.storageForWritting.head
        self.storageForWritting.head = node
        if self.storageForWritting.tail == nil {
            self.storageForWritting.tail = tailFromNode
        }
    }
    public mutating func prepend(value: T) {
        let node = SinglyLinkedListNode<T>(value: value)
        prepende(node: node)
    }
}
//COMFORMING COLLECTION
public struct SinglyLinkedListIterator<T>: IteratorProtocol {
    fileprivate(set) var node: SinglyLinkedListNode<T>?
    public mutating func next() -> T? {
        let result = self.node?.value
        node = self.node!.next
        return result
    }
}
extension SinglyLinkedList: Sequence {
    public func makeIterator() -> SinglyLinkedListIterator<T> {
        var iterator = SinglyLinkedListIterator<T>()
        iterator.node = self.storage.head
        return iterator
    }
}
public struct SinglyLinkedListIndex<T>: Comparable {
    fileprivate let node: SinglyLinkedListNode<T>?
    fileprivate var tag: Int
    static public func ==<T> (lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    static public func <<T> (lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
        return lhs.tag < rhs.tag
    }
}
extension SinglyLinkedList: Collection {
    public typealias Index = SinglyLinkedListIndex<T>
    public var startIndex: SinglyLinkedListIndex<T> {
        return SinglyLinkedListIndex(node: self.storage.head, tag: 0)
    }
    public var endIndex: SinglyLinkedListIndex<T> {
        if let head = self.storage.head {
            let (tail, count) = findTail(in: head)
            return SinglyLinkedListIndex(node: tail, tag: count)
        } else {
            return SinglyLinkedListIndex(node: nil, tag: 0)
        }
    }
    public func index(after index: SinglyLinkedListIndex<T>) -> SinglyLinkedListIndex<T> {
        return SinglyLinkedListIndex(node: index.node?.next, tag: index.tag + 1)
    }
    public subscript(pos: Index) -> T {
        return pos.node!.value
    }
}
// DELETE
extension SinglyLinkedList {
    public mutating func delete(at index: Int) -> T {
        precondition(index >= 0 && index < self.count)
        var previous: SinglyLinkedListNode<T>?
        var current = self.storage.head
        var initial = 0
        while initial < index {
            previous = current
            current = current?.next
            initial += 1
        }
        if self.storage.head === current! {
            self.storageForWritting.head = current?.next
        }
        if self.storage.tail === current! {
            self.storageForWritting.tail = previous
        }
        previous?.next = current?.next
        return current!.value
    }
    public mutating func delete(value: T) {
        guard self.storage.head != nil else { return }
        var previous: SinglyLinkedListNode<T>?
        var current = self.storage.head
        while current != nil && current?.value != value {
            previous = current
            current = current?.next
        }
        if let foundNode = current {
            if foundNode === self.storage.head {
                self.storageForWritting.head = foundNode
            }
            if foundNode === self.storage.tail {
                self.storageForWritting.tail = previous
            }
            previous?.next = current?.next
            foundNode.next = nil
        }
    }
}
extension SinglyLinkedList {
    public mutating func deleteDuplicatedInPlace() {
        var current = self.storage.head
        while current != nil {
            var previous = current
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
extension SinglyLinkedList: Queue {
    typealias Item = T
    mutating func enqueue(_ value: T) {
        append(node: SinglyLinkedListNode(value: value))
    }
    mutating func dequeueu() -> T? {
        guard count > 0 else { return nil }
        return delete(at: 0)
    }
    func getFirst() -> T? {
        return self.storage.head?.value
    }
}
extension SinglyLinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        var headSet = false
        var current: SinglyLinkedListNode<T>?
        var numberOfElement = 0
        self.storage = IndirectStorage()
        for element in elements {
            numberOfElement += 1
            if headSet == false {
                self.storage.head = SinglyLinkedListNode(value: element)
                current = self.storage.head
                headSet = true
            } else {
                let newNode = SinglyLinkedListNode(value: element)
                current?.next = newNode
                current = newNode
            }
        }
        self.storage.tail = current
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
var list1: SinglyLinkedList<Int> = [1, 2, 2, 3, 4, 5, 6, 7, 7]
list1.deleteDuplicatedInPlace()
list1.append(value: 100)
list1.prepend(value: 0)
list1.delete(value: 2)
print(list1)





