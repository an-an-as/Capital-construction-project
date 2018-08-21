/// 根节点是黑色的,红色节点只拥有黑色的子节点。(只要有，就一定是),从根节点到一个空位，树中存在的每一条路径都包含相同数量的黑色节点
/// Swift 编译器有时自己就能够将颜色的值放到一个未使用的二进制位
/// 相较于 C/C++/Objective-C，Swift 类型的二进制布局非常灵活，而且编译器拥有很大程度的自由来决定如何进行打包。
/// 对于具有关联值的枚举来说尤其如此，编译器经常能够找到未使用的位模式来表示枚举成员，而无需分配额外的空间来区分它们。
/// 例如，Optional 会将一个引用类型封装到其自身的空间中。Optional.none 成员则由一个从来没有被任何有效引用使用过的 (全零) 位模式来表示。
/// (相同的全零位模式也用来表示 C 的空指针和 Objective-C 的 nil 值，这在某种程度上提供了二进制兼容性。)
import Foundation
protocol SortedSet: BidirectionalCollection, CustomStringConvertible where Element: Comparable {
    init()
    func contains(_ element: Element) -> Bool
    mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element)
}
extension SortedSet {
    public var description: String {
        let contents = self.lazy.map { "\($0)" }.joined(separator: ", ")
        return "[\(contents)]"
    }
}
public enum Color {
    case black
    case red
}
extension Color {
    var symbol: String {
        switch self {
        case .black: return "◯"
        case .red:   return "◉"
        }
    }
}
extension RedBlackTree: CustomStringConvertible {
    func diagram(_ top: String, _ root: String, _ bottom: String) -> String {
        switch self {
        case .empty: return root + "●\n"
        case let .node(color, value, .empty, .empty): return root + "\(color.symbol) \(value)\n"
        case let .node(color, value, left, right):
            return right.diagram(top + "    ", top + "┌───", top + "│   ")
                + root + "\(color.symbol) \(value)\n"
                + left.diagram(bottom + "│   ", bottom + "└───", bottom + "    ")
        }
    }
    public var description: String {
        return self.diagram("", "", "")
    }
}
///  right.diagram 每递归一次空格就会就加长  top: top + “   ”
///  没有右节点的引用后 执行 .node(color, value, .empty, .empty) root: top + "┌───"  换行
///  执行+ root + "\(color.symbol) \(value)\n"  在后面添加 root: top + "┌─── "
///  执行  + left.diagram root:  bottom + "└───"  此时 top: bottom + "│   "  bottom: 空格
///  回到上一次递归 (right.diagram 结束)
///  执行 .node(color, value, .empty, .empty) root = top +  "┌───" 此时 top为 上次right传过来的 bottom + "│   "
///          buttom(空格)+   │
///  形状会变成           ┌───值
public enum RedBlackTree<Element: Comparable> {
    case empty
    indirect case node(Color, Element, RedBlackTree, RedBlackTree)
}
/// indirect 关键字强调了代码中递归的存在，而且也允许编译器将节点的值装箱到隐藏的在堆上申请内存的引用类型中。(这么做是必须的，它可以防止不必要的麻烦，比如编译器无法将特定的存储大小分配给枚举值)
public extension RedBlackTree {
    func contains(_ element: Element) -> Bool {
        switch self {
        case .empty: return false
        case .node(_, element, _, _): return true
        case let .node(_, value, left, _) where value > element: return left.contains(element)
        case let .node(_, _, _, right): return right.contains(element)
        }
    }
}
///中序遍历 (inorder walk)
public extension RedBlackTree {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        switch self {
        case .empty: break
        case let .node(_, value, left, right):
            try left.forEach(body)
            try body(value)
            try right.forEach(body)
        }
    }
}
extension RedBlackTree {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element){
        let (tree, old) = inserting(element)
        self = tree
        return (old == nil, old ?? element)
    }
}
extension RedBlackTree {
    public func inserting(_ element: Element) -> (tree: RedBlackTree, existingMember: Element?) {
        let (tree, old) = _inserting(element)
        switch tree {
        case let .node(.red, value, left, right):           /// 根节点染黑
            return (.node(.black, value, left, right), old) /// 每次平衡后叶子节点为黑
        default:
            return (tree, old)
        }
    }
}
extension RedBlackTree {
    func _inserting(_ element: Element) -> (tree: RedBlackTree, old: Element?) {
        switch self {
        case .empty:
            return (.node(.red, element, .empty, .empty), nil)
        case let .node(_, value, _, _) where value == element:
            return (self, value)
        case let .node(color, value, left, right) where value > element:
            let (l, old) = left._inserting(element)
            if let old = old { return (self, old) }
            return (balanced(color, value, l, right), nil)      /// l: tree
        case let .node(color, value, left, right):
            let (r, old) = right._inserting(element)
            if let old = old { return (self, old) }
            return (balanced(color, value, left, r), nil)
        }
    }
}
extension RedBlackTree {
    func balanced(_ color: Color, _ value: Element, _ left: RedBlackTree, _ right: RedBlackTree) -> RedBlackTree {
        switch (color, value, left, right) {
        case let (.black, z,.node(.red, y, .node(.red, x, a, b),c),d):             ///        Z◯         Z◯        X◯            X◯
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))  ///       /  \        /  \       /  \          /  \                   Y◉
        case let (.black, z, .node(.red, x, a, .node(.red, y, b,c)),d):            ///     Y◉   d      X◉   d     a   Y◉       a    Z◉               /   \
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))  ///     /  \        / \             /  \           / \    ----->   X◯    Z◯
        case let (.black, x, a, .node(.red, z, .node(.red, y, b, c), d)):          ///   X◉   c      a   Y◉          b   Z◉       Y◉   d           /  \   /  \
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))  ///   / \              / \              / \      / \              a   b  c   d
        case let (.black, x, a, .node(.red, y, b, .node(.red, z, c, d))):          ///  a   b            b   c            c   d    b   c
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))  ///
        default:
            return .node(color, value, left, right)
        }
    }
}
extension RedBlackTree {
    public struct Index {
        fileprivate var value: Element?
    }
}
extension RedBlackTree.Index: Comparable {
    public static func ==(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        return left.value == right.value
    }
    public static func <(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        if let lv = left.value, let rv = right.value {
            return lv < rv
        }
        return left.value != nil
    }
}
extension RedBlackTree {
    func min() -> Element? {
        ///效率低 Collection 要求 startIndex 和 endIndex 的实现应该在常数时间内完成
        switch self {
        case .empty:
            return nil
        case let .node(_, value, left, _):
            return left.min() ?? value
        }
    }
}
extension RedBlackTree {
    func max() -> Element? {
        var node = self
        var maximum: Element? = nil
        while case let .node(_, value, _, right) = node {
            maximum = value
            node = right
        }
        return maximum
    }
}
extension RedBlackTree: Collection {
    public var startIndex: Index { return Index(value: self.min()) }
    public var endIndex: Index { return Index(value: nil) }
    public subscript(i: Index) -> Element {
        return i.value!
    }
}
extension RedBlackTree: BidirectionalCollection {
    public func formIndex(after i: inout Index) {
        let v = self.value(following: i.value!)
        precondition(v.found,"Out of range")
        i.value = v.next
    }
    public func index(after i: Index) -> Index {
        let v = self.value(following: i.value!)
        precondition(v.found)
        return Index(value: v.next)
    }
}
extension RedBlackTree {
    func value(following element: Element) -> (found: Bool, next: Element?) {
        switch self {
        case .empty:
            return (false, nil)
        case .node(_, element, _, let right):
            return (true, right.min())
        case let .node(_, value, left, _) where value > element:
            let result = left.value(following: element)
            return (result.found, result.next ?? value)
        case let .node(_, _, _, right):
            return right.value(following: element)
        }
    }
}
extension RedBlackTree {
    public func formIndex(before i: inout Index) {
        let v = self.value(following: i.value!)
        precondition(v.found)
        i.value = v.next
    }
    public func index(before i: Index) -> Index {
        let v = self.value(following: i.value!)
        precondition(v.found)
        return Index(value: v.next)
    }
}
extension RedBlackTree {
    public var count: Int {
        switch self {
        case .empty:
            return 0
        case let .node(_, _, left, right):
            return left.count + 1 + right.count
        }
    }
}
extension RedBlackTree: SortedSet {
    public init() {
        self = .empty
    }
}

var tree:RedBlackTree<Int> = RedBlackTree()
tree.insert(0)
tree.insert(1)
tree.insert(2)
tree.insert(3)

tree.reduce(0,+)
print(tree)

/// 新的树会和原来的树共享一些节点，但是在从根节点到新加入的节点的路径上的节点都是新创建的。这种做法可以很“容易”地实现值语义，但是会造成一些浪费
/// 如果树的某些节点没有被其他值引用的话,可以直接修改它们。这不会造成任何问题，因为根本没有其他人知道这个特定的树的实例。直接修改可以避免绝大部分的复制和内存申请操作，通常这会让性能得到大幅提升
/// Swift 通过提供 isKnownUniquelyReferenced 函数来为引用类型实现优化的写时复制值语义。但是在 Swift 4 中，语言本身并没有为我们提供为代数数据类型实现写时复制的工具。
/// 我们无法访问 Swift 用来包装节点的私有引用类型，因此也就无法获知某个特定节点是不是只有单一引用。(编译器自己还不够聪明，它也并不能帮我们做写时复制优化。)
/// 同时，想要直接获取一个枚举成员里的值，我们也只能先提取一份它的单独的复制。(注意，与此不同，Optional 通过强制解包运算符 !，提供了直接访问存储的值的方式。
/// 然而，为枚举类型提供类似的原地访问的工具只能被使用在标准库中，在标准库外它们是不可用的。


