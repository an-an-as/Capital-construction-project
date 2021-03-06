public class Edge: Equatable {
    public var anotherNode: Node
    public init(_ anotherNode: Node) {
        self.anotherNode = anotherNode
    }
}
public func == (_ lhs: Edge, rhs: Edge) -> Bool {
    return lhs.anotherNode == rhs.anotherNode
}
public class Node: CustomStringConvertible, Equatable {
    public var adjacentEdges: [Edge]                  ///       Node:lable     visited
    public private(set) var label: String             ///       /   |   \      adjacentEdges[edges]
    public var distance: Int?                         ///     Node Node Node   anotherNode:Node
    public var visited: Bool                          ///      |    |
    public init(_ label: String) {
        self.label = label
        adjacentEdges = []
        visited = false
    }
    public var description: String {
        if let distance = distance {
            return "Node(label: \(label), distance: \(distance))"
        }
        return "Node(label: \(label), distance: infinity)"
    }
    public var hasDistance: Bool {
        return distance != nil
    }
    public func remove(_ edge: Edge) {
        adjacentEdges.remove(at: adjacentEdges.index { $0 === edge }!)
    }
}
public func == (_ lhs: Node, rhs: Node) -> Bool {
    return lhs.label == rhs.label && lhs.adjacentEdges == rhs.adjacentEdges
}

// Graph
public class Graph: CustomStringConvertible, Equatable {///    Graph  >>>nodes  addNode  addEdge  findNodeWithLable  duplicate<<<
    public private(set) var nodes: [Node]               ///
    public init() {                                     ///    Node:lable               Node             nodes:[Node]           nodes.append Node
        self.nodes = []                                 ///      /   |   \            /   |   \          Node.neighbors[Edge]
    }                                                   ///    Node Node Node      Node Node  Node1      neighbor:Node
    public func addNode(_ label: String) -> Node {      ///     |    |    |          |    |    |         sourceNode:Node1       Edge(Node2)
        let node = Node(label)                          ///                                   Node2      Node1.neighbors.append Node2(edge.neighbor)
        nodes.append(node)
        return node
    }
    public func addEdge(_ source: Node, anotherNode: Node) {
        let edge = Edge(anotherNode)
        source.adjacentEdges.append(edge)
    }
    public var description: String {
        var description = ""
        for node in nodes {
            if !node.adjacentEdges.isEmpty {
                description += "[node: \(node.label) edges: \(node.adjacentEdges.map { $0.anotherNode.label})]"
            }
        }
        return description
    }
    public func findNodeWithLabel(_ label: String) -> Node {
        return nodes.filter { $0.label == label }.first!
    }
    public func duplicate() -> Graph {
        let duplicated = Graph()
        for node in nodes {
            _ = duplicated.addNode(node.label)
        }                                                                                   /// newGraph addNode <--- for in nodes[Node]
        for node in nodes {                                                                 /// newGraoth.nodes[Nodes1 Nodes Nodes]     fliter condition:
            for edge in node.adjacentEdges {                                                ///                   |     |     |         new nodeLable == oldNodeLable
                let source = duplicated.findNodeWithLabel(node.label)                       ///                  Node
                let neighbour = duplicated.findNodeWithLabel(edge.anotherNode.label)        /// createEdge sourceNode.append edge
                duplicated.addEdge(source, anotherNode: neighbour)
            }
        }
        return duplicated
    }
}
public func == (_ lhs: Graph, rhs: Graph) -> Bool {
    return lhs.nodes == rhs.nodes
}
// MARK: - Version: 2
indirect enum Node<T> {
    case sourceNode(T, [Node], Int?, Bool)
    init(description: T, nodes: [Node<T>] = [], distance: Int? = nil, visted: Bool = false) {
        self = .sourceNode(description, nodes, distance, visted)
    }
}
extension Node {
    var details: (description: T, adjacentNodes: [Node], distace: Int?, visted: Bool) {
        switch self {
        case let .sourceNode(description, nodes, distace, visted):
            return (description, nodes, distace, visted)
        }
    }
}
extension Node {
    mutating func addAdjacentNode(_ another: Node<T>) {
        var nodes = details.adjacentNodes
        nodes.append(another)
        self = Node(description: details.description, nodes: nodes, distance: details.distace, visted: details.visted)
    }
}
extension Node: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(details.description)"
    }
}
struct Graph<T> {
    private(set) var nodes: [Node<T>]
}
extension Graph {
    mutating func append(_ newElement: Node<T>...) {
        newElement.forEach {
            nodes.append($0)
        }
    }
}
extension Graph: CustomDebugStringConvertible {
    var debugDescription: String {
        var description = ""
        nodes.forEach {
            description += "\($0.details.description): \($0.details.adjacentNodes.map { $0.details.description })\n"
        }
        return description
    }
}
var graph = Graph<String>.init(nodes: [])
var nodeA = Node(description: "a")
var nodeB = Node(description: "b")
var nodeC = Node(description: "c")
nodeA.addAdjacentNode(nodeB)
nodeA.addAdjacentNode(nodeC)
graph.append(nodeA, nodeB, nodeC)
print(graph)
// MARK: - Version: 3
// MARK: - 并查集
struct UnionFind<Element: Hashable> {
    var index = [Element: Int]()
    var parentIndex = [Int]()
    var size = [Int]()
}
extension UnionFind {
    mutating func initial(_ newElement: Element) {
        index[newElement] = parentIndex.count
        parentIndex.append(parentIndex.count)
        size.append(1)
    }
}
extension UnionFind {
    mutating func getParentIndex(_ source: Element) -> Int? {
        guard let index = index[source] else { return nil }
        func fetchFinalIndex(_ index: Int) -> Int {
            if parentIndex[index] == index { return index }
            parentIndex[index] = fetchFinalIndex(parentIndex[index])
            return parentIndex[index]
        }
        return fetchFinalIndex(index)
    }
    mutating func union(_ source: Element, destination: Element) {
        guard source != destination,
            let sourceIndex = index[source], let destinaionIndex = index[destination] else { return }
        if size[sourceIndex] > size[destinaionIndex] {
            parentIndex[sourceIndex] = destinaionIndex
            size[destinaionIndex] += size[sourceIndex]
        } else {
            parentIndex[destinaionIndex] = sourceIndex
            size[sourceIndex] += size[destinaionIndex]
        }
    }
    mutating func hasSameIndex(_ lhs: Element, _ rhs: Element) -> Bool {
        return getParentIndex(lhs) == getParentIndex(rhs)
    }
}
// MARK: - 优先队列
struct PriorityQueue<Element> {
    var storage = [Element]()
    var priority: (Element, Element) -> Bool
    init(priority: @escaping (Element, Element) -> Bool) {
        self.priority = priority
    }
}
extension PriorityQueue {
    mutating func shiftDown(from parentIndex: Int, endIndex: Int) {
        var currentIndex = parentIndex
        let childrenIndexL = parentIndex * 2 + 1
        let childrenIndexR = childrenIndexL + 1
        if childrenIndexL < endIndex && priority(storage[childrenIndexL], storage[currentIndex]) {
            currentIndex = childrenIndexL
        }
        if childrenIndexR < endIndex && priority(storage[childrenIndexR], storage[currentIndex]) {
            currentIndex = childrenIndexR
        }
        guard currentIndex != parentIndex else { return }
        storage.swapAt(currentIndex, parentIndex)
        shiftDown(from: currentIndex, endIndex: endIndex)
    }
    mutating func shiftUp(from: Int) {
        var currentIndex = from
        let currentElement = storage[from]
        var parentIndex = (currentIndex - 1) / 2
        while currentIndex > 0 && priority(currentElement, storage[parentIndex]) {
            storage[currentIndex] = storage[parentIndex]
            currentIndex = parentIndex
            parentIndex = (parentIndex - 1) / 2
        }
        storage[currentIndex] = currentElement
    }
}
extension PriorityQueue {
    mutating func enququ(_ newElement: Element) {
        storage.append(newElement)
        shiftUp(from: storage.count - 1)
    }
    mutating func dequeue() -> Element? {
        guard let first =  storage.first else { return nil }
        if storage.count == 1 { return storage.removeLast() }
        storage[0] = storage.removeLast()
        shiftDown(from: 0, endIndex: storage.count)
        return first
    }
}
// MARK: - 先进先出队列
struct FIFOQueue<Element> {
    var storage = [Element?]()
    var head = 0
}
extension FIFOQueue {
    mutating func enqueue(_ newElement: Element) {
        storage.append(newElement)
    }
    mutating func dequeue() -> Element? {
        guard head < storage.count, let first = storage[head] else { return  nil }
        storage[head] = nil
        head += 1
        if storage.count > 50 && (Double(head) / Double(storage.count) > 0.25) {
            storage.removeFirst(head)
            head = 0
        }
        return first
    }
}
// MARK: - 协议
enum Direction {
    case directed
    case undirected
}
protocol GraphProtocol: CustomDebugStringConvertible {
    associatedtype Vertex: Hashable
    typealias Edge = (Vertex, Vertex, Double)
    var vertices: [Vertex] { get set }
    var edges: [Edge] { get set }
    var visted: Set<Vertex> { get set }
    init()
}
extension GraphProtocol {
    var debugDescription: String {
        var literal = ""
        edges.forEach {
            literal += "\($0.0)-\($0.1): \($0.2)\n"
        }
        return literal
    }
}
extension GraphProtocol {
    mutating func addEdge(_ sorce: Vertex, destinaton: Vertex, weight: Double, direction: Direction = .directed) {
        if !vertices.contains(sorce) { vertices.append(sorce) }
        if !vertices.contains(destinaton) { vertices.append(destinaton) }
        edges.append((sorce, destinaton, weight))
        switch direction {
        case .directed: return
        case .undirected: edges.append((destinaton, sorce, weight))
        }
    }
}
// MARK: - 最小生成树
extension GraphProtocol {
    mutating func minimanSpanTree() -> Self? {
        var tree = Self.init()
        var unionFind = UnionFind<Vertex>()
        vertices.forEach { unionFind.initial($0) }
        edges.sorted(by: { $0.2 < $1.2 }).forEach {
            guard !unionFind.hasSameIndex($0.0, $0.1) else { return }
            tree.addEdge($0.0, destinaton: $0.1, weight: $0.2)
            unionFind.union($0.0, destination: $0.1)
        }
        return tree
    }
    mutating func minimanSapnTree(from source: Vertex) -> Self? {
        guard vertices.contains(source) else { return nil }
        visted.removeAll()
        visted.insert(source)
        var tree = Self.init()
        var queue = PriorityQueue<Edge>(priority: { $0.2 < $1.2 })
        edges.filter { $0.0 == source }.forEach { queue.enququ($0) }
        while let currentEdge  = queue.dequeue() {
            if visted.contains(currentEdge.1) { continue }
            visted.insert(currentEdge.1)
            tree.addEdge(currentEdge.0, destinaton: currentEdge.1, weight: currentEdge.2)
            edges.filter { $0.0 == currentEdge.1 }.forEach { queue.enququ($0) }
        }
        return tree
    }
}
// MARK: - 最短路径
extension GraphProtocol {
    mutating func shortestPath(from source: Vertex, destination: Vertex) -> [Vertex]? {
        guard vertices.contains(source) else { return nil }
        var previousVertex = [Vertex: Vertex]()
        var relaxedWeight = [Vertex: Double]()
        vertices.forEach { relaxedWeight[$0] = Double.infinity }
        previousVertex[source] = source
        relaxedWeight[source] = 0
        for _ in 1..<vertices.count {
            var update = false
            edges.forEach {
                guard let weightA = relaxedWeight[$0.0], let weightB = relaxedWeight[$0.1] else { return }
                if weightA + $0.2 < weightB {
                    relaxedWeight[$0.1] = weightA + $0.2
                    previousVertex[$0.1] = $0.0
                    update = true
                }
            }
            guard update else { break }
        }
        edges.forEach { guard relaxedWeight[source]! < relaxedWeight[destination]! + $0.2 else  { return } }
        func recursePath(from destination: Vertex) -> [Vertex]? {
            guard vertices.contains(destination) else { return nil }
            guard relaxedWeight[destination] != Double.infinity else { return nil}
            guard let previous = previousVertex[destination] else { return nil }
            guard previous != destination else { return [destination] }
            guard let path = recursePath(from: previous) else { return nil }
            return path + [destination]
        }
        return recursePath(from: destination)
    }
    mutating func shortestPathLength(from source: Vertex, destination: Vertex) -> (length: Double, member: [Vertex])? {
        visted.removeAll()
        visted = Set(vertices)
        var currentVertex: Vertex? = source
        var pathFromStart = [Vertex: ( length: Double, member:[Vertex] )]()
        vertices.forEach { pathFromStart[$0] = (Double.infinity, []) }
        pathFromStart[source]?.length = 0
        pathFromStart[source]?.member = [source]
        while let vertex = currentVertex {
            visted.remove(vertex)
            for edge in (edges.filter { $0.0 == vertex }) where visted.contains(edge.1) {
                guard let source = pathFromStart[edge.0], var destination = pathFromStart[edge.1] else { return nil }
                let relaxed = source.length + edge.2
                if relaxed < destination.length {
                    destination.length = relaxed
                    destination.member = source.member
                    destination.member.append(edge.1)
                    pathFromStart[edge.1] = destination
                }
            }
            guard !visted.isEmpty else {
                currentVertex = nil
                break
            }
            /// a - b - c   a.length = 0    b.length = 1    c.length = infiniti
            currentVertex = visted.min { pathFromStart[$0]!.length < pathFromStart[$1]!.length }
        }
        return pathFromStart[destination]
    }
}
// MARK: - 搜索
enum SearchPriority {
    case breadth
    case deepth
}
extension GraphProtocol {
    mutating func search(from source: Vertex, priority: SearchPriority = .breadth) -> [Vertex] {
        guard vertices.contains(source) else { return []}
        visted.insert(source)
        var temp = [source]
        switch priority {
        case .breadth:
            var temp = [source]
            var queue = FIFOQueue<Vertex>()
            queue.enqueue(source)
            while let vertex = queue.dequeue() {
                for edge in (edges.filter { $0.0 == vertex }) where !visted.contains(edge.1) {
                    queue.enqueue(edge.1)
                    temp.append(edge.1)
                    visted.insert(edge.1)
                }
            }
            return temp
        case .deepth:
            for edge in (edges.filter { $0.0 == source }) where !visted.contains(edge.1) {
                temp += search(from: edge.1, priority: .deepth)
            }
        }
        return temp
    }
    mutating func clearSeachResult() {
        visted.removeAll()
    }
}
struct Graph: GraphProtocol {
    var visted: Set<String> = Set<String>()
    typealias Vertex = String
    var vertices: [String]
    var edges: [(String, String, Double)]
    init() {
        vertices = [String]()
        edges = [Edge]()
    }
}
var graph = Graph()
graph.addEdge("a", destinaton: "f", weight: 1000)
graph.addEdge("a", destinaton: "b", weight: 1)
graph.addEdge("a", destinaton: "c", weight: 2)
graph.addEdge("b", destinaton: "d", weight: 3)
graph.addEdge("d", destinaton: "f", weight: 4)
graph.addEdge("b", destinaton: "c", weight: 5)

graph.addEdge("x", destinaton: "y", weight: 6)
graph.addEdge("y", destinaton: "z", weight: 7)
graph.addEdge("z", destinaton: "x", weight: 8)

graph.clearSeachResult()
print(graph.search(from: "a", priority: .breadth))
graph.clearSeachResult()
print(graph.search(from: "a", priority: .deepth))
print(graph.minimanSpanTree())
print(graph.minimanSapnTree(from: "a"))
print(graph.shortestPath(from: "a", destination: "f"))
print(graph.shortestPathLength(from: "a", destination: "f")?.length)

// Mark: - VERSION: 3
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
struct PriorityQueue<Element> {
    var storage = [Element]()
    var priority: (Element, Element) -> Bool
    init(priority: @escaping (Element, Element) -> Bool) {
        self.priority = priority
    }
}
extension PriorityQueue {
    mutating func shiftDown(from currentIndex: Int, endIndex: Int) {
        var cursor = currentIndex
        let childrenIndexL = currentIndex * 2 + 1
        let childrenIndexR = childrenIndexL + 1
        if childrenIndexL < endIndex && priority(storage[childrenIndexL], storage[cursor]) {
            cursor = childrenIndexL
        }
        if childrenIndexR < endIndex && priority(storage[childrenIndexR], storage[cursor]) {
            cursor = childrenIndexR
        }
        guard cursor != currentIndex else { return }
        storage.swapAt(cursor, currentIndex)
        shiftDown(from: cursor, endIndex: endIndex)
    }
    mutating func shiftUp(from currentIndex: Int) {
        var cursor = currentIndex
        var parentIndex = (currentIndex - 1) / 2
        let value = storage[currentIndex]
        while cursor > 0 && priority(storage[cursor], storage[parentIndex]) {
            storage[cursor] = storage[parentIndex]
            cursor = parentIndex
            parentIndex = (cursor - 1) / 2
        }
        storage[cursor] = value
    }
}
extension PriorityQueue {
    mutating func enqueue(_ element: Element) {
        storage.append(element)
        shiftUp(from: storage.endIndex - 1)
    }
    mutating func dequeue() -> Element? {
        guard let first = storage.first else { return nil }
        if storage.count == 1 { return storage.removeLast() }
        storage[0] = storage.removeLast()
        shiftDown(from: storage.startIndex, endIndex: storage.endIndex)
        return first
    }
}
struct Queue<Element> {
    var storage = [Element?]()
    var head = 0
}
extension Queue {
    mutating func enqueue(_ element: Element) {
        storage.append(element)
    }
    mutating func dequeue() -> Element? {
        guard head < storage.count, let first = storage[head] else { return nil }
        storage[head] = nil
        head += 1
        if storage.count > 50 && Double(head)/Double(storage.count) > 0.25 {
            storage.removeFirst(head)
            head = 0
        }
        return first
    }
}
enum Direction {
    case direct
    case undirected
}
protocol GraphProtocol: CustomDebugStringConvertible {
    associatedtype Vertex: Hashable, Comparable
    typealias Edge = (Vertex, Vertex, Double)
    var edges: [Edge] { get set }
    var vertices: Set<Vertex> { get set }
    var visted: Set<Vertex> { get set }
    init()
}
extension GraphProtocol {
    mutating func addEdge(_ source: Vertex, destination: Vertex, weight: Double, direction: Direction = .direct) {
        vertices.insert(source)
        vertices.insert(destination)
        edges.append((source, destination, weight))
        switch direction {
        case .direct: return
        case .undirected:
            edges.append((destination, source, weight))
        }
    }
    mutating func reduceWeight(_ vertices: [Vertex]) -> Double {
        var temp = [Edge]()
        for currentIndex in 0..<vertices.count - 1 {
            let result = edges.filter { $0.0 == vertices[currentIndex] && $0.1 == vertices[currentIndex + 1] }
            temp.append(contentsOf: result)
        }
        return temp.reduce(0) { $0 + $1.2 }
    }
    var debugDescription: String {
        var temp = ""
        edges.forEach {
            temp += "\($0.0)-\($0.1): \($0.2)\n"
        }
        return temp
    }
}
extension GraphProtocol {
    mutating func minimumSpanningTree() -> Self {
        var tree = Self.init()
        var unionFind = UnionFind<Vertex>()
        vertices.forEach { unionFind.initial($0) }
        for edge in edges.sorted(by: { $0.2 < $1.2 }) {
            guard !unionFind.hasSameIndex(edge.0, edge.1) else { continue }
            tree.addEdge(edge.0, destination: edge.1, weight: edge.2)
            unionFind.union(source: edge.0, destination: edge.1)
        }
        return tree
    }
    mutating func minimumSpaningTree(_ source: Vertex) -> Self? {
        guard vertices.contains(source) else { return nil }
        var tree = Self.init()
        visted.removeAll()
        visted.insert(source)
        var queue = PriorityQueue<Edge>(priority: <)
        edges.filter { $0.0 == source }.forEach { queue.enqueue($0) }
        while let edge = queue.dequeue() {
            if visted.contains(edge.1) { continue }
            visted.insert(edge.1)
            tree.addEdge(edge.0, destination: edge.1, weight: edge.2)
            edges.filter { $0.0 == edge.1 }.forEach { queue.enqueue($0) }
        }
        return tree
    }
}
extension GraphProtocol {
    mutating func shortestPath(from source: Vertex, destination: Vertex) -> [Vertex] {
        guard vertices.contains(source), vertices.contains(destination) else { return [] }
        var weight = [Vertex: Double]()
        var precursor = [Vertex: Vertex]()
        vertices.forEach { weight[$0] = Double.infinity }
        weight[source] = 0
        precursor[source] = source
        for _ in 0..<vertices.count - 1 {
            var update = false
            edges.forEach {
                guard let sourceWeight = weight[$0.0], let destinationWeight = weight[$0.1] else { return }
                let relaxed = sourceWeight + $0.2
                if relaxed < destinationWeight {
                    weight[$0.1] = relaxed
                    precursor[$0.1] = $0.0
                    update = true
                }
            }
            guard update else { break }
        }
        print(weight)
        for edge in edges {
            guard let sourceWeight = weight[edge.0], let destinationWeight = weight[edge.1] else { return [] }
            if destinationWeight > sourceWeight + edge.2 { return [] }
        }
        func recurse(_ destination: Vertex) -> [Vertex] {
            guard weight[destination] != Double.infinity, let previousVertex = precursor[destination] else { return [] }
            if previousVertex == destination { return [previousVertex] }
            return recurse(previousVertex) + [destination]
        }
        return recurse(destination)
    }
    mutating func shortestPath(_ source: Vertex, destination: Vertex) -> (length: Double, member: [Vertex])? {
        guard vertices.contains(source), vertices.contains(destination) else { return nil }
        var path = [Vertex: (length: Double, member: [Vertex])]()
        vertices.forEach { path[$0] = (Double.infinity, []) }
        path[source] = (0, [source])
        visted = vertices
        var vertex: Vertex? = source
        while let currentVertex = vertex {
            visted.remove(currentVertex)
            edges.forEach {
                guard let sourceVertex = path[$0.0], let destinationVertex = path[$0.1] else { return }
                let relaxed = sourceVertex.length + $0.2
                if relaxed < destinationVertex.length {
                    path[$0.1]?.length = relaxed
                    path[$0.1]?.member = sourceVertex.member
                    path[$0.1]?.member.append($0.1)
                    
                }
                vertex = visted.min { path[$0]!.length < path[$1]!.length }
            }
        }
        return path[destination]
    }
}
enum SearchPriority {
    case breadth
    case deepth
}
extension GraphProtocol {
    mutating func search(_ source: Vertex, priority: SearchPriority = .breadth) -> [Vertex] {
        guard vertices.contains(source) else { return [] }
        var temp = [source]
        visted.insert(source)
        switch priority {
        case .breadth:
            var queue = Queue<Vertex>()
            queue.enqueue(source)
            while let vertex = queue.dequeue() {
                for edge in (edges.filter { $0.0 == vertex }) where !visted.contains(edge.1) {
                    temp.append(edge.1)
                    queue.enqueue(edge.1)
                    visted.insert(edge.1)
                }
            }
        case .deepth:
            for edge in (edges.filter { $0.0 == source }) where !visted.contains(edge.1) {
                temp += search(edge.1, priority: .deepth)
            }
        }
        return temp
    }
    mutating func clearSearchResult() {
        visted.removeAll()
    }
}
struct BasicGraph: GraphProtocol {
    typealias Vertex = String
    var edges: [(String, String, Double)]
    var vertices: Set<String>
    var visted: Set<String>
    init() {
        edges = [Edge]()
        vertices = Set<Vertex>()
        visted = Set<Vertex>()
    }
}
var grpah = BasicGraph()
grpah.addEdge("a", destination: "b", weight: 100)
grpah.addEdge("b", destination: "c", weight: 3)
grpah.addEdge("a", destination: "d", weight: 2_000)
//print(grpah.minimumSpanningTree())
//print(grpah.minimumSpaningTree("a"))
//print(grpah.reduceWeight(grpah.shortestPath(from: "a", destination: "c")))
//print(grpah.shortestPath("a", destination: "c")?.member)
grpah.clearSearchResult()
print(grpah.search("a"))
grpah.clearSearchResult()
print(grpah.search("a", priority: .deepth))

struct AdjacencyMatrix: GraphProtocol {
    typealias Vertex = String
    var edges: [(String, String, Double)]
    var vertices: Set<String>
    var visted: Set<String>
    var index = [Vertex: Int]()
    var matrix = [[Double?]]()
    init() {
        edges = [Edge]()
        vertices = Set<Vertex>()
        visted = Set<Vertex>()
    }
}
extension AdjacencyMatrix {
    mutating func addVertex(_ vertex: Vertex) {
        matrix.indices.forEach { matrix[$0].append(nil) }
        index[vertex] = matrix.count
        let newRow = [Double?](repeating: nil, count: matrix.count.advanced(by: 1))
        matrix.append(newRow)
        
    }
    /// Matrix
    mutating func addEdge(_ source: String, destination: String, weight: Double, direction: Direction = .direct) {
        if vertices.insert(source).inserted { addVertex(source) }
        if vertices.insert(destination).inserted { addVertex(destination) }
        edges.append((source, destination, weight))
        guard let sourceIndex = index[source], let destinationIndex = index[destination] else { return }
        matrix[sourceIndex][destinationIndex] = weight
        switch direction {
        case .direct: return
        case .undirected:
            matrix[destinationIndex][sourceIndex] = weight
            edges.append((destination, source, weight))
        }
    }
    mutating func getWeight(_ source: Vertex, destination: Vertex) -> Double? {
        guard let sourceIndex = index[source], let destinationIndex = index[destination] else { return nil }
        return matrix[sourceIndex][destinationIndex]
    }
}
struct AdjacencyLinkedList: GraphProtocol {
    typealias Vertex = String
    var edges: [(String, String, Double)]
    var vertices: Set<String>
    var visted: Set<String>
    var list = [Vertex: [(Vertex, Double)]]()
    init() {
        edges = [Edge]()
        vertices = Set<Vertex>()
        visted = Set<Vertex>()
    }
}
extension AdjacencyLinkedList {
    /// List
    mutating func addEdge(_ source: String, destination: String, weight: Double, direction: Direction = .direct) {
        vertices.insert(source)
        vertices.insert(destination)
        edges.append((source, destination, weight))
        list[source] = list[source] ?? []
        list[source]?.append((destination, weight))
        switch direction {
        case .direct: return
        case .undirected:
            edges.append((destination, source, weight ))
            list[destination] = list[destination] ?? []
            list[destination]?.append((source, weight))
        }
    }
    subscript(vertex: Vertex) -> [(Vertex, Double)]? {
        guard vertices.contains(vertex) else { return nil }
        return list[vertex]
    }
}
