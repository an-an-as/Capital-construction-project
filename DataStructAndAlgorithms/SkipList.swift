/**
 跳表是一种随机化的数据结构一种可以进行二分查找的有序链表
 跳跃表的结构是多层的，通过从最高维度的表进行检索再逐渐降低维度从而达到对任何元素的检索接近线性时间的目的O(logn)
 ````
 
 layer5 head   -------------------------------> 37  nil
 |                                       |
 layer4 head   -------------------------------> 37  nil
 |
 layer3 head   1  ---------------> 21   nil
 |     |                    |
 layer2 head   1 ---> 7  --------> 21  -------> 37  nil
 |     |      |             |            |
 layer1 head   1 ---> 7  --> 14 -> 21  -> 32  ->37  nil   SkipList array
 
 nil    nil    nil    nil   nil    nil   nil
 
 ```
 ## 性质
 + 由很多层结构组成,每一层都是一个有序的链表 ,最底层(Level 1)的链表包含所有元素
 + 如果一个元素出现在 Level i 的链表中，则它在 Level i 之下的链表也都会出现
 + 每个节点包含两个指针，一个指向同一链表中的下一个元素，一个指向下面一层的元素 */
import Foundation
private func coinFlip() -> Bool {
    return arc4random_uniform(2) == 1
}

public struct Stack<T> {
    fileprivate var array: [T] = []
    public var isEmpty: Bool {
        return array.isEmpty
    }
    public var count: Int {
        return array.count
    }
    public mutating func push(_ element: T) {
        array.append(element)
    }
    public mutating func pop() -> T? {
        return array.popLast()
    }
    public func peek() -> T? {
        return array.last
    }
}
extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator { curr.pop() }
    }
}

public class DataNode<Key: Comparable, Payload> {
    public typealias Node = DataNode<Key, Payload>
    fileprivate var key: Key?
    var data: Payload?
    var next: Node?
    var down: Node?
    public init(key: Key, data: Payload) {
        self.key  = key
        self.data = data
    }
    public init(asHead head: Bool) {}
}

open class SkipList<Key: Comparable, Payload> {
    public typealias Node = DataNode<Key, Payload>
    fileprivate(set) var head: Node?
    public init() {}
}
extension SkipList {
    func findNode(key: Key) -> Node? {
        var currentNode: Node? = head
        var isFound: Bool = false
        while !isFound {
            if let node = currentNode {
                switch node.next {
                case .none:
                    currentNode = node.down
                case .some(let value) where value.key != nil:
                    if value.key == key {
                        isFound = true
                        break
                    } else {
                        if key < value.key! {
                            currentNode = node.down
                        } else {
                            currentNode = node.next
                        }
                    }
                default: continue
                }
            } else {
                break
            }
        }
        if isFound {
            return currentNode
        } else {
            return nil
        }
    }
    func search(key: Key) -> Payload? {
        guard let node = findNode(key: key) else {
            return nil
        }
        return node.next!.data
    }
}
extension SkipList {
    private func bootstrapBaseLayer(key: Key, data: Payload) {
        head = Node(asHead: true)
        var node = Node(key: key, data: data)
        head!.next = node
        var currentTopNode = node
        while coinFlip() {
            let newHead    = Node(asHead: true)
            node           = Node(key: key, data: data)
            node.down      = currentTopNode
            newHead.next   = node
            newHead.down   = head
            head           = newHead
            currentTopNode = node
        }
    }
    private func insertItem(key: Key, data: Payload) {
        var stack              = Stack<Node>()
        var currentNode: Node? = head               ///  SkipLis head: Node  Node -> DataNode<Key,payload> -> key data next down
        while currentNode != nil {                  ///
            if let nextNode = currentNode!.next {   ///  insert 9 每个值进行比较 10 > 9 down
                if nextNode.key! > key {            ///  node(head)  node(10)   stack[node(10)]
                    stack.push(currentNode!)        ///  node(head)  node(10)   stack[node(10), node(10)]
                    currentNode = currentNode!.down ///
                } else {                            ///
                    currentNode = nextNode
                }
            } else {
                stack.push(currentNode!)
                currentNode = currentNode!.down
            }
        }                                                           //     node(head) node(10) -> node(9):currentTopNode -> nil
        let itemAtLayer    = stack.pop()                            ///                           |
        var node           = Node(key: key, data: data)             ///    node(head) node(10) -> node(9,currentTopNode) -> nil
        node.next          = itemAtLayer!.next                      ///
        itemAtLayer!.next  = node                                   ///
        var currentTopNode = node                                   ///    stackEmpty  head = nil
        while coinFlip() {                                          ///    node(head)-> node(9)
            if stack.isEmpty {                                      ///                  |
                let newHead    = Node(asHead: true)                 ///                 nil stack.pop
                node           = Node(key: key, data: data)
                node.down      = currentTopNode
                newHead.next   = node
                newHead.down   = head
                head           = newHead
                currentTopNode = node
            } else {
                let nextNode   = stack.pop()
                node           = Node(key: key, data: data)
                node.down      = currentTopNode
                node.next      = nextNode!.next
                nextNode!.next = node
                currentTopNode = node
            }
        }
    }
    func insert(key: Key, data: Payload) {                                      /// SkipList init head = nil -> bootstrapBaselayer -> asHead.next = Node(key data)
        if head != nil {                                                        /// coinFlip
            if let node = findNode(key: key) {                                  ///
                // replace, in case of key already exists.                      ///        newHeadNode -> Node(key value): currentTopNode
                var currentNode = node.next                                     ///        |down          |down
                while currentNode != nil && currentNode!.key == key {           ///        headNode    -> Node(key value): (currentTopNode)
                    currentNode!.data = data                                    ///
                    currentNode       = currentNode!.down                       /// head != nil 判断该值是否已尽存在
                }                                                               /// 存在:  current.key == key
            } else {                                                            /// node  currentNode                              node.next.data = newData
                insertItem(key: key, data: data)                                ///       downNode                                 node.next = node.down = downNode
            }                                                                   ///
        } else {                                                                ///
            bootstrapBaseLayer(key: key, data: data)
        }
    }
}
extension SkipList {
    public func remove(key: Key) {
        guard let item = findNode(key: key) else {
            return
        }
        var currentNode = Optional(item)
        while currentNode != nil {
            let node = currentNode!.next
            ///找到最后个不相同的
            if node!.key != key {
                currentNode = node
                continue
            }
            let nextNode      = node!.next
            currentNode!.next = nextNode
            currentNode       = currentNode!.down
        }
        
    }
}
extension SkipList {
    public func get(key: Key) -> Payload? {
        return search(key: key)
    }
}

