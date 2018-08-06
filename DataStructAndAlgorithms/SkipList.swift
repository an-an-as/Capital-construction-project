/**
 William Worthington .1990/US
 
 跳表是一种随机化的数据结构一种可以进行二分查找的有序链表
 跳跃表的结构是多层的，通过从最高维度的表进行检索再逐渐降低维度从而达到对任何元素的检索接近线性时间的目的O(logn)
 
 ````
 
 layer5 head   -------------------------------> 37  nil
 |                                              |
 layer4 head   -------------------------------> 37  nil
 |
 layer3 head   1  ---------------> 21   nil
 |       |                          |
 layer2 head   1 ---> 7  --------> 21  -------> 37  nil
 |       |     |                    |            |
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
        /// init(() -> AnyIterator.Element?)
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
    func findNode(key: Key) -> Node? {                                  /// 从跳表当前的最上层的头节点开始查询一个key是否存在
        var currentNode: Node? = head                                   /// 如果通过当前指针不断的重指向最终还是没找指向了nil或当前头节点为nil 结束循环
        var isFound: Bool = false                                       /// 查看当前下一个节点的可选情况 如果为nil当前值指针指向下一层
        while !isFound {                                                /// 如果下一个节点不为nil 该节点的key变量和要查找的key相同结束循环
            if let node = currentNode {                                 /// 如果下一个节点的key > 要查找的节点 说明目标节点在插入的时候conflip为false并未复制跳过了该节点
                switch node.next {                                      /// 如果下一个节点的key < 或 = 要查找的值,当前节点指针指向下一个节点 开始下一轮循环判断current
                case .none:                                             //  7 --------  12  ------- 15  nil
                    currentNode = node.down                             /// 7 ---10---  12  ------- 15  nil
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
    private func bootstrapBaseLayer(key: Key, data: Payload) {          /// 初始化对象方法 通过coninFlip判断是否对该节复制出新的链表
        head = Node(asHead: true)                                       //  LAYER2:  node(head) -> node(key9) currentTopNode -> nil
        var node = Node(key: key, data: data)                           /// LAYER1:  node(head) -> node(key9) currentTopNode -> nil
        head!.next = node
        var currentTopNode = node
        while coinFlip() {
            let newHead    = Node(asHead: true)
            node           = Node(key: key, data: data)
            newHead.next   = node
            newHead.down   = head
            node.down      = currentTopNode
            currentTopNode = node
            head           = newHead
        }
    }
    private func insertItem(key: Key, data: Payload) {
        var stack              = Stack<Node>()
        var currentNode: Node? = head               ///  SkipLis head: Node  Node -> DataNode<Key,payload> -> key data next down
        while currentNode != nil {                  ///
            if let nextNode = currentNode!.next {   ///  insert 9 每个值进行比较 10 > 9 down
                if nextNode.key! > key {            ///  node(head)  node(10)   stack[node(head)]
                    stack.push(currentNode!)        ///  node(head)  node(10)   stack[node(head), node(head)]
                    currentNode = currentNode!.down ///
                } else {                            ///
                    currentNode = nextNode
                }
            } else {
                stack.push(currentNode!)
                currentNode = currentNode!.down
            }
        }                                                           //     node(head) node(head) -> node(9):currentTopNode -> nil
        let itemAtLayer    = stack.pop()                            ///                           |
        var node           = Node(key: key, data: data)             ///    node(head) node(head) -> node(9,currentTopNode) -> nil
        node.next          = itemAtLayer!.next                      ///
        itemAtLayer!.next  = node                                   ///
        var currentTopNode = node                                   ///    stackEmpty  head = nil
        while coinFlip() {                                          ///    node(head)-> node(9)
            if stack.isEmpty {                                      ///                  |
                let newHead    = Node(asHead: true)                 ///                 nil stack.pop
                node           = Node(key: key, data: data)
                head           = newHead
                newHead.next   = node
                newHead.down   = head
                node.down      = currentTopNode
                currentTopNode = node
            } else {
                let nextNode   = stack.pop()
                node           = Node(key: key, data: data)
                nextNode!.next = node              // error:  !!!
                node.next      = nextNode!.next    // 循环引用
                node.down      = currentTopNode
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
        }                                               ///  在跳表中找到该值返回前一节点 重新赋值指针 修改下面层级
        var currentNode = Optional(item)                ///  currentNode.down之后的next值和当前key不相同的情况
        while currentNode != nil {                      ///  7 -------- 12  ------- 15  continue 递进到目标值12前一个节点
            let node = currentNode!.next                ///  CURRNET
            if node!.key != key {                       ///  7 ----14---12  ------- 15
                currentNode = node                      ///         |
                continue                                ///       CURRENT
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
extension SkipList: CustomStringConvertible {
    public var description: String {
        var current = head
        var temp = [Node]()
        while let downNode = current?.down {
            current = downNode
        }
        while let next = current?.next {
            temp.append(next)
            current = next
        }
        return temp.map { "\($0.key!): \($0.data!)" }.joined(separator: ",\t")
    }
}
var list = SkipList<String, Int>()
list.insert(key: "a", data: 1)
list.insert(key: "b", data: 2)
print(list)
/***********************************   VERSION 2  ***********************************/
import Foundation
internal func coinFlip() -> Bool {
    return arc4random_uniform(2) == 1
}
internal enum Stack<Element> {
    case end
    indirect case node(Element, Stack)
    init() {
        self = .end
    }
}
extension Stack {
    internal var isEmpty: Bool {
        if case .end = self {
            return true
        }
        return false
    }
}
extension Stack {
    internal mutating func cons(_ newElement: Element) -> Stack {
        return .node(newElement, self)
    }
}
extension Stack {
    internal mutating func push(_ newElement: Element) {
        self = cons(newElement)
    }
    internal mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(currentValue, nextNode):
            self = nextNode
            return currentValue
        }
    }
}
public struct SkipList<Key: Comparable, Value> {
    fileprivate(set) var head: Node?
}
extension SkipList {
    internal typealias Node = SkipListNode<Key, Value>
    internal class SkipListNode<Key: Comparable, Value> {
        var key: Key?
        var value: Value?
        var next: Node?
        var down: Node?
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
        init() {}
    }
}
extension SkipList {
    public subscript(key: Key) -> Value? {
        get {
            return findNode(by: key)?.next?.value
        }
        set {
            if let new = newValue {
                insert(key: key, value: new)
            } else {
                remove(key: key)
            }
        }
    }
}
extension SkipList {
    internal func findNode(by key: Key) -> Node? {
        var current = head
        var isFound = false
        while !isFound {
            guard  current != nil else { break }
            switch current?.next {
            case .none: current = current?.down
            case .some(let nextNode) where nextNode.key != nil:
                if nextNode.key == key {
                    isFound = true
                    break
                } else {
                    current = (key < nextNode.key!) ? current?.down : current?.next
                }
            default: continue
            }
        }
        return isFound ? current : nil
    }
}
extension SkipList {
    private mutating func bootstrapAtLayer(key: Key, value: Value) {
        head = Node()
        var newNode = Node(key: key, value: value)
        head?.next = newNode
        var currentTopNode = newNode
        while coinFlip() {
            let newHead = Node()
            newNode = Node(key: key, value: value)
            newHead.next = newNode
            newHead.down = head
            newNode.down = currentTopNode
            currentTopNode = newNode
            head = newHead
        }
    }
    private mutating func insertNewElement(key: Key, value: Value) {
        var current = head
        var stack = Stack<Node>()
        while current != nil {
            if let nextNode = current?.next {
                if key < nextNode.key! {
                    stack.push(current!)
                    current = current?.down
                } else {
                    current = current?.next
                }
            } else {
                stack.push(current!)
                current = current?.down
            }
        }
        let nodeAtLayer = stack.pop()
        var newNode = Node(key: key, value: value)
        newNode.next = nodeAtLayer?.next
        nodeAtLayer?.next = newNode
        var currentTopNode = newNode
        while coinFlip() {
            if stack.isEmpty {
                let newHead = Node()
                newNode = Node(key: key, value: value)
                newHead.next = newNode
                newHead.down = head
                newNode.down = currentTopNode
                currentTopNode = newNode
                head = newHead
            } else {
                let nodeAtLayer = stack.pop()
                newNode = Node(key: key, value: value)
                newNode.next = nodeAtLayer?.next
                nodeAtLayer?.next = newNode
                newNode.down = currentTopNode
                currentTopNode = newNode
            }
        }
    }
    public mutating func insert(key: Key, value: Value) {
        guard head != nil else { return bootstrapAtLayer(key: key, value: value) }
        if let prev = findNode(by: key) {
            var aimNode = prev.next
            while aimNode != nil && aimNode!.key == key {
                aimNode?.value = value
                aimNode = aimNode?.down
            }
        } else {
            insertNewElement(key: key, value: value)
        }
    }
}
extension SkipList {
    public mutating func remove(key: Key) {
        guard let prev = findNode(by: key) else { return }
        var prevNode = Optional(prev)
        while prevNode != nil {
            let aimNode = prevNode?.next
            if aimNode?.key != key {
                prevNode = aimNode
                continue
            }
            prevNode?.next = aimNode?.next
            prevNode = prevNode?.down
        }
    }
}
extension SkipList: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        elements.forEach {
            insert(key: $0.0, value: $0.1)
        }
    }
}
extension SkipList: CustomStringConvertible {
    public var description: String {
        var current = head
        var temp = [Node]()
        while current?.down != nil {
            current = current?.down
        }
        while let next = current?.next {
            temp.append(next)
            current = next
        }
        return temp.map { "\($0.key!):\($0.value!)" }.joined(separator: "  --->  ")
    }
}
extension SkipList: CustomDebugStringConvertible {
    public var debugDescription: String {
        var str = ""
        var current = head
        var nodesAtLayer = [Node]()
        var list = [[Node]]()
        while current != nil {
            var headAtLayer = current
            while let next = headAtLayer?.next {
                nodesAtLayer.append(next)
                headAtLayer = next
            }
            list.append(nodesAtLayer)
            nodesAtLayer.removeAll()
            current = current?.down
        }
        for (index, element) in list.enumerated() {
            str += "layer\(list.count - index): "
                + element.map { "\($0.key!):\($0.value!)" }.joined(separator: "  --->  ") + "\n"
        }
        return str
    }
}
var list: SkipList  = ["a": 1, "b": 2, "c": 3]
print(list) // a:1  --->  b:2  --->  c:3
print(list.debugDescription)
// layer2: b:2  --->  c:3
// layer1: a:1  --->  b:2  --->  c:3
print(list["a"])                  // Optional(1)
list["a"] = 100; print(list["a"]) // Optional(100)
list["a"] = nil; print(list)      // b:2  --->  c:3
