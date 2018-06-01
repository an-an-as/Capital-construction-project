///树结构的特点是除头节点以外的节点只有一个前驱，但是可以有一个或者多个后继。而二叉树的特点是除头结点外的其他节点只有一个前驱，节点的后继不能超过2个
///在二叉树中，一个节点可以有左节点或者左子树，也可以有右节点或者右子树
///在二叉树的第i层上至多有2^(i-1)（i >= 1）个节点
///深度为k的二叉树至多有2^k-1（k>=1）个节点
///二叉树的叶子节点数为n0, 度为2的节点数为n2, 那么n0 = n2 + 1
///具有n个结点的完全二叉树的深度为log2n + 1 （向下取整，比如3.5，就取3）
///先序遍历就是先遍历根结点，然后遍历左子树，最后遍历右子树
///中序遍历是先遍历左子树，然后遍历根节点，最后遍历右子树
///后序遍历是先遍历左子树，然后再遍历右子树，最后遍历根节点
///以二叉树的根节点为起始节点的广度搜索（BFS)
indirect enum BinarySearchTree<Element:Comparable> {
    case leaf
    case node(BinarySearchTree<Element>,Element,BinarySearchTree<Element>)
}
extension BinarySearchTree {
    init()  {
        self = .leaf
    }
    init(_ value:Element) {
        self = .node(.leaf,value,.leaf)
    }
}
extension BinarySearchTree {
    func reduce<A>(leaf LEAF:A,node NODE:(A,Element,A) -> A) -> A {
        switch self {
        case .leaf:
            return LEAF
        case let .node(left,value,right):
            return NODE(left.reduce(leaf: LEAF, node: NODE),value,right.reduce(leaf: LEAF, node: NODE))
        }
    }
}
extension BinarySearchTree {
    var elements: [Element] {
        return reduce(leaf: []) {$0 + [$1] + $2}
    }
    var count: Int {
        return reduce(leaf: 0) { 1 + $0 + $2 }
    }
}
extension BinarySearchTree {
    var isEmpty:Bool {
        if case .leaf = self {
            return true
        }
        return false
    }
}
extension BinarySearchTree {
    func contains(_ value:Element) -> Bool {
        switch self {
        case .leaf:
            return false
        case .node(_,let current,_) where value == current:
            return true
        case let .node(left,current,_) where value < current:
            return left.contains(value)
        case let .node(_,current,right) where value > current:
            return right.contains(value)
        default:
            fatalError()
        }
    }
}
extension BinarySearchTree {
    var isBST: Bool {
        switch self {
        case .leaf:
            return true
        case let .node(left, x, right):
            return left.elements.all { y in y < x } // elements 中的子树都要小于当前节点
                && right.elements.all { y in y > x }
                && left.isBST
                && right.isBST
        }
    }
}
extension Sequence {
    func all(predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
}
extension BinarySearchTree {
    mutating func insert(_ value:Element) {
        switch self {
        case .leaf:
            self = BinarySearchTree(value)
        case .node(var left, let current, var right):
            if value < current { left.insert(value) }
            if value > current { right.insert(value)}
            self = .node(left,current,right)
        }
    }
}
///拼接两个基础元素类型相同的迭代器
///返回的迭代器会先读取 first 迭代器的所有元素；在该迭代器被耗尽之后，则会从 second 迭代器中生成元素。如果两个迭代器都返回 nil，该合成迭代器也会返回 nil。
func +<I: IteratorProtocol, J: IteratorProtocol>(
    first: I, second: @escaping @autoclosure () -> J)
    -> AnyIterator<I.Element> where I.Element == J.Element
{
    var one = first
    var other: J? = nil
    return AnyIterator {
        if other != nil {
            return other!.next()
        } else if let result = one.next() {
            return result
        } else {
            other = second()
            return other!.next()
        }
    }
}
extension BinarySearchTree: Sequence {
    func makeIterator() -> AnyIterator<Element> {
        switch self {
        case .leaf: return AnyIterator { return nil }
        case let .node(l, element, r):
            return l.makeIterator() + CollectionOfOne(element).makeIterator() +
                r.makeIterator()
        }
    }
}



var bst: BinarySearchTree<Int> = BinarySearchTree()
bst.insert(1)
bst.insert(2)
bst.insert(3)

print(bst.elementsR)
print(bst.isBST)
print(bst.contains(1))
