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
public struct PriorityQueue<T> {
    fileprivate var heap: Heap<T>
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

///-Version: 2
enum Directable {
    case directed
    case unDirected
}
struct AdjacencyLinkedList<Vertex: Hashable, Weight: Comparable> {
    typealias Edge = (Vertex, Vertex, Weight)
    var edges = [Edge]()
    var vertives = Set<Vertex>()
    var list = [Vertex: [(Vertex, Weight)]]()
}
extension AdjacencyLinkedList {
    mutating func addEdge(_ source: Vertex, destination: Vertex, weight: Weight, directable: Directable = .directed ) {
        vertives.insert(source)
        vertives.insert(destination)
        edges.append(Edge(source, destination, weight))
        list[source] = list[source] ?? []
        list[source]?.append((destination, weight))
        switch directable {
        case .directed: return
        case .unDirected:
            list[destination] = list[destination] ?? []
            list[destination]?.append((source, weight))
            edges.append((destination, source, weight))
        }
    }
}
extension AdjacencyLinkedList: CustomDebugStringConvertible {
    var debugDescription: String {
        var literal = ""
        edges.forEach {
            literal += "\($0.0)-\($0.1): \($0.2)\n"
        }
        return literal
    }
}
struct PriorityQueue<Element> {
    private var nodes = [Element]()
    var priority: (Element, Element) -> Bool
    init(priority: @escaping(Element, Element) -> Bool) {
        self.priority = priority
    }
}
extension PriorityQueue {
    private mutating func shiftDown(_ parentIndex: Int, endIndex: Int) {
        let childrenIndexL = parentIndex * 2 + 1
        let childrenIndexR = childrenIndexL + 1
        var currentIndex = parentIndex
        if childrenIndexL < endIndex && priority(nodes[childrenIndexL], nodes[currentIndex]) {
            currentIndex = childrenIndexL
        }
        if childrenIndexR < endIndex && priority(nodes[childrenIndexR], nodes[currentIndex]) {
            currentIndex = childrenIndexR
        }
        guard currentIndex != parentIndex else { return }
        nodes.swapAt(currentIndex, parentIndex)
        shiftDown(currentIndex, endIndex: endIndex)
    }
    private mutating func shitUp(_ index: Int) {
        var currentIndex = index
        var parentIndex = (index - 1) / 2
        while currentIndex > 0 && priority(nodes[currentIndex], nodes[parentIndex]) {
            nodes[currentIndex] = nodes[parentIndex]
            currentIndex = parentIndex
            parentIndex = (index - 1) / 2
        }
        return nodes[currentIndex] = nodes[index]
    }
}
extension PriorityQueue {
    mutating func enqueue(_ newElement: Element) {
        nodes.append(newElement)
        shitUp(nodes.count - 1)
    }
    mutating func dequeue() -> Element? {
        guard !nodes.isEmpty else { return nil }
        if nodes.count == 1 {
            return nodes.popLast()
        } else {
            let first = nodes.first
            nodes[0] = nodes.removeLast()
            shiftDown(0, endIndex: nodes.count)
            return first
        }
    }
}
func minimunSpanTree(_ graph: AdjacencyLinkedList<String, Int>) -> (cost: Int, tree: AdjacencyLinkedList<String, Int>) {
    var cost = 0
    var tree = AdjacencyLinkedList<String, Int>()
    var visted = Set<String>()
    var queue = PriorityQueue<(parent: String?, vertex: String, weight: Int)>(priority: { $0.2 < $1.2 })
    guard let start = graph.vertives.sorted().first else { return (cost, tree) }
    queue.enqueue((nil, start, 0))
    while let head = queue.dequeue() {
        guard !visted.contains(head.vertex) else { continue }
        visted.insert(head.vertex)
        cost += head.weight
        head.parent.map { tree.addEdge($0, destination: head.vertex, weight: head.weight) }
        for edge in graph.edges.filter({ $0.0 == head.vertex }) where !visted.contains(edge.1) {
            queue.enqueue((edge.0, edge.1, edge.2))
        }
    }
    return (cost, tree)
}
var list = AdjacencyLinkedList<String, Int>()
list.addEdge("a", destination: "c", weight: 1)
list.addEdge("a", destination: "b", weight: 2)
list.addEdge("c", destination: "d", weight: 3)
list.addEdge("b", destination: "d", weight: 4)
print(list)
print(minimunSpanTree(list).tree)
///         1
///      a --- c
///   2  |     |  3
///      b  .  d
///         4
///
