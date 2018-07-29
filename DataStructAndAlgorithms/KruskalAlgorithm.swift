/// Joseph Bernard Kruskal . 1956/US
/// Kruskal算法的核心思想就是先将每条边按着权值从小到大进行排序，然后从有序的集合中以此取出最小的边添加到最小生成树中，不过要保证新添加的边与最小生成树上的边不构成回路
// Undirected edge
public struct Edge<T>: CustomStringConvertible {
    public let vertex1: T
    public let vertex2: T
    public let weight: Int
    public var description: String {
        return "[\(vertex1)-\(vertex2), \(weight)]"
    }
}

// Undirected weighted graph
public struct Graph<T: Hashable>: CustomStringConvertible {
    public private(set) var edgeList: [Edge<T>]
    public private(set) var vertices: Set<T>
    public private(set) var adjList: [T: [(vertex: T, weight: Int)]]
    public init() {
        edgeList = [Edge<T>]()
        vertices = Set<T>()
        adjList = [T: [(vertex: T, weight: Int)]]()
    }
    public var description: String {
        var description = ""
        for edge in edgeList {
            description += edge.description + "\n"
        }
        return description
    }
    public mutating func addEdge(vertex1 v1: T, vertex2 v2: T, weight w: Int) {
        edgeList.append(Edge(vertex1: v1, vertex2: v2, weight: w))
        vertices.insert(v1)
        vertices.insert(v2)
        /// dict v1 为nil 的时候设置新值[]
        adjList[v1] = adjList[v1] ?? []
        adjList[v1]?.append((vertex: v2, weight: w))
        /// 
        adjList[v2] = adjList[v2] ?? []
        adjList[v2]?.append((vertex: v1, weight: w))
    }
    
    public mutating func addEdge(_ edge: Edge<T>) {
        addEdge(vertex1: edge.vertex1, vertex2: edge.vertex2, weight: edge.weight)
    }
}

public struct Heap<T> {
    /** The array that stores the heap's nodes. */
    var elements = [T]()
    
    /** Determines whether this is a max-heap (>) or min-heap (<). */
    fileprivate var isOrderedBefore: (T, T) -> Bool
    
    /**
     * Creates an empty heap.
     * The sort function determines whether this is a min-heap or max-heap.
     * For integers, > makes a max-heap, < makes a min-heap.
     */
    public init(sort: @escaping (T, T) -> Bool) {
        self.isOrderedBefore = sort
    }
    
    /**
     * Creates a heap from an array. The order of the array does not matter;
     * the elements are inserted into the heap in the order determined by the
     * sort function.
     */
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.isOrderedBefore = sort
        buildHeap(fromArray: array)
    }
    
    /*
     // This version has O(n log n) performance.
     private mutating func buildHeap(array: [T]) {
     elements.reserveCapacity(array.count)
     for value in array {
     insert(value)
     }
     }
     */
    
    /**
     * Converts an array to a max-heap or min-heap in a bottom-up manner.
     * Performance: This runs pretty much in O(n).
     */
    fileprivate mutating func buildHeap(fromArray array: [T]) {
        elements = array
        for i in stride(from: (elements.count/2 - 1), through: 0, by: -1) {
            shiftDown(i, heapSize: elements.count)
        }
    }
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var count: Int {
        return elements.count
    }
    
    /**
     * Returns the index of the parent of the element at index i.
     * The element at index 0 is the root of the tree and has no parent.
     */
    @inline(__always) func parentIndex(ofIndex i: Int) -> Int {
        return (i - 1) / 2
    }
    
    /**
     * Returns the index of the left child of the element at index i.
     * Note that this index can be greater than the heap size, in which case
     * there is no left child.
     */
    @inline(__always) func leftChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 1
    }
    
    /**
     * Returns the index of the right child of the element at index i.
     * Note that this index can be greater than the heap size, in which case
     * there is no right child.
     */
    @inline(__always) func rightChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 2
    }
    
    /**
     * Returns the maximum value in the heap (for a max-heap) or the minimum
     * value (for a min-heap).
     */
    public func peek() -> T? {
        return elements.first
    }
    
    /**
     * Adds a new value to the heap. This reorders the heap so that the max-heap
     * or min-heap property still holds. Performance: O(log n).
     */
    public mutating func insert(_ value: T) {
        elements.append(value)
        shiftUp(elements.count - 1)
    }
    
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }
    
    /**
     * Allows you to change an element. In a max-heap, the new element should be
     * larger than the old one; in a min-heap it should be smaller.
     */
    public mutating func replace(index i: Int, value: T) {
        guard i < elements.count else { return }
        
        assert(isOrderedBefore(value, elements[i]))
        elements[i] = value
        shiftUp(i)
    }
    
    /**
     * Removes the root node from the heap. For a max-heap, this is the maximum
     * value; for a min-heap it is the minimum value. Performance: O(log n).
     */
    @discardableResult public mutating func remove() -> T? {
        if elements.isEmpty {
            return nil
        } else if elements.count == 1 {
            return elements.removeLast()
        } else {
            // Use the last node to replace the first one, then fix the heap by
            // shifting this new first node into its proper position.
            let value = elements[0]
            elements[0] = elements.removeLast()
            shiftDown()
            return value
        }
    }
    
    /**
     * Removes an arbitrary node from the heap. Performance: O(log n). You need
     * to know the node's index, which may actually take O(n) steps to find.
     */
    public mutating func removeAt(_ index: Int) -> T? {
        guard index < elements.count else { return nil }
        
        let size = elements.count - 1
        if index != size {
            elements.swapAt(index,size)
            shiftDown(index, heapSize: size)
            shiftUp(index)
        }
        return elements.removeLast()
    }
    
    /**
     * Takes a child node and looks at its parents; if a parent is not larger
     * (max-heap) or not smaller (min-heap) than the child, we exchange them.
     */
    mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = elements[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && isOrderedBefore(child, elements[parentIndex]) {
            elements[childIndex] = elements[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        elements[childIndex] = child
    }
    
    mutating func shiftDown() {
        shiftDown(0, heapSize: elements.count)
    }
    
    /**
     * Looks at a parent node and makes sure it is still larger (max-heap) or
     * smaller (min-heap) than its childeren.
     */
    mutating func shiftDown(_ index: Int, heapSize: Int) {
        var parentIndex = index
        
        while true {
            let leftChildIndex = self.leftChildIndex(ofIndex: parentIndex)
            let rightChildIndex = leftChildIndex + 1
            
            // Figure out which comes first if we order them by the sort function:
            // the parent, the left child, or the right child. If the parent comes
            // first, we're done. If not, that element is out-of-place and we make
            // it "float down" the tree until the heap property is restored.
            var first = parentIndex
            if leftChildIndex < heapSize && isOrderedBefore(elements[leftChildIndex], elements[first]) {
                first = leftChildIndex
            }
            if rightChildIndex < heapSize && isOrderedBefore(elements[rightChildIndex], elements[first]) {
                first = rightChildIndex
            }
            if first == parentIndex { return }
            
            elements.swapAt(parentIndex,first)
            parentIndex = first
        }
    }
}

// MARK: - Searching

extension Heap where T: Equatable {
    /**
     * Searches the heap for the given element. Performance: O(n).
     */
    public func index(of element: T) -> Int? {
        return index(of: element, 0)
    }
    
    fileprivate func index(of element: T, _ i: Int) -> Int? {
        if i >= count { return nil }
        if isOrderedBefore(element, elements[i]) { return nil }
        if element == elements[i] { return i }
        if let j = index(of: element, self.leftChildIndex(ofIndex: i)) { return j }
        if let j = index(of: element, self.rightChildIndex(ofIndex: i)) { return j }
        return nil
    }
}


/**
 Union-Find Data Structure
 
 Performance:
 adding new set is almost O(1)
 finding set of element is almost O(1)
 union sets is almost O(1)
 */

public struct UnionFind<T: Hashable> {
    private var index = [T: Int]()
    private var parent = [Int]()
    private var size = [Int]()
    
    public init() {}
    
    public mutating func addSetWith(_ element: T) {
        index[element] = parent.count
        parent.append(parent.count)
        size.append(1)
    }
    
    private mutating func setByIndex(_ index: Int) -> Int {
        if parent[index] == index {
            return index
        } else {
            parent[index] = setByIndex(parent[index])
            return parent[index]
        }
    }
    
    public mutating func setOf(_ element: T) -> Int? {
        if let indexOfElement = index[element] {
            return setByIndex(indexOfElement)
        } else {
            return nil
        }
    }
    
    public mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
            if firstSet != secondSet {
                if size[firstSet] < size[secondSet] {
                    parent[firstSet] = secondSet
                    size[secondSet] += size[firstSet]
                } else {
                    parent[secondSet] = firstSet
                    size[firstSet] += size[secondSet]
                }
            }
        }
    }
    
    public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
            return firstSet == secondSet
        } else {
            return false
        }
    }
}



func minimumSpanningTreeKruskal<T>(graph: Graph<T>) -> (cost: Int, tree: Graph<T>) {
    var cost: Int = 0
    var tree = Graph<T>()
    let sortedEdgeListByWeight = graph.edgeList.sorted(by: { $0.weight < $1.weight })
    
    var unionFind = UnionFind<T>()
    for vertex in graph.vertices {
        unionFind.addSetWith(vertex)
    }
    
    for edge in sortedEdgeListByWeight {
        let v1 = edge.vertex1
        let v2 = edge.vertex2
        if !unionFind.inSameSet(v1, and: v2) {
            cost += edge.weight
            tree.addEdge(edge)
            unionFind.unionSetsContaining(v1, and: v2)
        }
    }
    
    return (cost: cost, tree: tree)
}








var graph = Graph<Int>()
graph.addEdge(vertex1: 1, vertex2: 2, weight: 6)
graph.addEdge(vertex1: 1, vertex2: 3, weight: 1)
graph.addEdge(vertex1: 1, vertex2: 4, weight: 5)
graph.addEdge(vertex1: 2, vertex2: 3, weight: 5)
graph.addEdge(vertex1: 2, vertex2: 5, weight: 3)
graph.addEdge(vertex1: 3, vertex2: 4, weight: 5)
graph.addEdge(vertex1: 3, vertex2: 5, weight: 6)
graph.addEdge(vertex1: 3, vertex2: 6, weight: 4)
graph.addEdge(vertex1: 4, vertex2: 6, weight: 2)
graph.addEdge(vertex1: 5, vertex2: 6, weight: 6)


print("===== Kruskal's =====")
let result1 = minimumSpanningTreeKruskal(graph: graph)
print("Minimum spanning tree total weight: \(result1.cost)")
print("Minimum spanning tree:")
print(result1.tree)

