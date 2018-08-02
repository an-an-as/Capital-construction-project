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
