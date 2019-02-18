/// Quick-Find
/// 将连通图分割成N个最大连通子集 子集内部的对象相互连通 而子集之间的对象互不连通
/// Find operation actually returns the set's label, not its contents
///
/// parent [ 1, 1, 1, 0, 2, 0, 6, 6, 6 ]   父节点    parent[1] = 1 and parent[6] = 6 确定根节点
/// i        0  1  2  3  4  5  6  7  8     各节点
///
///         1              6
///       /   \           / \
///      0     2         7   8
///     / \   /
///    3   5 4
///   通过根节点的index 1 6 来标识分组 Find operation return标识index, not its contents
///
///
public struct UnionFindQuickFind<T: Hashable> {
    private var index = [T: Int]()
    private var parent = [Int]()
    private var size = [Int]()
    public init() {}
    /// Add Set
    public mutating func addSetWith(_ element: T) {                                                                  /// A:0   B:1   C:2
        index[element] = parent.count   /// 通过字典存储index    A: 0    B: 1                                              [0,    1 ,   2]
        parent.append(parent.count)     ///                    [0, 1]           通过parent构建tree  parent[i] 指向 itself   0     1 ,   2
        size.append(1)                  /// We'll be using the size array in the Union operation.                   ///  1  1   1
    }
    /// Find
    private mutating func setByIndex(_ index: Int) -> Int {
        return parent[index]
    }
    public mutating func setOf(_ element: T) -> Int? {
        if let indexOfElement = index[element] { /// 通过字典找出对应下标
            return setByIndex(indexOfElement)    /// 如果存在 index[B] -> 1  parent[1] -> 1 如果此时BC 合并 [0,2,2] indexDict[B] 1  parent[1] = 2  for dict.value == 2 -> C
        } else {
            return nil
        }
    }
    public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
            return firstSet == secondSet
        } else {
            return false
        }
    }
    /// Union
    public mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
            if firstSet != secondSet {   ///              1 != 2
                for index in 0..<parent.count {     ///   A 合并到 B
                    if parent[index] == firstSet {  ///   parent[0] = 0
                        parent[index] = secondSet   ///   parent[0] = 1             parent[1, 1]
                    }                               ///                                    0  1
                }
                size[secondSet] += size[firstSet]   /// size[1] = 1 + 1 = 2
            }
        }
    }
}

// MARK: - VERSION 2
struct UnionFind<Element: Hashable> {
    var index = [Element: Int]()
    var next = [Int]()
    var size = [Int]()
}
extension UnionFind {
    mutating func initial(_ element: Element) {
        index[element] = next.count
        next.append(next.count)
        size.append(1)
    }
}
extension UnionFind {
    mutating func union(source: Element, destination: Element) {
        guard source != destination, let sourceIndex = index[source], let destinationIndex = index[destination] else { return }
        if size[sourceIndex] > size[destinationIndex] {
            next[sourceIndex] = next[destinationIndex]
            size[destinationIndex] += size[sourceIndex]
        } else {
            next[destinationIndex] = next[sourceIndex]
            size[sourceIndex] += size[destinationIndex]
        }
    }
    mutating func searchIndex(_ element: Element) -> Int? {
        guard let sourceIndex = index[element] else { return nil }
        func recurse(_ index: Int) -> Int {
            if next[index] == index { return index }
            next[index] = recurse(next[index])
            return next[index]
        }
        return recurse(sourceIndex)
    }
    mutating func hasSameIndex(_ lhs: Element, _ rhs: Element) -> Bool {
        return searchIndex(lhs) == searchIndex(rhs)
    }
}
var union = UnionFind<String>()
union.initial("a")
union.initial("b")
union.union(source: "a", destination: "b")
print(union.hasSameIndex("a", "b"))
