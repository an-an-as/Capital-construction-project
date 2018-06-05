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
    init() {
        self = .leaf
    }
    init(value:Element) {
        self = .node(.leaf,value,.leaf)
    }
}
extension BinarySearchTree {
    var isEmpty:Bool {
        if case .leaf = self {
            return true
        } else { scu
            return false
        }
    }
}
extension BinarySearchTree {
    mutating func insert(_ value:Element) {
        switch self {
        case .leaf:
            self = BinarySearchTree(value: value)
        case .node(var left,let current,var right):
            if value < current {
                left .insert(value)
            }
            if value > current {
                right.insert(value)
            }
            self = .node(left,current,right)
        }
    }
}
extension BinarySearchTree {
    func contains(_ value:Element ) -> Bool {
        switch self {
        case .leaf:
            return false
        case .node(_,let current,_) where current == value:
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
    func reduce<T>(initial leaf:T, handle node: @escaping (T,Element,T) -> T) -> T {
        switch self {
        case .leaf:
            return leaf
        case let .node(leafL,value,leafR):
            return node(leafL.reduce(initial: leaf, handle: node),value,
                        leafR.reduce(initial: leaf, handle: node))
        }
    }
}
extension BinarySearchTree {
    var elements:[Element] {
        return reduce(initial: [], handle: { $0 + [$1] + $2 })
        ///当计算属性调用的时候执行逃逸函数
    }
    var count:Int {
        return reduce(initial: 0, handle: { 1 + $0 + $2 })
    }
}
extension Sequence {
    func checkAll(predicate:(Iterator.Element) -> Bool) -> Bool {
        for element in self where !predicate(element) {
            return false
        }
        return true
    }
}
extension BinarySearchTree {
    var isBST:Bool {
        switch self {
        case .leaf:
            return true
        case let .node(treeL,root,treeR):
            return treeL.elements.checkAll{ $0 < root } && treeR.elements.checkAll{ $0 > root }
                && treeL.isBST && treeR.isBST /// 再次递归包含根节点 遍历重复包含前两次效率低
        }
    }
}
func +<L:IteratorProtocol,R:IteratorProtocol>(lhs:L,rhs:@escaping @autoclosure () -> R ) -> AnyIterator<L.Element> where L.Element == R.Element {
    var l = lhs
    var other: R? = nil
    return AnyIterator {
        if other != nil {
            return other!.next()
            ///  left.makeIterator() + CollectionOfOne(value).makeIterator()
        } else if let result = l.next() {
            ///CollectionOfOne(value).makeIterator()  -> nil  || CollectionOfOne(value).makeIterator() + right.makeIterator()
            return result
        } else {
            other = rhs()
            /// nil +  CollectionOfOne(value).makeIterator() + nil
            return other!.next()
        }
    }
}
extension BinarySearchTree: Sequence {
    func makeIterator() -> AnyIterator<Element> {
        switch self {
        case .leaf:
            return AnyIterator{ return nil }
        case let .node( left,value,right ):
            return left.makeIterator() + CollectionOfOne(value).makeIterator() + right.makeIterator()
        }
    }
}
extension BinarySearchTree: ExpressibleByArrayLiteral {
    init(arrayLiteral elements:Element ...) {
        self.init()
        elements.forEach{ insert($0) }
    }
}
extension BinarySearchTree: CustomStringConvertible {
    var description: String {
        return "\(elements)"
    }
}
var tree:BinarySearchTree<Int> = [1,2,3,4,5]
print(tree,tree.count,tree.isBST,tree.isEmpty,tree.contains(5), separator: "\n", terminator: "\n")
