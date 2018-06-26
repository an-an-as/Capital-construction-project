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
