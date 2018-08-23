/**
 R. BayerE. M. McCreight 1971
 1978年 B树衍生特殊形式:RedBlackTree
 ----
 描述:将有序数组和搜索树合并到一个统一的数据结构中  数据量大的时候可以提供对数性能  数据量较小的时候可以提供超快的插入操作
 
 结构:
 order阶: 分割点 order一般 100-2000
 每个节点的最大子节点数在树创建的时候就已经决定了，这个值被叫做 B 树的阶(阶的英文和顺序一样，都是 order，但是阶和元素的顺序无关
 节点中能存放的元素的最大数量要比它的阶的数字小一。这很可能会导致计算索引时发生差一错误，所以在实现和使用 B 树的时候需格外小心
 
 最小尺:     (order-1) / 2 非根节点中至少要填满一半
 最大尺寸:   寸节点中能存放的元素的最大数量 = 阶的数量 - 1 按照升序排列
 深度均匀:   所有叶子节点上的深度必须相同
 
 ----
 #### 好处
 降低内存开销:        红黑树每个值存放在一个单独的节点 每个节点都需要在堆上进行申请  B树中的节点批量存储元素
 存区模式适合内存:     B树元素存储在缓冲区中,通过获取设备缓存尺寸进行匹配获得最大的缓冲空间 那么在速度上要快于存放在堆上的红黑树
 
 > 性能测试表明
 当元素缓冲区的最大尺寸大约为 CPU L1 缓存尺寸的四分之一时，B 树拥有最快的速度
 
 ----
 
 Darwin 系统 (Apple 操作系统底层的内核) 提供了 sysctl 指令用来查询缓存的大小
 在 Darwin 中，还有很多其他的 sysctl 名称；通过在命令行窗口运行 man 3 sysctl 来获取最常用的名称列表。
 sysctl -a 获取一份所有可用查询以及它们的当前值的列表，confnames.h 列出了所有你能用来作为 sysconf 参数的符号名称
 
 DESCRIPTION
 The sysctl() function retrieves system information and allows processes
 with appropriate privileges to set system information.  The information
 available from sysctl() consists of integers, strings, and tables.
 Information may be retrieved and set from the command interface using the
 sysctl(8) utility.  检索系统信息 允许进程设置系统信息
 
 The sysctlbyname() function accepts an ASCII representation of the name
 and internally looks up the integer name vector.  Apart from that, it
 behaves the same as the standard sysctl() function.
 使用ASCII表示 名字 和 在内部查找的整数向量名
 hw.l1dcachesize              int64_t
 
 The information is copied into the buffer specified by oldp.  The size of
 the buffer is given by the location specified by oldlenp before the call,
 and that location gives the amount of data copied after a successful call
 and after a call that returns with the error code ENOMEM.  If the amount
 of data available is greater than the size of the buffer supplied, the
 call supplies as much data as fits in the buffer provided and returns
 with the error code ENOMEM.  If the old value is not desired, oldp and
 oldlenp should be set to NULL.
 成功调用回返回系统信息  如果不需要旧值设置为nil
 
 The size of the available data can be determined by calling sysctl() with
 the NULL argument for oldp.  The size of the available data will be
 returned in the location pointed to by oldlenp.  For some operations, the
 amount of space may change often.  For these operations, the system
 attempts to round up so that the returned size is large enough for a call
 to return the data shortly thereafter.
 确定可用数据大小
 
 
 To set a new value, newp is set to point to a buffer of length newlen
 from which the requested value is to be taken.  If a new value is not to
 be set, newp should be set to NULL and newlen set to 0.
 为了设置一个新值，newp将指向一个长度为newlen的 需要被带走的值的 缓冲区
 如果一个新值不需要设置，newp应该被设置为NULL，而newlen设置为0。
 */
import Foundation
// swiftlint:disable line_length
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
import Foundation
public let cacheSize: Int? = {                                              /// Darwin 系统 (Apple 操作系统底层的内核) 提供了 sysctl 指令用来查询缓存的大小
    var result: Int = 0                                                     /// MemoryLayout.size 存储布局 在64位系统中指针变量的sizeof 占用的内存字节数 8 如果是数组输出数组所占地址空间的大小
    var size = MemoryLayout<Int>.size                                       /// 通过指令 man 3 sysctl 来获取最常用的名称列表 将其拷贝到缓冲区: "hw.l1dcachesize"
    let status =  sysctlbyname("hw.l1dcachesize", &result, &size, nil, 0)   /// 成功调用回返回系统信息,如果不需要旧值设置为nil:  &result
    guard status != -1 else { return nil }                                  /// 确定可用数据大小: &size
    return result                                                           /// 重新设定缓冲区: nil 0
}()                                                                         /// Optional(32768)
public struct BTree<Element: Comparable> {
    fileprivate var root: Node
    init(order: Int) {
        self.root = Node(order: order)
    }
    public init() {
        let order = (cacheSize ?? 32768) / (4 * MemoryLayout<Element>.stride)   /// 当元素缓冲区的最大尺寸大约为 CPU L1 缓存尺寸的四分之一时，B 树拥有最快的速度
        self.init(order: Swift.max(16, order))                                  /// 计算在缓存中可存储的元素数量 获取单个类型Element在连续内存缓冲区中占用的字节数 默认8字节
    }                                                                           /// max 的调用确保了即使在Element尺寸巨大的时候，还是能得到一棵足够茂密的树
}
extension BTree {
    final class Node {
        let order: Int
        var mutationCount: Int64 = 0         /// mutatinonCount存储节点引用计数
        var elements = [Element]()           /// elements存储元素
        var children = [Node]()              /// children存储子节点的引用
        init(order: Int) {                   ///                            Btree.Node
            self.order = order               /// Btree root ------------>   element: 16
        }                                    ///                            children [Btree.Node, Btree.Node]
    }                                        ///                                          |            |
}                                            ///                             element:  3 8 13        20 25
extension BTree {                            ///                             chileden: [.....]       [.....]
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root.forEach(body)
    }
}
extension BTree.Node {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        if children.isEmpty {
            try elements.forEach(body)
        } else {                                                       ///  一个节点有两个分支 二个节点三个 三个节点四分支...
            for index in 0 ..< elements.count {                        ///  element    [3, 8, 13]                               3         8          13
                try children[index].forEach(body)                      ///  children   [Node1, Node2, Node3, Node4]            / \       / \        /  \
                try body(elements[index])                              ///             element  ------------------->         1,2  4,5,6,7  9,10,11,12  14,15
            }                                                          ///             children: []() empty
            try children[elements.count].forEach(body)                 ///  如果没有子节点遍历当前element内的值(递归最终结果)
        }                                                              ///  如果有子节点在遍历当前element前要递归查询每个子节点内的element
    }                                                                  ///  (所以index in 0..<element.count)得出element[index]3,8,13,其中每个值之前要先得出children中分支节点的element
}                                                                      ///  如果子节点内的children isEmpty 遍历当前子节点内的elemnt 1,2
extension BTree.Node {                                                 ///  双数组执行顺序  Node1 3 Node2 8 Node3 13 0...<count children剩下最后一节点需要处理
    internal func slot(of element: Element) -> (match: Bool, index: Int) {
        var start = 0
        var end = elements.count
        while start < end {
            let mid = start + (end - start) / 2                        /// 若 (start + end) / 2 表达式包含的加法运算可能会在集合类型元素数量过多时发生溢出，从而导致运行时错误
            if elements[mid] < element {                               /// 若 [0, 2, 3] 二分查找 1  start0 end2 mid = 1  最后 end = 1 star = 0 mid = 0  start = 1
                start = mid + 1
            } else {
                end = mid
            }
        }
        let match = start < elements.count && elements[start] == element
        return (match, start)
    }
}
extension BTree {
    public func contains(_ element: Element) -> Bool {
        return root.contains(element)
    }
}
extension BTree.Node {
    func contains(_ element: Element) -> Bool {
        let slot = self.slot(of: element)                        /// 调用 slot(of:) 方法，如果它找到了一个匹配的位置，那么所寻找的元素肯定在树中
        if slot.match { return true }                            /// contains 应该返回 true。否则，我们可以使用返回的 index 值来将搜索范围缩小到某一个子节点中
        guard !children.isEmpty else { return false }            /// 有序数组算法和搜索树算法结合!确定是在左子树还是在右子树 若查找2 element不包含 二分最终index在0 递归查找子节点
        return children[slot.index].contains(element)            /// element    [3, 8, 13]                               3         8          13
    }                                                            /// children   [Node1, Node2, Node3, Node4]            / \       / \        /  \
}                                                                ///            element  ------------------->         1,2  4,5,6,7  9,10,11,12  14,15
extension BTree {                                                ///            children: []() empty
    fileprivate mutating func makeRootUnique() -> Node {
        if isKnownUniquelyReferenced(&root) { return root }
        root = root.clone()
        return root
    }
}
extension BTree.Node {
    func makeChildUnique(at slot: Int) -> BTree<Element>.Node {
        guard !isKnownUniquelyReferenced(&children[slot]) else { return children[slot] }
        let clone = children[slot].clone()
        children[slot] = clone
        return clone
    }
}
extension BTree.Node {
    func clone() -> BTree<Element>.Node {
        let clone = BTree<Element>.Node(order: order)
        clone.elements = self.elements
        clone.children = self.children
        return clone
    }
}
extension BTree.Node {
    var isLeaf: Bool {
        return children.isEmpty
    }
    var isTooLarge: Bool {
        return elements.count >= order
    }
}
extension BTree {
    struct Splinter {
        let separator: Element
        let node: Node
    }
}                                                                                   ///                                                Btree.Spliter
extension BTree.Node {                                                              ///                                                separator: 6  node:
    func split() -> BTree<Element>.Splinter {                                       /// Tree.Node                         Btree.Node                 Btree.Node
        let count = elements.count                                                  /// element: [4,5,6,7,8]  splite =>   element:[4,5]              element:[7,8]
        let middle = count / 2                                                      /// children: empty                   children:empty             children:empty
        let separator = elements[middle]
        let node = BTree<Element>.Node(order: order)
        node.elements.append(contentsOf: elements[middle + 1 ..< count])
        elements.removeSubrange(middle ..< count)
        if !isLeaf {                                                               ///        1   2   3   4         elements                       separator 3
            node.children.append(contentsOf: children[middle + 1 ..< count + 1])   ///       /  |   |   |   \       insert 5  ->  elements 1  2    newNode:  4
            children.removeSubrange(middle + 1 ..< count + 1)                      ///     0.9 1.9 2.9 3.9  4.9     children              /  |  \           /  \
        }                                                                          ///                                                  0.9 1.9 2.9       3.9  4.9
        return BTree.Splinter(separator: separator, node: node)
    }
}
extension BTree.Node {
    func insert(_ element: Element) -> (old: Element?, splinter: BTree<Element>.Splinter?) { /// 利用碎片和分割方法将一个新元素插入到某个节点中 两种情况:已经存在返回原值和不存在插入
        let slot = self.slot(of: element)                                                    /// 寻找节点中新元素所对应的位置。如果这个元素已经存在了，那么直接返回这个值，而不进行任何修改
        if slot.match { return (self.elements[slot.index], nil) }                            /// 否则，就需要实际进行插入，首先肯定需要将变更计数加一
        mutationCount += 1
        if self.isLeaf {                                                                     /// 将一个新元素插入到叶子节点：插入到 elements 数组的正确的位置中就可以了。
            elements.insert(element, at: slot.index)                                         /// 这个额外加入的元素可能会使节点过大,这时split()将节点分割为两半并将结果的碎片返回
            return (nil, self.isTooLarge ? self.split() : nil)
        }
        let (old, splinter) = makeChildUnique(at: slot.index).insert(element)   ///         3         8          13
        guard let slices = splinter else { return (old, nil) }                  ///        / \       / \        /  \
        elements.insert(slices.separator, at: slot.index)                       ///      1,2  4,5,6,7  9,10,11,12  14,15
        children.insert(slices.node, at: slot.index + 1)                        ///    Node1  Node2    Node3       Node4
        return (nil, self.isTooLarge ? self.split() : nil)                      ///    若insert 2.1 slot 最终结果为0 复制出Node1 递归insert后 复制出的Node1二分插入元素到正确位置
    }                                                                           ///    若children insert 超出 order 得到slices element中插入其分割出来的元素 slices.separator
}                                                                               ///      并且在其右侧子节点(index + 1)插入分割后的剩余部分 slices.node 最后检查整体是否超出order
extension BTree {                                                               ///    当一个元素插入到B树中一条全满路径的末端时insert将触发一系列的分割 最终将其从插入点向上一直传递到树的根节点
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let root = makeRootUnique()                                             ///    如果路径上的所有节点都已经满了，那么最终根节点自身将被分割。
        let (old, splinter) = root.insert(element)                              ///    这时候，需要向树中添加新的层，具体的做法是：创建一个包含原根节点及得到的碎片的新根节点。
        if let splinter = splinter {                                            ///    实现这个处理的最佳位置是BTree结构体的公有insert方法之中对树进行任何变更之前务必先调用makeRootUnique方法
            let newRoot = Node(order: root.order)
            newRoot.elements = [splinter.separator]
            newRoot.children = [root, splinter.node]
            self.root = newRoot
        }
        return (old == nil, old ?? element)
    }
}
extension BTree {
    struct UnsafePathElement {              /// 节点 unowned 同生共死不会带来引用上的额外开销
        unowned(unsafe) let node: Node      /// 节点的引用
        var slot: Int                       /// 节点的位置
    }
}
extension BTree.UnsafePathElement {
    var value: Element? {
        guard slot < node.elements.count else { return nil }
        return node.elements[slot]                                 /// 路径上节点内元素所引用的值
    }
    var child: BTree<Element>.Node { return node.children[slot] }  /// 这个值之前对应的子节点
    var isLeaf: Bool { return node.isLeaf }                        /// 元素上的节点是不是 叶子节点
    var isAtEnd: Bool { return slot == node.elements.count }       /// 路径元素是否指向节点的末尾
}
extension BTree.UnsafePathElement: Equatable {
    static func == (left: BTree<Element>.UnsafePathElement, right: BTree<Element>.UnsafePathElement) -> Bool {
        return left.node === right.node && left.slot == right.slot
    }
}
extension BTree {
    public struct Index {                                                               ///   Btree                                   Btree.Node
        fileprivate weak var root: Node?                                                ///   root---->                               {[16]}
        fileprivate let mutationCount: Int64                                            ///        { [3        8        13]                         [20          25] }
        fileprivate var path: [UnsafePathElement]                                       ///     { [12]   [4567]  [9...12]   [14...15] }   { [17...19]    [21...24]   [26、27] }
        fileprivate var current: UnsafePathElement                                      ///
        init(startOf tree: BTree) {                                                     ///  push to path  node: tree.root slot:0 -> [16]       current{ node:child[0] slot:0 }
            self.root = tree.root                                                       ///                node.childrent[slot]   -> [3、8、13]  current{ node:child[0] slot:0 }
            self.mutationCount = tree.root.mutationCount                                ///                node.childrent[slot]   -> [1、2]      push current: node[]
            self.path = []                                                              ///  pop  current: [1、2]
            self.current = UnsafePathElement(node: tree.root, slot: 0)                  ///
            while !current.isLeaf { push(0) }                                           ///
        }                                                                               ///
        init(endOf tree: BTree) {                                                       ///
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(node: tree.root, slot: tree.root.elements.count)
        }
    }
}
// MARK: - 索引导航 -
extension BTree.Index {
    fileprivate mutating func push(_ slot: Int) {
        path.append(current)
        let child = current.node.children[current.slot]
        current = BTree<Element>.UnsafePathElement(node: child, slot: slot)
    }
    fileprivate mutating func pop() {
        current = self.path.removeLast()
    }
}
extension BTree.Index {
    /// 后继索引
    fileprivate mutating func formSuccessor() {
        precondition(!current.isAtEnd, "Cannot advance beyond endIndex")
        current.slot += 1
        if current.isLeaf {
            while current.isAtEnd, current.node !== root { pop() }      /// slot == node.elements.count  对应的叶子节点中没有更多的元素时 element[1]
        }                                                               /// 或者不是一个叶子结点 element[]   pop上溯到最近的拥有更多元素的祖先节点
        else {                                                          /// 下行到当前节点最左侧叶子节点的开头
            while !current.isLeaf { push(0) }
        }
    }
}
extension BTree.Index {
    /// 前置索引
    fileprivate mutating func formPredecessor() {
        if current.isLeaf {
            while current.slot == 0, current.node !== root {
                pop()
            }
            precondition(current.slot > 0, "Cannot go below startIndex")
            current.slot -= 1
        } else {
            while !current.isLeaf {                                      /// 前置到上一结点的起始位置
                let currentChild = current.child                         /// child node.children[slot]
                push(currentChild.isLeaf ? currentChild.elements.count - 1 : currentChild.elements.count)
            }
        }
    }
}

// MARK: - 索引验证 -
extension BTree.Index {
    fileprivate func validate(for root: BTree<Element>.Node) {
        precondition(self.root === root)                        /// 任意有效的 B 树索引中根节点的引用不能是 nil
        precondition(self.mutationCount == root.mutationCount)  /// 当某个索引中根节点引用和变更计数两者都匹配时，我们就知道该索引依然有效，也就能安全地使用它的路径上的元素了
    }
    fileprivate static func validate(_ left: BTree<Element>.Index, _ right: BTree<Element>.Index) {
        precondition(left.root === right.root)
        precondition(left.mutationCount == right.mutationCount)
        precondition(left.root != nil)
        precondition(left.mutationCount == left.root!.mutationCount)
    }
    /// 将会在 Equatable 和 Comparable 的实现中用上 static 版本的索引验证方法。
    /// 由于这个方法的存在，我们不能将对根节点的弱引用转换为 unowned(unsafe)，因为我们需要在不从外部提供树的参照的情况下，也能完成索引的验证工作
}
//索引比较
/// 索引需要满足 Comparable，所以我们还需要实现索引的判等和小于等于操作符
/// 这些函数是公有入口，因此我们必须记住在访问它们路径上的任意元素之前，先对索引进行验证
extension BTree.Index: Comparable {
    public static func == (left: BTree<Element>.Index, right: BTree<Element>.Index) -> Bool {
        BTree<Element>.Index.validate(left, right)
        return left.current == right.current
    }
    public static func < (left: BTree<Element>.Index, right: BTree<Element>.Index) -> Bool {
        BTree<Element>.Index.validate(left, right)
        switch (left.current.value, right.current.value) {
        case let (valueA?, valueB?): return valueA < valueB
        case (nil, _): return false
        default: return true
        }
    }
}

extension BTree: SortedSet {
    public var startIndex: Index { return Index(startOf: self) }
    public var endIndex: Index { return Index(endOf: self) }
    public subscript(index: Index) -> Element { ///Index结构体
        index.validate(for: root)
        return index.current.value!
        /// value?{node.elements[slot]}
    }
    public func formIndex(after index: inout Index) {
        index.validate(for: root)
        index.formSuccessor()
    }
    public func formIndex(before index: inout Index) {
        index.validate(for: root)
        index.formPredecessor()
    }
    public func index(after index: Index) -> Index {
        index.validate(for: root)
        var index = index
        index.formSuccessor()
        return index
    }
    public func index(before index: Index) -> Index {
        index.validate(for: root)
        var index = index
        index.formPredecessor()
        return index
    }
}
extension BTree {
    public struct Iterator: IteratorProtocol {
        let tree: BTree
        var index: Index
        init(_ tree: BTree) {
            self.tree = tree
            self.index = tree.startIndex
        }
        public mutating func next() -> Element? {
            guard let result = index.current.value else { return nil }
            index.formSuccessor()
            return result
        }
    }
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }
}

var bTree: BTree = BTree<Int>(order: 4)
(0...10).forEach { bTree.insert($0) }
