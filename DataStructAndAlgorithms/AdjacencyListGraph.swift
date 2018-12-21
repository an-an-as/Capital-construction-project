import Foundation
public struct Vertex<T>: Equatable where T: Hashable {
    public var data: T
    public let index: Int
}
extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(index): \(data)"
    }
}
extension Vertex: Hashable {
    public var hashValue: Int {
        return "\(data)\(index)".hashValue
    }
}
public struct Edge<T>: Equatable where T: Hashable {
    public let from: Vertex<T>
    public let to: Vertex<T>
    public let weight: Double?
}
extension Edge: CustomStringConvertible {
    public var description: String {
        guard let unwrappedWeight = weight else {
            return "\(from.description) -> \(to.description)"
        }
        return "\(from.description) -(\(unwrappedWeight))-> \(to.description)"
    }
}
extension Edge: Hashable {
    public var hashValue: Int {
        var string = "\(from.description)\(to.description)"
        if weight != nil {
            string.append("\(weight!)")
        }
        return string.hashValue
    }
}
public func == <T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    guard lhs.index == rhs.index else {
        return false
    }
    guard lhs.data == rhs.data else {
        return false
    }
    return true
}
private class EdgeList<T> where T: Hashable {            /// EdgeList                           EdgeListA
    var vertex: Vertex<T>                                /// vertex                             data: A index: 0
    var edges: [Edge<T>]?                                /// edges [Edge1, Edge2, Edge3]        edges [vertexFrom: A, vertexTo: B, weight: 100]
    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }
    func addEdge(_ edge: Edge<T>) {
        edges?.append(edge)
    }
}
struct AdjacencyListGraph<T> where T: Hashable {         /// adjacencyList                                      5
    fileprivate var adjacencyList = [EdgeList<T>]()      /// EdgeListA        A  A-B:5,  A-C:6              A ----- B
    var vertices: [Vertex<T>] {                          /// EdgeListB        B  B-A:5,  B-C:7           6  |       |
        var vertices = [Vertex<T>]()                     /// EdgeListC        C  C-A:1,  C-B:9              C ------9
        for edgeList in adjacencyList {
            vertices.append(edgeList.vertex)
        }
        return vertices
    }
    var edges: [Edge<T>] { 
        var allEdges = Set<Edge<T>>()
        for edgeList in adjacencyList {
            guard let edges = edgeList.edges else {
                continue
            }
            for edge in edges {
                allEdges.insert(edge)
            }
        }
        return Array(allEdges)
    }
    mutating func createVertex(_ data: T) -> Vertex<T> {
        let matchingVertices = vertices.filter { vertex in
            return vertex.data == data
        }
        if matchingVertices.count > 0 {
            return matchingVertices.last!
        }
        let vertex = Vertex(data: data, index: adjacencyList.count)       ///   EdgeList [ lista vertex(data:a index:0) [edges?]
        adjacencyList.append(EdgeList(vertex: vertex))                    ///              listb vertex(data:b index:1) [edges?]-> From:b To:c Weight:2.0
        return vertex                                                     ///              listc vertex(data:b index:a) [edges?]
    }                                                                     ///            ]
    mutating func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        let edge = Edge(from: from, to: to, weight: weight)
        let edgeList = adjacencyList[from.index]
        if edgeList.edges != nil {
            edgeList.addEdge(edge)
        } else {
            edgeList.edges = [edge]
        }
    }
    mutating func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }
    mutating func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        guard let edges = adjacencyList[sourceVertex.index].edges else {
            return nil
        }
        for edge: Edge<T> in edges where edge.to == destinationVertex {
            return edge.weight
        }
        return nil
    }
    mutating func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        return adjacencyList[sourceVertex.index].edges ?? []
    }
    var description: String {
        var rows = [String]()
        for edgeList in adjacencyList {
            guard let edges = edgeList.edges else {
                continue
            }
            var row = [String]()
            for edge in edges {
                var value = "\(edge.to.data)"
                if edge.weight != nil {
                    value = "(\(value): \(edge.weight!))"
                }
                row.append(value)
            }
            rows.append("\(edgeList.vertex.data) -> [\(row.joined(separator: ", "))]")
        }
        return rows.joined(separator: "\n")
    }
}
var graph = AdjacencyListGraph<String>()
let a = graph.createVertex("a")
let b = graph.createVertex("b")
let c = graph.createVertex("c")
graph.addDirectedEdge(a, to: b, withWeight: 1.0)
graph.addDirectedEdge(b, to: c, withWeight: 2.0)
graph.addDirectedEdge(a, to: c, withWeight: -5.5)
print(graph.description)

//MARK: - Version2
public struct AdjacencyListGraph<T: Hashable> {
    private var list = [AdjacencyList<T>]()
}
extension AdjacencyListGraph {
    public struct Vertex<T: Hashable>: Equatable {
        var data: T
        var index: Int
    }
    public struct Edge<T: Hashable>: Equatable {
        var vertexFrom: Vertex<T>
        var vertexTo: Vertex<T>
        var weight: Double?
    }
}
extension AdjacencyListGraph {
    private class AdjacencyList<T: Hashable> {
        var vertex: Vertex<T>
        var edges: [Edge<T>]?
        init(vertex: Vertex<T>) {
            self.vertex = vertex
        }
        func append(_ newEdge: Edge<T>) {
            self.edges?.append(newEdge)
        }
    }
}
extension AdjacencyListGraph {
    public var vertices: [Vertex<T>] {
        return list.map { $0.vertex }
    }
    public var edges: [Edge<T>] {
        var temp = [Edge<T>]()
        for edgeList in list {
            guard edgeList.edges != nil else { continue }
            for currentEdge in edgeList.edges! {
                temp.append(currentEdge)
            }
        }
        return temp
    }
}
extension AdjacencyListGraph {
    mutating func createVertex(_ data: T) -> Vertex<T> {
        let matching = vertices.filter { $0.data == data }
        if matching.count > 0 {
            return matching.last!
        }
        let newVertex = Vertex(data: data, index: list.count)
        list.append(AdjacencyList(vertex: newVertex))
        return newVertex
    }
}
extension AdjacencyListGraph {
    mutating func addDirectEdge(source: Vertex<T>, destination: Vertex<T>, weight: Double?) {
        let newEdge = Edge(vertexFrom: source, vertexTo: destination, weight: weight)
        let currentList = list[source.index]
        if currentList.edges != nil {
            currentList.append(newEdge)
        } else {
            currentList.edges = [newEdge]
        }
    }
}
extension AdjacencyListGraph {
    func getWeight(source: Vertex<T>, destination: Vertex<T>) -> Double? {
        guard let edgeList = list[source.index].edges else { return nil }
        for currentEdge in edgeList where currentEdge.vertexTo == destination {
            return currentEdge.weight
        }
        return nil
    }
}
var graph = AdjacencyListGraph<String>()
let targetA = graph.createVertex("A")
let targetB = graph.createVertex("B")
let targetC = graph.createVertex("C")
graph.addDirectEdge(source: targetA, destination: targetB, weight: 100)
graph.addDirectEdge(source: targetA, destination: targetC, weight: 200)
print(graph.getWeight(source: targetA, destination: targetC))

//MARK: - Version3
public struct Edge<T> {
    public var vertex1: T
    public var vertex2: T
    public var weight: Int
}
extension Edge: CustomStringConvertible {
    public var description: String {
        return "\(vertex1)-\(vertex2): \(weight)"
    }
}
public struct AdjacencyListGraph<T: Hashable> {
    public private(set) var edges: [Edge<T>]
    public private(set) var vertices: Set<T>
    public private(set) var list: [T: [(vertex: T, weight: Int)]]
    init() {
        edges = [Edge<T>]()
        vertices = Set<T>()
        list = [T: [(vertex: T, weight: Int)]]()
    }
}
extension AdjacencyListGraph {
    public mutating func addEdge(vertex1: T, vertex2: T, weight: Int) {
        edges.append(Edge(vertex1: vertex1, vertex2: vertex2, weight: weight))
        vertices.insert(vertex1)
        vertices.insert(vertex2)
        list[vertex1] = list[vertex1] ?? []
        list[vertex1]?.append( (vertex: vertex1, weight: weight) )
    }
}
extension AdjacencyListGraph: CustomStringConvertible {
    public var description: String {
        var str = ""
        for edge in edges {
            str += edge.description + "\n"
        }
        return str
    }
}

// MARK: - Version4
// swiftlint:disable identifier_name line_length
public enum Directable {
    case directed
    case undirected
}
/// - Complexity:
/// ```
/// | Operation       | Adjacency List | Adjacency Matrix |
/// |-----------------|----------------|------------------|
/// | Storage Space   | O(V + E)       | O(V^2)           |
/// | Add Vertex      | O(1)           | O(V^2)           |
/// | Add Edge        | O(1)           | O(1)             |
/// | Check Adjacency | O(V)           | O(1)             |
/// ```
public struct AdjacencyListGraph<Vertex: Hashable, Weight> {
    typealias Edge = (vertexL: Vertex, vertexR: Vertex, weight: Weight)
    private(set) var edges: [Edge]
    private(set) var vertices: Set<Vertex>
    private(set) var list: [Vertex: [(Vertex, weight: Weight)]]
    init() {
        edges = [Edge]()
        vertices = Set<Vertex>()
        list = [Vertex: [(Vertex, weight: Weight)]]()
    }
}
extension AdjacencyListGraph {
    mutating func addEdge(_ source: Vertex, destination: Vertex, weight: Weight, directable: Directable = .directed) {
        vertices.insert(source)
        vertices.insert(destination)
        edges.append(Edge(vertexL: source, vertexR: destination, weight: weight))
        switch directable {
        case .directed:
            list[source] = list[source] ?? []
            list[source]?.append( (destination, weight: weight) )
        case .undirected:
            list[destination] = list[destination] ?? []
            list[destination]?.append( (source, weight: weight) )
            edges.append(Edge(vertexL: destination, vertexR: source, weight: weight))
        }
    }
    func getWeight(source: Vertex, destination: Vertex) -> Weight? {
        for element in edges where element.vertexL == source && element.vertexR == destination {
            return element.weight
        }
        return nil
    }
}
extension AdjacencyListGraph: CustomStringConvertible {
    public var description: String {
        var str = ""
        for element in edges {
            str += "\(element.vertexL)-\(element.vertexR): \(element.weight)\n"
        }
        return str
    }
}
var list = AdjacencyListGraph<String,Int>()
list.addEdge("a", destination: "b", weight: 1, directable: .undirected)
list.addEdge("a", destination: "c", weight: 2, directable: .undirected)
list.addEdge("a", destination: "d", weight: 3_000, directable: .directed)
print(list)
print(list.vertices.sorted())
print(list.edges.filter { $0.vertexL == "a"}.map { "\($0.vertexL)-\($0.vertexR): \($0.weight)" }.joined(separator: "\n"))
list.getWeight(source: "a", destination: "b").map { print($0) }
