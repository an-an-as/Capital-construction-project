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


