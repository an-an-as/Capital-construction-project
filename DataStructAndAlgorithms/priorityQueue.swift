/**
 ## Order of the nodes.
 + In a binary search tree (BST), the left child must be smaller than its parent, and the right child must be greater
 + This is not true for a heap. In a max-heap both children must be smaller than the parent, while in a min-heap they both must be greater.
 
 ## Memory.
 + Traditional trees take up more memory than just the data they store.
 + You need to allocate additional storage for the node objects and pointers to the left/right child nodes.
 + A heap only uses a plain array for storage and uses no pointers.
 
 ## Balancing
 + AVL tree or red-black tree,在插入节点和需要重新平衡节点而Heap基于完全二叉树的性质并不需要调整
 + heaps we don't actually need the entire tree to be sorted. We just want the heap property to be fulfilled, so balancing isn't an issue.
 + Because of the way the heap is structured, heaps can guarantee O(log n) performance.
 
 ## Searching
 + Heap的主要特性是根节点为最大最小值,并且拥有O(long n)的插入和删除的特性,搜索不是它的主要任务
 + Whereas searching is fast in a binary tree, it is slow in a heap.
 */
import Foundation
public struct Heap<T> {
    var nodes = [T]()
    private var criteria: (T, T) -> Bool
    public init(sort: @escaping(T, T) -> Bool) {
        criteria = sort
    }
    public init(_ arr: [T], _ sort: @escaping(T, T) -> Bool) {
        criteria = sort
        transformIntoCompleteBinaryTree(for: arr)
    }
    public var isEmpty: Bool {
        return nodes.isEmpty
    }
    public var count: Int {
        return nodes.count
    }
    public func peek() -> T? {
        return nodes.first
    }
}
extension Heap {
    ///-complexity: O(n)
    mutating func transformIntoCompleteBinaryTree(for arr: [T]) {
        nodes = arr
        for index in stride(from: nodes.count/2 - 1, through: 0, by: -1) {
            shiftDown(index)
        }
    }
    @inline(__always) func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    @inline(__always) func leftChildrenIndex(of index: Int) -> Int {
        return index * 2 + 1
    }
    @inline(__always) func rightChildrenIndex(of index: Int) -> Int {
        return index * 2 + 2
    }
}
extension Heap {
    mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, to: nodes.count - 1)
    }
    ///-complexity: O(log n)
    mutating func shiftDown(from index: Int, to endIndex: Int) {
        let childIndexL = leftChildrenIndex(of: index)
        let childIndexR = childIndexL + 1
        var cursor = index
        if childIndexL < endIndex && criteria(nodes[childIndexL], nodes[cursor]) {
            cursor = childIndexL
        }
        if childIndexR < endIndex && criteria(nodes[childIndexR], nodes[cursor]) {
            cursor = childIndexR
        }
        if cursor == index { return }
        nodes.swapAt(index, cursor)
        shiftDown(from: cursor, to: endIndex)
    }
    ///-complexity: O(log n)
    mutating func shiftUp(_ index: Int) {
        var cursor = index
        let element = nodes[index]
        var parentIndex = self.parentIndex(of: cursor)
        while cursor > 0 && criteria(element, nodes[parentIndex]) {
            nodes[cursor] = nodes[parentIndex]
            cursor = parentIndex
            parentIndex = self.parentIndex(of: cursor)
        }
        nodes[cursor] = element
    }
}
extension Heap {
    ///-complexity: O(log n)
    public mutating func insert(_ newElement: T) {
        nodes.append(newElement)
        shiftUp(nodes.count - 1)
    }
    ///-complexity: O(log n)
    public mutating func insert<S: Sequence> (_ sequence: S) where S.Iterator.Element == T {
        for element in sequence {
            insert(element)
        }
    }
}
extension Heap {
    ///-complexity: O(log n)
    public mutating func remove() -> T? {
        guard !nodes.isEmpty else { return nil }
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            let value = nodes[0]
            shiftDown(0)
            nodes[0] = nodes.removeLast()
            return value
        }
    }
    @discardableResult
    ///-complexity: O(log n)
    public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil }
        let last = nodes.count - 1
        if index != last {
            nodes.swapAt(index, nodes.count - 1)
            shiftUp(index)
            shiftDown(from: index, to: last)
        }
        return nodes.removeLast()
    }
}
extension Heap {
    mutating func replace(_ newElement: T, at index: Int) {
        guard index < nodes.count else { return }
        remove(at: index)
        insert(newElement)
    }
}
extension Heap where T: Equatable {
    ///-complexity: O(n)
    func index(_ node: T) -> Int? {
        return nodes.index(where: { $0 == node})
    }
    ///-complexity: O(log n)
    mutating func  remove(_ node: T) -> T? {
        if let index = index(node) {
            remove(at: index)
        }
        return nil
    }
}
public struct PriorityQueue<T> {
    fileprivate var heap: Heap<T>
    ///To create a max-priority queue, supply a > sort function. For a min-priority queue, use <.
    public init(sort: @escaping (T, T) -> Bool) {
        heap = Heap(sort: sort)
    }
    public var isEmpty: Bool {
        return heap.isEmpty
    }
    public var count: Int {
        return heap.count
    }
    public func peek() -> T? {
        return heap.peek()
    }
    public mutating func enqueue(_ element: T) {
        heap.insert(element)
    }
    public mutating func dequeue() -> T? {
        return heap.remove()
    }
    public mutating func changePriority(at index: Int, value: T) {
        return heap.replace(value, at: index)
    }
}
extension PriorityQueue where T: Equatable {
    public func index(of element: T) -> Int? {
        return heap.index(element)
    }
}
struct Message: Comparable {
    let text: String
    let priority: Int
}
extension Message {
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.priority < rhs.priority
    }
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.priority == rhs.priority
    }
}

var queue = PriorityQueue<Message>(sort: >)
queue.enqueue(Message(text: "hello", priority: 100))
queue.enqueue(Message(text: "world", priority: 200))
print(queue.count,queue.isEmpty,queue.peek(), separator: "\t", terminator: "\n")
///   2           false         Optional(Message(text: "hello", priority: 200))
print(queue.peek()?.priority)
///Optional(200)
print(queue.dequeue()?.priority)
///Optional(200)

