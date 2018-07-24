/**
 ## Order of the nodes.
 + In a binary search tree (BST), the left child must be smaller than its parent, and the right child must be greater
 + This is not true for a heap. In a max-heap both children must be smaller than the parent, while in a min-heap they both must be greater.
 
 ## Memory.
 + Traditional trees take up more memory than just the data they store.
 + You need to allocate additional storage for the node objects and pointers to the left/right child nodes.
 + A heap only uses a plain array for storage and uses no pointers.
 
 ## Balancing
 + AVL tree or red-black tree,在插入节点和需要重新平衡节点而Heap基于完全二叉树的性质并不需要调整
 + heaps we don't actually need the entire tree to be sorted. We just want the heap property to be fulfilled, so balancing isn't an issue.
 + Because of the way the heap is structured, heaps can guarantee O(log n) performance.
 
 ## Searching
 + Heap的主要特性是根节点为最大最小值,并且拥有O(long n)的插入和删除的特性,搜索不是它的主要任务
 + Whereas searching is fast in a binary tree, it is slow in a heap.
 
 
 
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
      4           0               arr [4,6,8,5,9]        for i in stride(from: (nodes.count/2-1), through: 0, by: -1){}  确定最后非叶子结点
    /   \        / \                   0 1 2 3 4         如果下标从1开始存储，则编号为i的结点的主要关系为： 父i/2         左2i  右2i+1
  >6<    8      1   2                                    如果下标从0开始存储，则编号为i的结点的主要关系为： (i - 1) / 2   2i+1  2i+2     [(i-1)-1/2] = i/2 -1
  / \          / \
 5   9        3   4                                      假设设完全二叉树中第i个结点的位置为第k层第M个结点，
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
 /                  重新调整           /                  首位交换      [8][9]
 5  [9]                              5  [9]
 arr[4,6,8,5,|9]                     arr[8,6,4,5,|9]    -> arr[4,5,6,8,9]
 
 
 ````
 */
import Foundation
public struct Heap<T: Equatable> {
    var nodes = [T]()
    private var orderCriteria: (T, T) -> Bool
    public init(sort: @escaping (T, T) -> Bool) {
        orderCriteria = sort
    }
    public init(_ array: [T], sort: @escaping (T, T) -> Bool) {
        orderCriteria = sort
        configureHeap(form: array)
    }
}
extension Heap {
    @inline(__always) private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    @inline(__always) private func leftChildrenIndex(of index: Int) -> Int {
        return index * 2 + 1
    }
    @inline(__always) private func rightChildrenIndex(of index: Int) -> Int {
        return index * 2 + 2
    }
}
extension Heap {
    private mutating func configureHeap(form array: [T]) {
        nodes = array
        for currentIndex in stride(from: nodes.count/2 - 1, through: 0, by: -1) {
            shiftDown(from: currentIndex)
        }
    }
    private mutating func shiftDown(from index: Int, to endIndex: Int) {
        var cursorIndex = index
        let childIndexL = leftChildrenIndex(of: index)
        let childIndexR = rightChildrenIndex(of: index)
        if childIndexL < endIndex && orderCriteria(nodes[childIndexL], nodes[cursorIndex]) {
            cursorIndex = childIndexL
        }
        if childIndexR < endIndex && orderCriteria(nodes[childIndexR], nodes[cursorIndex]) {
            cursorIndex = childIndexR
        }
        if cursorIndex == index { return }
        nodes.swapAt(index, cursorIndex)
        shiftDown(from: cursorIndex, to: endIndex)
    }
    private mutating func shiftDown(from index: Int) {
        shiftDown(from: index, to: nodes.count)
    }
    private mutating func shiftUp(from index: Int) {
        var cursorIndex = index
        var cursorParentIndex = parentIndex(of: cursorIndex)
        let candicateValue = nodes[index]
        while cursorIndex > 0 && orderCriteria(candicateValue, nodes[cursorParentIndex]) {
            nodes[cursorIndex] = nodes[cursorParentIndex]
            cursorIndex = cursorParentIndex
            cursorParentIndex = parentIndex(of: cursorIndex)
        }
    }
}
extension Heap {
    public mutating func index(of node: T) -> Int? {
        return nodes.index(where: { $0 == node })
    }
    public mutating func replace(at index: Int, newValue: T) {
        guard index >= 0 && index < nodes.count else { return }
        remove(at: index)
        insert(newValue)
    }
    public subscript(pos: Int) -> T {
        get {
            return nodes[pos]
        }
        set {
            replace(at: pos, newValue: newValue)
        }
    }
}
extension Heap {
    public mutating func insert(_ newElement: T) {
        nodes.append(newElement)
        shiftUp(from: nodes.count - 1)
    }
    public mutating func insert<S: Sequence> (_ newElement: S) where S.Iterator.Element == T {
        newElement.forEach { insert($0) }
    }
}
extension Heap {
    @discardableResult
    public mutating func remove(at index: Int) -> T? {
        guard index >= 0 && index < nodes.count else { return nil }
        let lastIndex = nodes.count - 1
        if index != lastIndex {
            nodes.swapAt(index, lastIndex)
            shiftDown(from: index, to: lastIndex)
            shiftUp(from: index)
        }
        return nodes.removeLast()
    }
    public mutating func remove(_ element: T) -> T? {
        guard let index = index(of: element) else { return nil }
        return remove(at: index)
    }
    @discardableResult
    public mutating func removeFirst() -> T? {
        guard !nodes.isEmpty else { return nil }
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            let first = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(from: 0)
            return first
        }
    }
}
extension Heap {
    public mutating func sort() -> [T] {
        for index in stride(from: nodes.count - 1, through: 1, by: -1) {
            nodes.swapAt(0, index)
            shiftDown(from: 0, to: index)
        }
        return nodes
    }
}
var arr = [Int]()
(1...10).forEach { _ in
    let num = Int(arc4random_uniform(1_000))
    arr.append(num)
}
var heap = Heap(arr, sort: <)
