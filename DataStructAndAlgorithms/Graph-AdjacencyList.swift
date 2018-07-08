// swiftlint:disable identifier_name line_length
import Foundation
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
public func == <T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    guard lhs.from == rhs.from else {
        return false
    }
    guard lhs.to == rhs.to else {
        return false
    }
    guard lhs.weight == rhs.weight else {
        return false
    }
    return true
}
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
public func == <T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    guard lhs.index == rhs.index else {
        return false
    }
    guard lhs.data == rhs.data else {
        return false
    }
    return true
}
open class AbstractGraph<T>: CustomStringConvertible where T: Hashable {
    public required init() {}
    public required init(fromGraph graph: AbstractGraph<T>) {
        for edge in graph.edges {
            let from = createVertex(edge.from.data)
            let to = createVertex(edge.to.data)
            addDirectedEdge(from, to: to, withWeight: edge.weight)
        }
    }
    open var description: String {
        fatalError("abstract property accessed")
    }
    open var vertices: [Vertex<T>] {
        fatalError("abstract property accessed")
    }
    open var edges: [Edge<T>] {
        fatalError("abstract property accessed")
    }
    open func createVertex(_ data: T) -> Vertex<T> {
        fatalError("abstract function called")
    }
    open func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        fatalError("abstract function called")
    }
    open func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        fatalError("abstract function called")
    }
    open func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        fatalError("abstract function called")
    }
    open func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        fatalError("abstract function called")
    }
}
private class EdgeList<T> where T: Hashable {
    var vertex: Vertex<T>
    var edges: [Edge<T>]?
    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }
    func addEdge(_ edge: Edge<T>) {
        edges?.append(edge)
    }
}
open class AdjacencyListGraph<T>: AbstractGraph<T> where T: Hashable {/// EdgeList -> vertex edges
    fileprivate var adjacencyList = [EdgeList<T>]()     /// vertex(vertex.data index)    [edges](from to vertex , weight)
    public required init() {                            ///
        super.init()
    }
    public required init(fromGraph graph: AbstractGraph<T>) {
        super.init(fromGraph: graph)
    }
    open override var vertices: [Vertex<T>] {
        var vertices = [Vertex<T>]()
        for edgeList in adjacencyList {
            vertices.append(edgeList.vertex)
        }
        return vertices
    }
    open override var edges: [Edge<T>] {
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
    open override func createVertex(_ data: T) -> Vertex<T> {
        let matchingVertices = vertices.filter { vertex in
            return vertex.data == data
        }
        if matchingVertices.count > 0 {
            return matchingVertices.last!
        }
        ///添加vertex节点到EdgeList adjacencyList存储这些
        let vertex = Vertex(data: data, index: adjacencyList.count)       ///   EdgeList [ lista vertex(data:a index:0) [edges?]-> From:a To:b Weight:1.0 From:a To:c Weight:-5.5
        adjacencyList.append(EdgeList(vertex: vertex))                    ///              listb vertex(data:b index:1) [edges?]-> From:b To:c Weight:2.0
        return vertex                                                     ///              listc vertex(data:b index:a) [edges?]
    }                                                                     ///            ]
    open override func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        let edge = Edge(from: from, to: to, weight: weight)               ///   创建edge节点间权值
        let edgeList = adjacencyList[from.index]                          ///   临接链表中节点位置
        if edgeList.edges != nil {                                        ///   如果存在 edges.append else = [edges]
            edgeList.addEdge(edge)
        } else {
            edgeList.edges = [edge]
        }
    }
    open override func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }
    override open func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        guard let edges = adjacencyList[sourceVertex.index].edges else {
            return nil
        }
        for edge: Edge<T> in edges where edge.to == destinationVertex {
            return edge.weight
        }
        return nil
    }
    override open func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        return adjacencyList[sourceVertex.index].edges ?? []
    }
    open override var description: String {
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

let graph = AdjacencyListGraph<String>()
let a = graph.createVertex("a")
let b = graph.createVertex("b")
let c = graph.createVertex("c")

graph.addDirectedEdge(a, to: b, withWeight: 1.0)
graph.addDirectedEdge(b, to: c, withWeight: 2.0)
graph.addDirectedEdge(a, to: c, withWeight: -5.5)

print(graph)

