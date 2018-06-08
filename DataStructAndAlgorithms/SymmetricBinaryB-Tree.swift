/**
 R. BayerE. M. McCreight 1971
 1978年 B树衍生特殊形式:RedBlackTree
 ----
 描述:将有序数组和搜索树合并到一个统一的数据结构中  数据量大的时候可以提供对数性能  数据量较小的时候可以提供超快的插入操作
 
 结构:
 order阶: 分割点 order一般 100-2000
 每个节点的最大子节点数在树创建的时候就已经决定了，这个值被叫做 B 树的阶(阶的英文和顺序一样，都是 order，但是阶和元素的顺序无关。)
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
 */
import Foundation
import Darwin
/// Darwin 系统 (Apple 操作系统底层的内核) 提供了 sysctl 指令用来查询缓存的大小
/// 在 Darwin 中，还有很多其他的 sysctl 名称；通过在命令行窗口运行 man 3 sysctl 来获取最常用的名称列表。
/// sysctl -a 获取一份所有可用查询以及它们的当前值的列表，confnames.h 列出了所有你能用来作为 sysconf 参数的符号名称
/// DESCRIPTION
/**
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
public let cacheSize: Int? = {
    var result: Int = 0
    var size = MemoryLayout<Int>.size
    /// MemoryLayout 获取单个元素在连续内存缓冲区中占用的字节数 默认8字节
    let status =  sysctlbyname("hw.l1dcachesize", &result, &size, nil, 0)
    guard status != -1 else { return nil }
    return result
}()
public struct BTree<Element: Comparable> {
    fileprivate var root: Node
    init(order: Int) { self.root = Node(order: order) }
}
extension BTree {
    final class Node {
        let order: Int
        var mutationCount:Int64 = 0
        var elements: [Element] = []
        var children: [Node] = []
        init(order: Int) { self.order = order }
    }
}
extension BTree {
    public  init() {
        let order = (cacheSize ?? 32768) / (4 * MemoryLayout<Element>.stride)///元素尺寸
        ///// 在缓存区中可存储的元素数量
        self.init(order: Swift.max(16, order))
        /// max 的调用确保了即使在元素尺寸巨大的时候，还是能得到一棵足够茂密的树
    }
}
extension BTree {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root.forEach(body)
    }
}
extension BTree.Node {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        if children.isEmpty {
            try elements.forEach(body)
        }  else {
            /// 根据element确定children引用的下标
            for i in 0 ..< elements.count {///                                               @@ @ @@   order:4
                try children[i].forEach(body)///递归询问是否存在子节点获取左树元素
                try body(elements[i])///   获取根节点元素                                      element         @
            }                                          ///                                   children     /     \
            try children[elements.count].forEach(body)///递归剩下的节点                         element    @@      @@
        }                                                                        ///         children   |||     |||
    }
}
extension BTree.Node{
    internal func slot(of element: Element) -> (match: Bool, index: Int) {
        var start = 0
        var end = elements.count
        while start < end {
            let mid = start + (end - start) / 2
            if elements[mid] < element {
                start = mid + 1
            }
            else {
                end = mid
            }
        }
        let match = start < elements.count && elements[start] == element
        return (match, start)
    }
}
extension BTree {
    public func contains(_ element: Element) -> Bool  {
        return root.contains(element)
    }
}
extension BTree.Node {
    func contains(_ element: Element) -> Bool {
        let slot = self.slot(of: element)
        if slot.match { return true }
        guard !children.isEmpty else { return false }
        return children[slot.index].contains(element)
        /// 调用 slot(of:) 方法，如果它找到了一个匹配的位置，那么所寻找的元素肯定在树中
        /// contains 应该返回 true。否则，我们可以使用返回的 index 值来将搜索范围缩小到某一个子节点中
        /// 有序数组算法和搜索树算法结合!确定是在左子树还是在右子树
    }
}
// copy on write
extension BTree {
    fileprivate mutating func makeRootUnique() -> Node {
        if isKnownUniquelyReferenced(&root) { return root }
        root = root.clone()
        return root
    }
}
extension BTree.Node {
    func makeChildUnique(at slot: Int) -> BTree<Element>.Node {
        ///需要添加一个参数来告诉函数之后想要改变的子节点到底是哪个
        guard !isKnownUniquelyReferenced(&children[slot]) else { return children[slot] }
        ///guard 取非 出触发else 如果不是唯一引用
        let clone = children[slot].clone()
        children[slot] = clone
        return clone
    }
}
extension BTree.Node {
    func clone() -> BTree<Element>.Node {
        let clone = BTree<Element>.Node(order: order)
        clone.elements = self.elements
        clone.children = self.childrenc
        return clone
    }
}
//Utility Predicates
extension BTree.Node {
    var isLeaf: Bool { return children.isEmpty }
    var isTooLarge: Bool { return elements.count >= order }
}
extension BTree {
    struct Splinter {
        let separator: Element
        let node: Node
    }
}
extension BTree.Node {
    func split() -> BTree<Element>.Splinter {
        /// 分离出中间值 [1,2,3,4,5]  middle = 2
        let count = elements.count
        let middle = count / 2
        /// 分离出的值  3  然后把后面两个值单独放一节点
        let separator = elements[middle]
        /// 创建新节点加入分割后的剩余部分
        let node = BTree<Element>.Node(order: order)
        /// 新的elements  [3..<5] = 4 , 5
        node.elements.append(contentsOf: elements[middle + 1 ..< count])
        /// [2..<5] = 删除 3 4 5 原有节点的element的就剩下 1 , 2
        elements.removeSubrange(middle ..< count)
        /// 如果有子树引用在新节点内添加子树分割后的后半部分
        if !isLeaf {                                                                         ///        1   2   3   4         elements                 separator 3
                                                                                             ///       /  |   |   |   \       insert 5  ->  elements 1  2    newNodeR 4  5
            node.children.append(contentsOf: children[middle + 1 ..< count + 1])             ///     0.9 1.9 2.9 3.9  4.9     children              /  |  \          /  |
            children.removeSubrange(middle + 1 ..< count + 1)                                ///                                                  0.9 1.9 2.9      3.9 4.9
        }                                                                                    ///
        return BTree.Splinter(separator: separator, node: node)                              ///
    }
}
extension BTree.Node {
    /// 利用碎片和分割方法将一个新元素插入到某个节点中 两种情况:已经存在返回原值和不存在插入
    func insert(_ element: Element) -> (old: Element?, splinter: BTree<Element>.Splinter?) {
        /// 寻找节点中新元素所对应的位置。如果这个元素已经存在了，那么直接返回这个值，而不进行任何修改
        let slot = self.slot(of: element)
        if slot.match { return (self.elements[slot.index], nil) }
        /// 否则，就需要实际进行插入，首先肯定需要将变更计数加一
        mutationCount += 1
        /// 将一个新元素插入到叶子节点：插入到 elements 数组的正确的位置中就可以了。
        /// 这个额外加入的元素可能会使节点过大。当这种情况发生时，需要使用 split() 将节点分割为两半，并且将结果的碎片返回
        if self.isLeaf {
            elements.insert(element, at: slot.index)
            return (nil, self.isTooLarge ? self.split() : nil)
        }
        /// 如果节点拥有子节点，需要通过递归调用来将它插入到子节点中正确的位置                               elements           [3 8]   ········· 插入20 在elements中二分得到 index:2
        /// insert 是一个可变方法，所以在需要的时候，应该调用 makeChildUnique(at:) 来创建写时复制的副本     chiledrend    /      |      \2       根据index copy children[2]
        /// 如果递归的 insert 返回一个碎片，则需要把它插入到 self 中已经计算出的位置：                                 1 2     4 6    10 12 16   children[2]递归寻找子树isert index = 3
        
        let (old, splinter) = makeChildUnique(at: slot.index).insert(element)                  ///               [3  8   16]         [10 12 16 20] > order 20 -> splite
        /// insert递归回溯上一级elemens
        guard let s = splinter else { return (old, nil) }                                      ///      1 2     4 6   10 12    19  20
        elements.insert(s.separator, at: slot.index)                                           ///  element insert splite.spatrator 16 at index2
        children.insert(s.node, at: slot.index + 1)                                            ///  children  分割后在其separator 右侧添加 index
        return (nil, self.isTooLarge ? self.split() : nil)
        /// 这样一来，当一个元素插入到 B 树中一条全满路径的末端时，insert 将触发一系列的分割，最终将其从插入点向上一直传递到树的根节点
    }
}
extension BTree {
    /// 如果路径上的所有节点都已经满了，那么最终根节点自身将被分割。
    /// 这时候，需要向树中添加新的层，具体的做法是：创建一个包含原根节点及得到的碎片的新根节点。
    /// 实现这个处理的最佳位置是 BTree 结构体的公有 insert 方法之中，对树进行任何变更之前务必先调用 makeRootUnique 方法：
    
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let root = makeRootUnique()
        let (old, splinter) = root.insert(element)
        if let splinter = splinter {
            let r = Node(order: root.order)
            r.elements = [splinter.separator]
            r.children = [root, splinter.node]
            self.root = r
            ///转换root设置为新的Node节点原root转换为Nodes
        }
        return (old == nil, old ?? element)
    }
}

//实现集合类型
extension BTree {
    struct UnsafePathElement {
        ///节点 unowned 同生共死不会带来引用上的额外开销
        unowned(unsafe) let node: Node/// 节点的引用
        var slot: Int/// 节点的位置
    }
}
/// 路径
extension BTree.UnsafePathElement {
    var value: Element? {
        guard slot < node.elements.count else { return nil }
        return node.elements[slot]                                 /// 路径上节点内元素所引用的值
    }
    var child: BTree<Element>.Node { return node.children[slot] }  /// 这个值之前对应的子节点
    var isLeaf: Bool { return node.isLeaf }                        /// 元素上的节点是不是 叶子节点
    var isAtEnd: Bool { return slot == node.elements.count }       /// 路径元素是否指向节点的末尾
}
/// 比较路径元素的像等性
extension BTree.UnsafePathElement: Equatable {
    static func ==(left: BTree<Element>.UnsafePathElement, right: BTree<Element>.UnsafePathElement) -> Bool {
        return left.node === right.node && left.slot == right.slot
    }
}
//索引
extension BTree {
    public struct Index {
        fileprivate weak var root: Node?            /// 没有具体的树的值 和 索引中的值的时候 可以使用索引自身来验证 所以用 weak
        fileprivate let mutationCount: Int64        /// 索引被创建时的变更次数
        fileprivate var path: [UnsafePathElement]   /// 路径元素序列  通过增加最终路径元素的位置值，来进行索引步进
        fileprivate var current: UnsafePathElement
        /// 将这个“热点”元素从数组里拿出来，单独存储在一个 current 属性里，可以让这种通用处理稍微快一些
        /// Array 自身的索引验证，以及其固有的对数组底层存储缓冲区进行的非直接访问 带来些许的性能开销
        /// 前者将构造一条通向树中首个元素的路径，而后者只用将路径设在在根节点中最后一个元素之后即可
        /// 理论上说，startIndex 的复杂度是 对数级的
        /// 不过我们已经看到，实际上 B 树的深度更接近于 O(1)，所以在这种情况下，我们完全没有违背 Colleciton 中关于性能的要求
        
        /// 两个内部初始化方法，来创建树的 startIndex 和 endIndex
        init(startOf tree: BTree) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(node: tree.root, slot: 0)
            while !current.isLeaf { push(0) } /// 子节点
        }
        init(endOf tree: BTree) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(node: tree.root, slot: tree.root.elements.count)
        }
    }
}
//索引导航
extension BTree.Index {
    /// push 接受一个与当前路径相关的 子节点 中的位置值，并把它添加到路径的末端。pop 则负责将路径的最后一个元素移除
    fileprivate mutating func push(_ slot: Int) {
        path.append(current) ///  先放入根节点  self.current = UnsafePathElement(node: tree.root, slot: 0)                    currentUnsafeElement: tree.root
        let child = current.node.children[current.slot] /// 取出子节点                                                        child = chulildren[0]
        current = BTree<Element>.UnsafePathElement(node: child, slot: slot) /// 此时current 为子节点不是根节点                  currentUnsafeElement: children[0]
    }
    fileprivate mutating func pop() {
        current = self.path.removeLast()
    }
    /**
     有了这两个函数，我们就能定义在树中从一个索引步进到下一个元素的方法了。
     对于绝大多数情况来说，这个方法要做的仅仅是增加当前路径元素 (也就是最后一个元素，current) 的位置值。
     仅有的例外发生于 (1) 对应的叶子节点中没有更多的元素时，或者 (2) 当前节点不是一个叶子节点时。(两种情况相对来说都是很罕见的。
     */
}
extension BTree.Index {
    fileprivate mutating func formSuccessor() {
        precondition(!current.isAtEnd, "Cannot advance beyond endIndex")
        current.slot += 1
        if current.isLeaf {
            /// 可能一次都不会执行
            while current.isAtEnd, current.node !== root { pop() }
            /// 上溯到最近的拥有更多元素的祖先节点
        }
        else {
            while !current.isLeaf { push(0) }
            /// 下行到当前节点最左侧叶子节点的开头
        }
    }
}
/// 寻找前置索引
extension BTree.Index {
    fileprivate mutating func formPredecessor() {
        if current.isLeaf {
            while current.slot == 0, current.node !== root {
                pop()
            }
            precondition(current.slot > 0, "Cannot go below startIndex")
            current.slot -= 1
        }
        else {
            while !current.isLeaf {
                let c = current.child
                push(c.isLeaf ? c.elements.count - 1 : c.elements.count)
            }
        }
    }
}



//索引验证
extension BTree.Index {
    fileprivate func validate(for root: BTree<Element>.Node) {
        precondition(self.root === root)
        /// 任意有效的 B 树索引中根节点的引用不能是 nil
        precondition(self.mutationCount == root.mutationCount)
        /// 当某个索引中根节点引用和变更计数两者都匹配时，我们就知道该索引依然有效，也就能安全地使用它的路径上的元素了
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
    public static func ==(left: BTree<Element>.Index, right: BTree<Element>.Index) -> Bool {
        BTree<Element>.Index.validate(left, right)
        return left.current == right.current
    }
    public static func <(left: BTree<Element>.Index, right: BTree<Element>.Index) -> Bool {
        BTree<Element>.Index.validate(left, right)
        switch (left.current.value, right.current.value) {
        case let (a?, b?): return a < b
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
    public func formIndex(after i: inout Index) {
        i.validate(for: root)
        i.formSuccessor()
    }
    public func formIndex(before i: inout Index) {
        i.validate(for: root)
        i.formPredecessor()
    }
    public func index(after i: Index) -> Index {
        i.validate(for: root)
        var i = i
        i.formSuccessor()
        return i
    }
    public func index(before i: Index) -> Index {
        i.validate(for: root)
        var i = i
        i.formPredecessor()
        return i
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

/// UnsafePathElement node, slot, value?(node.elements[slot])  child(node.children[slot]) isLeaf(node.isLeaf) isAtEnd(node.element.count)
/// Index: root mutainCount path[UnsafePathElement]  current:UnsafePathElement
