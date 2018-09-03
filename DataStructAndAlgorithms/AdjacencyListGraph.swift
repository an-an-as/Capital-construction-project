/**
 | Operation       | Adjacency List | Adjacency Matrix |
 |-----------------|----------------|------------------|
 | Storage Space   | O(V + E)       | O(V^2)           |
 | Add Vertex      | O(1)           | O(V^2)           |
 | Add Edge        | O(1)           | O(1)             |
 | Check Adjacency | O(V)           | O(1)             |
 */
// swiftlint:disable identifier_name line_length
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
        let vertex = Vertex(data: data, index: adjacencyList.count)       ///   EdgeList [ lista vertex(data:a index:0) [edges?]-> From:a To:b Weight:1.0 From:a To:c Weight:-5.5
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
