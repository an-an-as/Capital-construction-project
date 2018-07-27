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













