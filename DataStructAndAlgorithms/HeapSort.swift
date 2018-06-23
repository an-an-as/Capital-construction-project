/**heapsort**
 Robert W．Floyd & J．Williams US/1964 O(nlogn)
 
 ## 堆是具有以下性质的完全二叉树：
 + 每个结点的值都大于或等于其左右孩子结点的值，称为大顶堆；
 + 每个结点的值都小于或等于其左右孩子结点的值，称为小顶堆。
 
 ## 基本思想及步骤
 + 将无需序列构建成一个堆，根据升序降序需求选择大顶堆或小顶堆;
 + 将堆顶元素与末尾元素交换，将最大元素"沉"到数组末端;
 + 重新调整结构，使其满足堆定义，然后继续交换堆顶元素与当前末尾元素，反复执行调整+交换步骤，直到整个序列有序
 
 ````
           4            0               arr [4,6,8,5,9]        for i in stride(from: (nodes.count/2-1), through: 0, by: -1){}  确定最后非叶子结点
         /   \         / \                   0 1 2 3 4         log(N,2)+1算出层次 倒数第二层是2^(N-1)-1，最后一个的编号是2^(N-1)-1-1
       >6<    8       1   2
       / \           / \
      5   9         3   4
 
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

//version1
import Foundation
public struct Heap<T> {
    var nodes = [T]()
    private var orderCriteria: (T, T) -> Bool
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
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
    /// 父节点下标
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
     */
    @discardableResult public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil }
        let size = nodes.count - 1
        if index != size {
            nodes.swapAt(index, size)
            shiftDown(from: index, until: size)
            shiftUp(index)
        }
        return nodes.removeLast()
    }
    internal mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
            nodes[childIndex] = nodes[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
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
        }
        if first == index { return }             /// 判断条件未触发不需要调整则返回
        nodes.swapAt(index, first)               /// 通过下标交换值
        shiftDown(from: first, until: endIndex)  /// 递归处理左分支的比较
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





//version2
func heapSort(_ arr: inout[Int]) -> [Int] {
    func buildheap(_ arr: inout[Int]) {
        let length = arr.count
        let heapsize = length
        var nonleaf = length / 2 - 1
        while nonleaf >=  0 {
            heapify(&arr, i: nonleaf, heapsize: heapsize)
            nonleaf -= 1
        }
    }
    func heapify(_ arr:inout [Int], i : Int, heapsize: Int){
        var smallest = i
        let left = 2*i+1
        let right = 2*i+2
        if(left < heapsize){
            if(arr[i]>arr[left]){
                smallest = left
            }
            else {
                smallest = i
            }
        }
        if(right < heapsize){
            if(arr[smallest] > arr[right]){
                smallest = right
            }
        }
        if(smallest != i){
            var temp: Int
            temp = arr[i]
            arr[i] = arr[smallest]
            arr[smallest] = temp
            heapify(&arr,i: smallest,heapsize: heapsize)
        }
    }
    func internalHeapSort(_ arr: inout[Int]) {
        var heapsize = arr.count
        buildheap(&arr)
        (0 ..< arr.count).forEach { _ in
            var temp: Int
            temp = arr[0]
            arr[0] = arr[heapsize - 1]
            arr[heapsize - 1] = temp
            heapsize = heapsize - 1
            heapify(&arr, i: 0, heapsize: heapsize)
        }
    }
    internalHeapSort(&arr)
    return arr
}
var array = [4,5,8,6,9,2,66,9,3,7,22,77,55,11,33]
heapSort(&array)
