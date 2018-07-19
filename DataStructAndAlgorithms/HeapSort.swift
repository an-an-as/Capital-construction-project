/**heapsort**
 Robert W．Floyd & J．Williams US/1964 O(nlogn)
 
 ## Complete Binary Tree
 + 堆是一种完全二叉树或者近似完全二叉树
 + 若设二叉树的深度为h，除第 h 层外，其它各层 (1～h-1) 的结点数都达到最大个数，第 h 层所有的结点都连续集中在最左边，这就是完全二叉树
 
 ## 相关性质
 + 在二叉树的第i层上至多有2^(i-1)（i >= 1）个节点。
 + 深度为k的二叉树至多有2^k-1（k>=1）个节点。
    * 由特性1易知每层最多有多少个节点，那么深度为k的话，说明一共有k层
    * 那么共有节点数为：2^0 + 2^1 + 2^2 + 2^(k-1) = 2^k - 1
 
 ## 堆是具有以下性质的完全二叉树：
 + 每个结点的值都大于或等于其左右孩子结点的值，称为大顶堆；
 + 每个结点的值都小于或等于其左右孩子结点的值，称为小顶堆。
 
 ## 基本思想及步骤
 + 将无序序列构建成一个堆，根据升序降序需求选择大顶堆或小顶堆;
 + 将堆顶元素与末尾元素交换，将最大元素"沉"到数组末端;
 + 重新调整结构，使其满足堆定义，然后继续交换堆顶元素与当前末尾元素，反复执行调整+交换步骤，直到整个序列有序
 
 ````
           4            0               arr [4,6,8,5,9]        for i in stride(from: (nodes.count/2-1), through: 0, by: -1){}  确定最后非叶子结点
         /   \         / \                   0 1 2 3 4         如果下标从1开始存储，则编号为i的结点的主要关系为： 父i/2         左2i  右2i+1
       >6<    8       1   2                                    如果下标从0开始存储，则编号为i的结点的主要关系为： (i - 1) / 2   2i+1  2i+2     [(i-1)-1/2] = i/2 -1
       / \           / \
      5   9         3   4                                      假设设完全二叉树中第i个结点的位置为第k层第M个结点，
                                                               根据二叉树的特性，满二叉树的第K层共有2^K-1个节点
                                                               则父节点为全二叉树的第t=2^(K-2)-1+M个节点。子节点为全二叉树的第i=2^(K-1)-1+2M。即父结点编号为t=(i-1)/2=i/2。
                                                               若 2层 父节点t =  m    子节点i = 1 + 2m
 ````
 ## 从最后一个非叶子结点开始,从下至上,从左至右,进行调整 9 - 6
 
 ````
 
        4                                   9                                       9
      /   \                                / \                                     / \
     9     8            ---->             4   8                 ---->             6   8
    / \                                  / \                                     / \
   5   6                                5   6                                   5   4
   arr [4,9,8,5,6]                      arr [9,4,8,5,6]                         arr[9,6,8,5,4]
 
 ````
 
 ## 将堆顶元素与末尾元素进行交换，使末尾元素最大
 
 ````
        4                                   8                               5
       / \                                 / \                             / \
      6   8             ----->            6   4             ---->         6   4
     /                  重新调整          /                  首位交换      [8][9]
    5  [9]                              5  [9]
    arr[4,6,8,5,|9]                     arr[8,6,4,5,|9]
 
    -> arr[4,5,6,8,9]
 
 ````
 
 [0]
 [1]          [2]
 [3]   [4]    [5]     [6]
 [7][8][9][10][11][12][13][14]
 [0] [1][2] [3][4][5][6] [7][8][9][10][11][12][13][14]
 4   5  8   6  9  2  66  9  3  7  22  77  55  11  33
 *buildHeap:
 count:15
 nonLeaf = count/2-1 = 6
 nonLeaf -= 1
 
 *heapfy:
 smalest = [6]
 left = 2 * 6 + 1 = [13]
 left = 2 * 6 + 2 = [14]
 if array[nonleaf] > array[left]  -> smalest = left  (left  < count)  smalest = [13]
 if array[smalest] > array[right] -> smalest = right (right < count)
 if smalest != nonLeaf
 swap: temp = array[nonLeaf] array[nonLeaf] = array[smalest] array[smlest] = arrat[nonLeaf]
 *recursion heapfy
 
 *internalHeapSort
 bulidHeap
 (0..<array.count)forEach
 swap and heapify */

public struct Heap<T> {
    var nodes = [T]()
    private var orderCriteria : (T, T) -> Bool
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sor
    }
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
    }
    private mutating func configureHeap(from array: [T]) {
        nodes = array
        for i in stride(from: (nodes.count/2-1), through: 0, by: -1) {
            shiftDown(i)
        }
    }
    @inline(__always) internal func parentIndex(ofIndex i: Int) -> Int {
        return (i - 1) / 2
    }
    @inline(__always) internal func leftChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 1
    }
    @inline(__always) internal func rightChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 2
    }
    /**
     * Adds a new value to the heap. This reorders the heap so that the max-heap
     * or min-heap property still holds. Performance: O(log n).
     */
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    /**
     * Adds a sequence of values to the heap. This reorders the heap so that
     * the max-heap or min-heap property still holds. Performance: O(log n).
     */
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }
    /**
     * Allows you to change an element. This reorders the heap so that
     * the max-heap or min-heap property still holds.
     */
    public mutating func replace(index i: Int, value: T) {
        guard i < nodes.count else { return }
        remove(at: i)
        insert(value)
    }
    /**
     * Removes the root node from the heap. For a max-heap, this is the maximum
     * value; for a min-heap it is the minimum value. Performance: O(log n).
     * 根节点的等于末尾的值 删除末尾 替代跟节点的值
     */
    @discardableResult public mutating func remove() -> T? {
        guard !nodes.isEmpty else { return nil }
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            // Use the last node to replace the first one, then fix the heap by
            // shifting this new first node into its proper position.
            let value = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(0)
            return value
        }
    }
    /**
     * Removes an arbitrary node from the heap. Performance: O(log n).
     * Note that you need to know the node's index.
     * 和最后的值交换 重新排序上下节点 删除最后 p
     */
    @discardableResult public mutating func remove(at index: Int) -> T? {       ///      7                          7
        guard index < nodes.count else { return nil }                           ///    6    5    -->               0 5            shitDown from index 1 由上往下调整
        let size = nodes.count - 1                                              ///  4  3  2  1                  4 3  2 1         shiftUp(index)        由下往上调整
        if index != size {                                                      /// 0                           6
            nodes.swapAt(index, size)                                           /// remove 6
            shiftDown(from: index, until: size)
            shiftUp(index)
        }
        return nodes.removeLast()
    }
    internal mutating func shiftUp(_ index: Int) { /// nodes.count - 1
        var childIndex = index
        let child = nodes[childIndex] /// nodes.append(value) index: count - 1
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {   ///        3                  3            index = 1              3              4
            nodes[childIndex] = nodes[parentIndex]                           ///      2   1       -->    2    1                        -->   3   1     -->  3   1
            childIndex = parentIndex                                         ///    4                  2                                   2              2
            parentIndex = self.parentIndex(ofIndex: childIndex)              ///    childIndex = 3     childIndex = 1   childIndex -> parent    2 < 3 childIndex = 0 break
        }/// 插入的值和各个父节点进行比较
        nodes[childIndex] = child
    }
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {                    ///     4                 first = index = 1
        let leftChildIndex = self.leftChildIndex(ofIndex: index)                                ///   6    8     9>6      first = 3
        let rightChildIndex = leftChildIndex + 1                                                /// 10  9                 first = 4
        var first = index                                                                       /// index = 4 first = 1,  node.swap(index,first)
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
            first = rightChildIndex
        }                                        /// 通过两个判断找出子节点内最大值
        if first == index { return }             /// 判断条件未触发不需要调整则返回
        nodes.swapAt(index, first)               /// 通过下标交换值
        shiftDown(from: first, until: endIndex)  /// 递归处理子节点
    }
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
}
// MARK: - Searching
extension Heap where T: Equatable {
    /** Get the index of a node in the heap. Performance: O(n). */
    public func index(of node: T) -> Int? {
        return nodes.index(where: { $0 == node })
    }
    /** Removes the first occurrence of a node from the heap. Performance: O(n log n). */
    @discardableResult public mutating func remove(node: T) -> T? {
        if let index = index(of: node) {
            return remove(at: index)
        }
        return nil
    }
}
extension Heap {
    public mutating func sort() -> [T] {
        for i in stride(from: (nodes.count - 1), through: 1, by: -1) {
            ///头尾交换后再次进行完全二叉树的配置
            nodes.swapAt(0, i)
            shiftDown(from: 0, until: i)
        }
        return nodes
    }
}
/*
 Sorts an array using a heap.
 Heapsort can be performed in-place, but it is not a stable sort.
 */
public func heapsort<T>(_ a: [T], _ sort: @escaping (T, T) -> Bool) -> [T] {
    let reverseOrder = { i1, i2 in sort(i2, i1) }
    var h = Heap(array: a, sort: reverseOrder)
    return h.sort()
}

var h1 = Heap(array: [5, 13, 2, 25, 7, 17, 20, 8, 4], sort: >)
let a1 = h1.sort()
print(a1)
///[2, 4, 5, 7, 8, 13, 17, 20, 25]
