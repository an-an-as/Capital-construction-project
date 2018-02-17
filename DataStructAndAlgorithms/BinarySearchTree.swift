indirect enum BinarySearchTree<Element: Comparable> {
    case leaf
    case node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}
extension BinarySearchTree {
    init() {
        self = .leaf
    }
    init(_ value: Element) {
        self = .node(.leaf,value,.leaf)
    }
}
extension BinarySearchTree{
    func reduce<A>(leaf leafF: A, node nodeF: @escaping(A, Element, A)-> A)  -> A {
        switch self {
        case .leaf:
            return leafF
        case let .node(left, x, right):
            return nodeF(left.reduce(leaf: leafF, node: nodeF),
                         x,
                         right.reduce(leaf: leafF, node: nodeF))
        }
    }
}
extension BinarySearchTree {
    var elements: [Element] {
        return reduce(leaf: []) { $0 + [$1] + $2 }
    }
    var count: Int {
        return reduce(leaf: 0) { 1 + $0 + $2 }
    }
}
extension BinarySearchTree {
    var isEmpty: Bool {
        if case .leaf = self {
            return true
        }
        return false
    }
}
extension BinarySearchTree {
    func contains(_ x: Element) -> Bool {
        switch self {
        case .leaf:
            return false
        case let .node(_, y, _) where x == y:
            return true
        case let .node(left, y, _) where x < y:
            return left.contains(x)
        case let .node(_, y, right) where x > y:
            return right.contains(x)
        default:
            fatalError("The impossible occur red")
        }
    }
}
extension BinarySearchTree {
    mutating func insert(_ x: Element) {
        switch self {
        case .leaf:
            self = BinarySearchTree(x)
        case .node(var left, let y, var right):
            if x < y { left.insert(x) }
            if x > y { right.insert(x) }
            self = .node(left, y, right)
        }
    }
}
