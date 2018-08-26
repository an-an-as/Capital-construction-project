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
 arr[4,6,8,5,|9]                     arr[8,6,4,5,|9]                 -> arr[4,5,6,8,9]
 
 ````
 */
public struct Heap<T> {
    private var nodes = [T]()
    var criteria: (T, T) -> Bool
    init(sort: @escaping (T, T) -> Bool) {
        criteria = sort
    }
}
extension Heap {
    @inline(__always) private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
}
extension Heap {
    private mutating func shiftDown(from index: Int, to endIndex: Int) {
        var currentIndex = index
        let leftChildrenIndex = index * 2 + 1
        let rightChildrenIndex = leftChildrenIndex + 1
        if leftChildrenIndex < endIndex && criteria(nodes[leftChildrenIndex], nodes[currentIndex]) {
            currentIndex = leftChildrenIndex
        }
        if rightChildrenIndex < endIndex && criteria(nodes[rightChildrenIndex], nodes[currentIndex]) {
            currentIndex = rightChildrenIndex
        }
        if currentIndex == index { return }
        nodes.swapAt(currentIndex, index)
        shiftDown(from: currentIndex, to: endIndex)
    }
}
extension Heap {
    private mutating func shiftUp(from index: Int) {
        var currentIndex = index
        var parentIndex = self.parentIndex(of: currentIndex)
        let value = nodes[index]
        while currentIndex > 0 && criteria(value, nodes[parentIndex]) {
            nodes[currentIndex] = nodes[parentIndex]
            currentIndex = parentIndex
            parentIndex = self.parentIndex(of: currentIndex)
        }
        nodes[currentIndex] = value
    }
}
extension Heap {
    public mutating func insert(_ newElement: T) {
        nodes.append(newElement)
        shiftUp(from: nodes.count - 1)
    }
}
extension Heap {
    public mutating func removeFirst() -> T? {
        if nodes.count == 1 {
            return nodes.popLast()
        } else {
            let first = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(from: 0, to: nodes.count)
            return first
        }
    }
    @discardableResult
    public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil }
        let lastIndex = nodes.count - 1
        if index != lastIndex {
            nodes.swapAt(index, lastIndex)
            shiftUp(from: index)
            shiftDown(from: index, to: lastIndex)
        }
        return nodes.removeLast()
    }
}
extension Heap {
    public mutating func replace(newElement: T, at index: Int) {
        guard index < nodes.count else { return }
        remove(at: index)
        insert(newElement)
    }
}
extension Heap where T: Equatable {
    public mutating func index(of element: T) -> Int? {
        return nodes.index(where: { $0 == element })
    }
}
public struct PriorityQueue<T: Equatable> {
    private var heap: Heap<T>
    public init(sort: @escaping(T, T) -> Bool) {
        heap = Heap(sort: sort)
    }
    public mutating func enqueue(_ newElement: T) {
        heap.insert(newElement)
    }
    public mutating func dequeue() -> T? {
        return heap.removeFirst()
    }
}

struct Message {
    var message: String
    var priority: Int
}
extension Message: Comparable {
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.priority < rhs.priority
    }
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.priority == rhs.priority
    }
}
var priorityQueue = PriorityQueue<Message>(sort: >)
priorityQueue.enqueue(Message(message: "Hello", priority: 0))
priorityQueue.enqueue(Message(message: "World", priority: 1_000))
priorityQueue.enqueue(Message(message: "!", priority: 500))
print(priorityQueue.dequeue()?.message) //Optional("World")
