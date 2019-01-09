/** * * * * * * * * * * * *
 # BreadthFirstSearch
 + 主要用于树形或图形数据结构的搜索和遍历
 + 把临近节点加入队列 while dequeue 判断每个临近节点是否存在另外的节点 如果存在加入队列 循环dequeue先进先出
 **FIFO Queue**
 + dequeue A traverse Edges -> If Visted == false enQueue [B,C] -> BC vidted = True -> nodesExplored[B,C]
 + dequeue B -> [C,D,E]
 + dequeue C -> [D,E,F,G]
 + dequeue D -> [E,F,G,H]
 + dequeue E,F,G,H
 
 
 # depthFirstSearch
 nodesExplored[A]
 traverse Edges -> B C               hang up -C-
 recursion depthFirstSearch  B
 
 nodesExplored[A,B]
 B traverse Edges -> D E             hang up -E-
 recursion depthFirstSearch  D
 
 nodesExplored[A,B,D]
 D traverse Edges -> nil
 recursion depthFirstSearch -E-
 
 nodesExplored[A,B,D,E]
 E traverse Edges -> H
 recursion depthFirstSearch  H
 
 nodesExplored[A,B,D,E,H]
 H traverse Edges -> nil
 recursion depthFirstSearch -C-
 
 nodesExplored[A,B,D,E,H,C]
 C traverse Edges -> F G
 recursion depthFirstSearch  F      hang up -G-
 
 nodesExplored[A,B,D,E,H,F]
 F traverse Edges -> nil
 recursion depthFirstSearch -G-
 
 nodesExplored[A,B,D,E,H,F,G]
 G traverse Edges -> nil
 recursion depthFirstSearch nil
 ---
 
 
 # breadthFirstSearchShortestPath(Unweighted)
 dequeue 一个元素 travers 该元素Edges内的相关节点 每个节点累加该元素已有distance
 + dequeue A -> enquence BC   [B,C]         B.distance = A.distance + 1  C.distance = A.distance + 1
 + dequeue B -> enqueue  DE   [C,D,E]       D.distance = B.distance + 1  E.distance = B.distance + 1
 + dequeue C -> enqueue  FG   [D,E,F,G]     ...
 + dequeue D -> enqueue  H    [E,F,G,H]
 + dequeue E,F,G,H
 ---
 
 
 ````
             A
           /   \
          B     C
         / \   / \
        D   E F   G
        |
        H
 ````
 ---
 
 
 
 ## **Queue**                **Edge**                     **Node**                             **Graph**
 + isEmpty                   anotherNode:Node             adjacentEdges[Edge]                  nodes
 + count                                                  label:String                         addNode
 + enqueue                                                visited:Bool                         addEdge
 + dequeue                                                distance                             findNodeWithLabel
 + first                                                  hasDistance                          duplicate
                                                          init(lable)
                                                          remove(edge)
 
 ---
 * * * * * * * * * * * * */
public struct Queue<T> {
    private var array: [T]
    public init() {
        array = []
    }
    public var isEmpty: Bool {
        return array.isEmpty
    }
    public var count: Int {
        return array.count
    }
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    public func first() -> T? {
        return array.first
    }
}
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
// Search
func breadthFirstSearch(_ graph: Graph, source: Node) -> [String] {
    var queue = Queue<Node>()
    queue.enqueue(source)                         ///   dequeue sourceNode
    var nodesExplored = [source.label]            ///   node
    source.visited = true                         ///    |   \        for edge in node.neighbirs  [edge]
    while let node = queue.dequeue() {            ///   node1 node2   edge.neighbor
        for edge in node.adjacentEdges {          ///    |
            let neighborNode = edge.anotherNode   ///   node3
            if !neighborNode.visited {            ///    -> enQueue   neighbor.visited = true   queue[node1 node2]
                queue.enqueue(neighborNode)       ///    -> deQueue   for in node1.neighbors -> edge.neighborNode
                neighborNode.visited = true       ///                 queue[node2, node3]
                nodesExplored.append(neighborNode.label)
            }
        }
    }
    return nodesExplored
}
func depthFirstSearch(_ graph: Graph, source: Node) -> [String] {
    var nodesExplored = [source.label]
    source.visited = true
    for edge in source.adjacentEdges {
        if !edge.anotherNode.visited {
            nodesExplored += depthFirstSearch(graph, source: edge.anotherNode)
        }
    }
    return nodesExplored
}
func breadthFirstSearchShortestPath(graph: Graph, source: Node) -> Graph {
    let shortestPathGraph = graph.duplicate()
    var queue = Queue<Node>()
    let sourceInShortestPathsGraph = shortestPathGraph.findNodeWithLabel(source.label)
    queue.enqueue(sourceInShortestPathsGraph)
    sourceInShortestPathsGraph.distance = 0
    while let current = queue.dequeue() {
        for edge in current.adjacentEdges {
            let neighborNode = edge.anotherNode
            if !neighborNode.hasDistance {
                queue.enqueue(neighborNode)
                neighborNode.distance = current.distance! + 1
            }
        }
    }
    return shortestPathGraph
}

let graph = Graph()
let nodeA = graph.addNode("a")
let nodeB = graph.addNode("b")
let nodeC = graph.addNode("c")
let nodeD = graph.addNode("d")
let nodeE = graph.addNode("e")
let nodeF = graph.addNode("f")
let nodeG = graph.addNode("g")
let nodeH = graph.addNode("h")
graph.addEdge(nodeA, anotherNode: nodeB)  ///       A
graph.addEdge(nodeA, anotherNode: nodeC)  ///     /   \
graph.addEdge(nodeB, anotherNode: nodeD)  ///    B     C
graph.addEdge(nodeB, anotherNode: nodeE)  ///   / \    / \
graph.addEdge(nodeC, anotherNode: nodeF)  ///  D   E  F   G
graph.addEdge(nodeC, anotherNode: nodeG)  ///      |
graph.addEdge(nodeE, anotherNode: nodeH)  ///      H
graph.addEdge(nodeE, anotherNode: nodeF)
graph.addEdge(nodeF, anotherNode: nodeG)

///let nodesExplored = breadthFirstSearch(graph, source: nodeA)
let nodesExplored2 = depthFirstSearch(graph, source: nodeA)
///print(nodesExplored)
print(nodesExplored2)
///["a", "b", "c", "d", "e", "f", "g", "h"]
///["a", "b", "d", "e", "h", "f", "g", "c"]
let shortestPathGraph = breadthFirstSearchShortestPath(graph: graph, source: nodeA)
print(shortestPathGraph.nodes)
/**
 [Node(label: a, distance: 0),
 Node(label: b, distance: 1),
 Node(label: c, distance: 1),
 Node(label: d, distance: 2),
 Node(label: e, distance: 2),
 Node(label: f, distance: 2),
 Node(label: g, distance: 2),
 Node(label: h, distance: 3)] */

// MARK: - VERSION 2
public struct Queue<T> {
    var array = [T?]()
    var head = 0
}
extension Queue {
    var isEmpty: Bool {
        return head == 0
    }
    var count: Int {
        return array.count - head
    }
}
extension Queue {
    mutating func enqueue(_ newValue: T) {
        array.append(newValue)
    }
    mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        array[head] = nil
        head += 1
        if array.count > 50 && ( Double(head) / Double(array.count) ) > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        return element
    }
}
public struct Grahp: Equatable {
    public private(set) var vertices = [Vertex]()
}
extension Grahp {
    public class Vertex: Equatable {
        var lable: String
        var edges: [Edge]
        var isVisted: Bool
        init(lable: String) {
            self.lable = lable
            edges = [Edge]()
            isVisted = false
        }
        public static func == (lhs: Grahp.Vertex, rhs: Grahp.Vertex) -> Bool {
            return lhs.lable == rhs.lable
        }
    }
    public struct Edge {
        var anotherVertex: Vertex
    }
}
extension Grahp {
    public mutating func append(_ newValue: String) -> Vertex {
        let newVertex = Vertex(lable: newValue)
        vertices.append(newVertex)
        return newVertex
    }
    public mutating func addEdges(source: Vertex, another: Vertex) {
        source.edges.append(Edge(anotherVertex: another))
    }
}
extension Grahp {
    func breadthFirstSearch(source: Vertex) -> [String] {
        var exploredArray = [String]()
        var queue = Queue<Vertex>()
        source.isVisted = true
        queue.enqueue(source)
        while let currentVertex = queue.dequeue() {
            currentVertex.edges.forEach {
                if !$0.anotherVertex.isVisted {
                    queue.enqueue($0.anotherVertex)
                    $0.anotherVertex.isVisted = true
                    exploredArray.append($0.anotherVertex.lable)
                }
            }
        }
        return exploredArray
    }
    func deepthForstSearch(source: Vertex) -> [String] {
        var exploredArray = [source.lable]
        source.isVisted = true
        source.edges.forEach {
            if !$0.anotherVertex.isVisted {
                exploredArray += deepthForstSearch(source: $0.anotherVertex)
            }
        }
        return exploredArray
    }
}
var graph = Grahp()
let nodeA = graph.append("a")  ///       a
let nodeB = graph.append("b")  ///     b   d
let nodeC = graph.append("c")  ///   c
let nodeD = graph.append("d")  ///
graph.addEdges(source: nodeA, another: nodeB)
graph.addEdges(source: nodeA, another: nodeD)
graph.addEdges(source: nodeB, another: nodeC)
let result = graph.deepthForstSearch(source: nodeA)
print(result) //["a", "b", "c", "d"]

// MARK: - VERSION 3
public struct Queue<T> {
    var array = [T?]()
    var head = 0
}
extension Queue {
    mutating func enqueue(_ newValue: T) {
        array.append(newValue)
    }
    mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        array[head] = nil
        head += 1
        if array.count > 50 && ( Double(head) / Double(array.count) ) > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        return element
    }
}
struct Graph {
    class Vertex {
        var identifier: String
        var adjacent:[(Vertex)]
        var weight: Int?
        var visited: Bool
        init(identifier: String) {
            self.identifier = identifier
            adjacent = [Vertex]()
            visited = false
        }
    }
    var vertices = Set<Vertex>()
    func initialVisted() {
        vertices.forEach {
            $0.visited = false
        }
    }
}
extension Graph {
    mutating func addVertex(_ identifier: String) -> Vertex {
        let vertex = Vertex(identifier: identifier)
        vertices.insert(vertex)
        return vertex
    }
}
extension Graph.Vertex: Equatable, Hashable, CustomDebugStringConvertible {
    static func == (lhs: Graph.Vertex, rhs: Graph.Vertex) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    var debugDescription: String {
        return "\(identifier)"
    }
}
enum SearchingMethods {
    case breadth
    case deepth
}
extension Graph {
    func search(from source: Vertex, by selected: SearchingMethods) -> [Vertex] {
        var tempArray = [source]
        initialVisted()
        source.visited = true
        switch selected {
        case .breadth:
            var queue = Queue<Vertex>()
            queue.enqueue(source)
            while let vertex = queue.dequeue() {
                for anotherVertex in vertex.adjacent where !anotherVertex.visited {
                    queue.enqueue(anotherVertex)
                    tempArray.append(anotherVertex)
                    anotherVertex.visited = true
                }
            }
            return tempArray
        case .deepth:
            for anotherVertex in source.adjacent where !anotherVertex.visited {
                tempArray += search(from: anotherVertex, by: .deepth)
            }
            return tempArray
        }
    }
}
var graph = Graph()
var vertexA = graph.addVertex("a")
var vertexB = graph.addVertex("b")
var vertexC = graph.addVertex("c")
var vertexD = graph.addVertex("d")
var vertexE = graph.addVertex("e")
var vertexF = graph.addVertex("f")
vertexA.adjacent.append(vertexB)
vertexA.adjacent.append(vertexC)

vertexB.adjacent.append(vertexD)
//vertexB.adjacent.append(vertexD)

vertexC.adjacent.append(vertexE)
//vertexC.adjacent.append(vertexE)

vertexD.adjacent.append(vertexF)
print(graph.search(from: vertexA, by: .breadth))
print(graph.search(from: vertexA, by: .deepth))

// MARK: - Version 4
struct Queue<Element> {
    var storage = [Element?]()
    var head = 0
}
extension Queue {
    mutating func enqueue(_ newElement: Element) {
        storage.append(newElement)
    }
    mutating func dequeue() -> Element? {
        guard head < storage.count, let element = storage[head] else  { return nil }
        storage[head] = nil
        head += 1
        if storage.count > 50 && (Double(head) / Double(storage.count)) > 0.25 {
            storage.removeFirst(head)
            head = 0
        }
        return element
    }
}
enum Direction {
    case undirected
    case directed
}
struct Graph<Vertex: Hashable> {
    typealias Edge = (Vertex, Vertex)
    var edges = [Edge]()
    var vertices = Set<Vertex>()
}
extension Graph {
    mutating func addEdge(_ source: Vertex, destination: Vertex, direction: Direction = .directed) {
        vertices.insert(source)
        vertices.insert(destination)
        edges.append((source, destination))
        switch direction {
        case .directed: return
        case .undirected: edges.append((destination, source))
        }
    }
}
extension Graph: CustomDebugStringConvertible {
    var debugDescription: String {
        var literal = ""
        edges.forEach {
            literal += "\($0.0)-\($0.1)\n"
        }
        return literal
    }
}
func breadthSearch<Vertex>(from: Vertex, in graph: Graph<Vertex>) -> [Vertex] {
    var result = [Vertex]()
    var queue = Queue<Vertex>()
    guard let source = (graph.vertices.filter { $0 == from }.first) else { return [] }
    queue.enqueue(source)
    result.append(source)
    while let vertex = queue.dequeue() {
        graph.edges.filter { $0.0 == vertex }.forEach {
            queue.enqueue($0.1)
            result.append($0.1)
        }
    }
    return result
}
func deepthSearch<Vertex>(from: Vertex, in graph: Graph<Vertex>) -> [Vertex] {
    var result = [from]
    for edge in (graph.edges.filter { $0.0 == from }) {
        result += deepthSearch(from: edge.1, in: graph)
    }
    return result
}
var graph = Graph<String>()
graph.addEdge("a", destination: "b")
graph.addEdge("a", destination: "c")
graph.addEdge("b", destination: "d")
graph.addEdge("b", destination: "e")
graph.addEdge("c", destination: "f")
graph.addEdge("d", destination: "g")

print(breadthSearch(from: "a", in: graph))
print(deepthSearch(from: "a", in: graph))
