/**
 + 在二叉树的第i层上至多有2^(i-1)（i >= 1）个节点
 + 深度为k的二叉树至多有2^k-1（k>=1）个节点
 + 二叉树的叶子节点数为n0, 度为2的节点数为n2, 那么n0 = n2 + 1
 
 ````
 
              Root             RECURSION COUNT:
              /  \             left.count + 1  + right.count
           Node  Node         (left.count + 1  + right.count) + 1 + right.count
           /  \     \        [(left.count + 1  + right.count) + 1 + right.count] + 1 + right.count
         Node  Node  Node    return [(  0 + 1  + right.count) + 1 + right.count] + 1 + right.count
                             return [(  0 + 1  + 0          ) + 1 + (left.count  + 1 + right.count)]  +  1  + right.count
                             ......
 
 ````
 */
public indirect enum BinaryTree<T> {
    case empty
    case node(BinaryTree<T>, T, BinaryTree<T>)
}
extension BinaryTree {
    public var count: Int {
        switch self {
        case .empty:
            return 0
        case let .node(left, _, right):
            return left.count + 1 + right.count
        }
    }
}
extension BinaryTree: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .node(left, value, right):
            return "value: \(value), left = [\(left.description)], right = [\(right.description)]"
        case .empty:
            return ""
        }
    }
}
extension BinaryTree {
    public func traverseInOrder(process: (T) -> Void) {
        if case let .node(left, value, right) = self {
            left.traverseInOrder(process: process)
            process(value)
            right.traverseInOrder(process: process)
        }
    }
    public func traversePreOrder(process: (T) -> Void) {
        if case let .node(left, value, right) = self {
            process(value)
            left.traversePreOrder(process: process)
            right.traversePreOrder(process: process)
        }
    }
    public func traversePostOrder(process: (T) -> Void) {
        if case let .node(left, value, right) = self {
            left.traversePostOrder(process: process)
            right.traversePostOrder(process: process)
            process(value)
        }
    }
}
extension BinaryTree {
    func invert() -> BinaryTree {
        if case let .node(left, value, right) = self {
            return .node(right.invert(), value, left.invert())
        } else {
            return .empty
        }
    }
}
// leaf nodes
let node5 = BinaryTree.node(.empty, "5", .empty)
let nodeA = BinaryTree.node(.empty, "a", .empty)
let node10 = BinaryTree.node(.empty, "10", .empty)
let node4 = BinaryTree.node(.empty, "4", .empty)
let node3 = BinaryTree.node(.empty, "3", .empty)
let nodeB = BinaryTree.node(.empty, "b", .empty)
// intermediate nodes on the left
let aMinus10 = BinaryTree.node(nodeA, "-", node10)
let timesLeft = BinaryTree.node(node5, "*", aMinus10)
// intermediate nodes on the right
let minus4 = BinaryTree.node(.empty, "-", node4)
let divide3andB = BinaryTree.node(node3, "/", nodeB)
let timesRight = BinaryTree.node(minus4, "*", divide3andB)
// root node
let tree = BinaryTree.node(timesLeft, "+", timesRight)

// MARK: -  Version: 2
struct Queue<Element> {
    var storage = [Element?]()
    var head = 0
}
extension Queue {
    mutating func enqueue(_ newElement: Element) {
        storage.append(newElement)
    }
    mutating func dequeue() -> Element? {
        guard head < storage.count, let first = storage[head] else { return nil }
        storage[head] = nil
        head += 1
        if storage.count > 50 && (Double(head) / Double(storage.count) > 0.25) {
            storage.removeFirst(head)
            head = 0
        }
        return first
    }
}
indirect enum BinaryTree<Element> {
    case empty
    case node(BinaryTree, Element, BinaryTree)
}
extension BinaryTree {
    var count: Int {
        switch self {
        case .empty: return 0
        case let .node(left, _, right):
            return left.count + 1 + right.count
        }
    }
}
extension BinaryTree: CustomDebugStringConvertible {
    var debugDescription: String {
        var literal = ""
        var queue = Queue<BinaryTree>()
        queue.enqueue(self)
        while let tree = queue.dequeue() {
            if case let .node(left, value, right) = tree {
                queue.enqueue(left)
                queue.enqueue(right)
                literal += "\(value) "
            }
        }
        return literal
    }
}
extension BinaryTree {
    func traversePreOrder(_ process: (Element) -> Void) {
        if case let .node(left, value, right) = self {
            process(value)
            left.traversePreOrder(process)
            right.traversePreOrder(process)
        }
    }
}
let nodeC = BinaryTree.node(.empty, 3, .empty)
let nodeB = BinaryTree.node(.empty, 2, .empty)
let nodeA = BinaryTree.node(nodeC, 1, .empty)
let node = BinaryTree.node(nodeA, 0, nodeB)
print(node)
print(node.traversePreOrder(){ print($0) })

// MARK: - Version 3
enum TraversalOrder {
    case preorder
    case postorder
    case inorder
    case breadth
}
indirect enum BinaryTree<Element> {
    case empty
    case node(BinaryTree, Element, BinaryTree)
}
extension BinaryTree {
    var count: Int {
        return reduce(0) { $0 + 1 + $2 }
    }
    var height: Int {
        return reduce(0) { 1 + max($0, $2) }
    }
    var elemet: [Element] {
        return reduce([]) { $0 + [$1] + $2 }
    }
}
extension BinaryTree {
    func reduce<T>(_ initial: T, _ handle: @escaping(T, Element, T) -> T) -> T {
        switch self {
        case .empty: return initial
        case let .node(left, value, right):
            return handle(left.reduce(initial, handle), value, right.reduce(initial, handle))
        }
    }
}
extension BinaryTree {
    func traversal(order: TraversalOrder = .breadth) -> [Element] {
        switch order {
        case .preorder: return reduce([]) { [$1] +  $0 + $2 }
        case .inorder: return reduce([]) { $0 + [$1] + $2 }
        case .postorder: return reduce([]) { $0 + $2 + [$1] }
        case .breadth:
            var queue = Queue<BinaryTree>()
            queue.enqueue(self)
            var temp = [Element]()
            while let tree = queue.dequeue() {
                if case let .node(left, value, right) = tree {
                    queue.enqueue(left)
                    queue.enqueue(right)
                    temp.append(value)
                }
            }
            return temp
        }
    }
}
let nodeE = BinaryTree.node(.empty, 5, .empty)
let nodeD = BinaryTree.node(.empty, 4, nodeE)
let nodeC = BinaryTree.node(nodeD, 3, .empty)
let nodeB = BinaryTree.node(.empty, 2, .empty)
let nodeA = BinaryTree.node(nodeC, 1, .empty)
let node = BinaryTree.node(nodeA, 0, nodeB)
print(node.traversal(order: .preorder))
print(node.traversal(order: .inorder))
print(node.traversal(order: .postorder))
print(node.traversal(order: .breadth))
///                 node 0
///           nodeA 1   nodeB 2
///      nodeC 3
/// nodeD 4  nodeE 5
_ = [0, 1, 3, 4, 5, 2]
_ = [4, 5, 3, 1, 0, 2]
_ = [5, 4, 3, 1, 2, 0]
_ = [0, 1, 2, 3, 4, 5]
