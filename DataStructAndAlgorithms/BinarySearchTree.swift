/// 二叉排序树的查找过程和次优二叉树类似，通常采取二叉链表作为二叉排序树的存储结构
/// 中序遍历二叉排序树可得到一个关键字的有序序列，一个无序序列可以通过构造一棵二叉排序树变成一个有序序列，构造树的过程即为对无序序列进行排序的过程。
/// 每次插入的新的结点都是二叉排序树上新的叶子结点，在进行插入操作时，不必移动其它结点，只需改动某个结点的指针，由空变为非空即可。
/// 搜索,插入,删除的复杂度等于树高，O(log(n)).
public indirect enum BinarySearchTree<Element: Comparable> {
    case leaf
    case node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}
extension BinarySearchTree {
    init() {
        self = .leaf
    }
    ///当前节点枚举有值情况
    init(value: Element) {
        self = .node(.leaf, value, .leaf)
    }
}
extension BinarySearchTree {
    public var isEmpty: Bool {
        if case .leaf = self {
            return false
        } else {
            return true
        }
    }
    public var count: Int {
        return reduce(0) { $0 + 1 + $2 }
    }
    public var element: [Element] {
        return reduce([]) { $0 + [$1] + $2 }
    }
    public var isBST: Bool {
        switch self {
        case .leaf:
            return true
        case let .node(left, root, right):
            return left.element.checkAll { $0 < root } && right.element.checkAll { $0 > root }
                && left.isBST && right.isBST /// 遍历重复包含前两次效率低
        }
    }
}
extension BinarySearchTree {
    func reduce<T>(_ initial: T, _ handle: @escaping(T, Element, T) -> T) -> T {
        switch self {
        case .leaf:
            return initial
        case let .node(left, value, right): /// 每次递归先逃逸出暂缓回溯后执行闭包
            return handle(left.reduce(initial, handle), value, right.reduce(initial, handle))
        }
    }
}
extension BinarySearchTree {
    public mutating func insert(_ value: Element) {
        switch self {
        case .leaf:/// 修改Node后重新赋值给当前Tree
            self = BinarySearchTree(value: value)
        case .node(var left, let currentValue, var right):
            if value < currentValue {
                left.insert(value)
            }
            if value > currentValue {
                right.insert(value)
            }
            self = .node(left, currentValue, right)
        }
    }
}
extension BinarySearchTree {
    public func contains(_ value: Element) -> Bool {
        switch self {
        case .leaf:
            return false
        case .node(_, let current, _) where current == value:
            return true
        case .node(let left, let current, _) where value < current:
            return left.contains(value)
        case .node(_, let current, let right) where value > current:
            return right.contains(value)
        default:
            fatalError()
        }
    }
}
func + <L: IteratorProtocol, R: IteratorProtocol>
    (lhs: L, rhs: @escaping @autoclosure () -> R) -> AnyIterator<L.Element> where L.Element == R.Element {
    var left = lhs
    var other: R?
    return AnyIterator {
        if other != nil {
            return other!.next()
        } else if let result = left.next() {
            return result
        } else { /// 再次迭代的时候 other!=nil 逃逸赋值给other
            other = rhs()
            return other!.next()
        }
    }
}
extension Sequence {
    public func checkAll(predicate: (Iterator.Element) -> Bool) -> Bool {
        for element in self where !predicate(element) {
            return false
        }
        return true
    }
}
extension BinarySearchTree: Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        switch self {
        case .leaf:
            return AnyIterator { nil }
        case let .node(left, value, right):
            return left.makeIterator() + CollectionOfOne(value).makeIterator() + right.makeIterator()
        }
    }
}
extension BinarySearchTree: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element ...) {
        self.init()
        elements.forEach { insert($0) }
    }
}
extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        return "\(element)"
    }
}
var tree: BinarySearchTree<Int> = [1, 2, 3, 4, 5]
tree.forEach { print($0) }
// MARK: -  Version 2
enum TraversalOrder {
    case preorder
    case postorder
    case inorder
    case breadth
}
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
indirect enum BinarySearchTree<Element: Comparable> {
    case empty
    case node(BinarySearchTree, Element, BinarySearchTree)
}
extension BinarySearchTree {
    init() {
        self = .empty
    }
    init(value: Element) {
        self  = .node(.empty, value, .empty)
    }
}
extension BinarySearchTree {
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
extension BinarySearchTree {
    func reduce<T>(_ initial: T, _ handle: @escaping(T, Element, T) -> T) -> T {
        switch self {
        case .empty: return initial
        case let .node(left, value, right):
            return handle(left.reduce(initial, handle), value, right.reduce(initial, handle))
        }
    }
}
extension BinarySearchTree {
    func traversal(order: TraversalOrder = .breadth) -> [Element] {
        switch order {
        case .preorder: return reduce([]) { [$1] +  $0 + $2 }
        case .inorder: return reduce([]) { $0 + [$1] + $2 }
        case .postorder: return reduce([]) { $0 + $2 + [$1] }
        case .breadth:
            var queue = Queue<BinarySearchTree>()
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
extension BinarySearchTree {
    mutating func insert(_ newElement: Element) {
        switch self {
        case .empty: self = BinarySearchTree(value: newElement)
        case .node(var left, let value, var right):
            if newElement < value { left.insert(newElement) }
            if newElement > value { right.insert(newElement)}
            self = .node(left, value, right)
        }
    }
}
extension BinarySearchTree {
    mutating func contains(_ target: Element) -> Bool {
        switch self {
        case .empty: return false
        case .node(_, let value, _) where target ==  value: return true
        case .node(var left, let value, _) where target < value:
            return left.contains(target)
        case .node(_, let value, var right) where target > value:
            return right.contains(target)
        default: return false
        }
    }
}
let nodeE = BinarySearchTree.node(.empty, 5, .empty)
let nodeD = BinarySearchTree.node(.empty, 4, .empty)
let nodeC = BinarySearchTree.node(nodeD, 3, nodeE)
let nodeB = BinarySearchTree.node(.empty, 2, .empty)
let nodeA = BinarySearchTree.node(nodeC, 1, .empty)
var node = BinarySearchTree.node(nodeA, 0, nodeB)
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

node.insert(6)
node.insert(7)
print(node.traversal(order: .breadth))

///                 node 0
///           nodeA 1   nodeB 2
///      nodeC 3                6
/// nodeD 4  nodeE 5              7
