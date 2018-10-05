public struct Edge<T>: CustomStringConvertible {
    public let vertex1: T
    public let vertex2: T
    public let weight: Int
    public var description: String {
        return "[\(vertex1)-\(vertex2), \(weight)]"
    }
}
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
        adjList[v1] = adjList[v1] ?? []
        adjList[v1]?.append((vertex: v2, weight: w))
        adjList[v2] = adjList[v2] ?? []
        adjList[v2]?.append((vertex: v1, weight: w))
    }
    public mutating func addEdge(_ edge: Edge<T>) {
        addEdge(vertex1: edge.vertex1, vertex2: edge.vertex2, weight: edge.weight)
    }
}

/*
 Priority Queue, a queue where the most "important" items are at the front of the queue.
 The heap is a natural data structure for a priority queue, so this object simply wraps the Heap struct.
 All operations are O(lg n).
 Just like a heap can be a max-heap or min-heap, the queue can be a max-priority
 queue (largest element first) or a min-priority queue (smallest element first).
 */
public struct PriorityQueue<T> {
    fileprivate var heap: Heap<T>
    
    /*
     To create a max-priority queue, supply a > sort function. For a min-priority
     queue, use <.
     */
    public init(sort: @escaping (T, T) -> Bool) {
        heap = Heap(sort: sort)
    }
    
    public var isEmpty: Bool {
        return heap.isEmpty
    }
    
    public var count: Int {
        return heap.count
    }
    
    public func peek() -> T? {
        return heap.peek()
    }
    
    public mutating func enqueue(_ element: T) {
        heap.insert(element)
    }
    
    public mutating func dequeue() -> T? {
        return heap.remove()
    }
    
    /*
     Allows you to change the priority of an element. In a max-priority queue,
     the new priority should be larger than the old one; in a min-priority queue
     it should be smaller.
     */
    public mutating func changePriority(index i: Int, value: T) {
        return heap.replace(index: i, value: value)
    }
}

extension PriorityQueue where T: Equatable {
    public func index(of element: T) -> Int? {
        return heap.index(of: element)
    }
}



func minimumSpanningTreePrim<T>(graph: Graph<T>) -> (cost: Int, tree: Graph<T>) {
    var cost: Int = 0
    var tree = Graph<T>()
    
    guard let start = graph.vertices.first else {
        return (cost: cost, tree: tree)
    }
    
    var visited = Set<T>()
    var priorityQueue = PriorityQueue<(vertex: T, weight: Int, parent: T?)>(
        sort: { $0.weight < $1.weight })
    
    priorityQueue.enqueue((vertex: start, weight: 0, parent: nil))
    while let head = priorityQueue.dequeue() {
        let vertex = head.vertex
        if visited.contains(vertex) {
            continue
        }
        visited.insert(vertex)
        
        cost += head.weight
        if let prev = head.parent {
            tree.addEdge(vertex1: prev, vertex2: vertex, weight: head.weight)
        }
        
        if let neighbours = graph.adjList[vertex] {
            for neighbour in neighbours {
                let nextVertex = neighbour.vertex
                if !visited.contains(nextVertex) {
                    priorityQueue.enqueue((vertex: nextVertex, weight: neighbour.weight, parent: vertex))
                }
            }
        }
    }
    
    return (cost: cost, tree: tree)
}

print("===== Prim's =====")
let result2 = minimumSpanningTreePrim(graph: graph)
print("Minimum spanning tree total weight: \(result2.cost)")
print("Minimum spanning tree:")
print(result2.tree)

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
