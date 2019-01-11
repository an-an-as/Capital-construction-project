// swiftlint:disable identifier_name
import Foundation
open class Vertex {
    open var identifier: String                    /// 唯一节点哈希化
    open var neighbors: [(Vertex, Double)] = []    /// 临近节点和权值
    open var pathLengthFromStart = Double.infinity /// 松弛计算后的值
    open var pathVerticesFromStart: [Vertex] = []  /// 路径上各个节点
    public init(identifier: String) {
        self.identifier = identifier
    }
    open func clearCache() {
        pathLengthFromStart = Double.infinity
        pathVerticesFromStart = []
    }
}
extension Vertex: Hashable {
    open var hashValue: Int {
        return identifier.hashValue
    }
}
extension Vertex: Equatable {
    public static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
public class Dijkstra {
    private var totalVertices: Set<Vertex> ///存储图中所有节点
    public init(vertices: Set<Vertex>) {
        totalVertices = vertices
    }
    private func clearCache() {
        totalVertices.forEach { $0.clearCache() }
    }
    public func findShortestPaths(from startVertex: Vertex) {
        clearCache()///每个节点为一个class 节点间存在引用
        var totalVerticesSet = self.totalVertices
        startVertex.pathLengthFromStart = 0
        startVertex.pathVerticesFromStart.append(startVertex)
        var currentVertex: Vertex? = startVertex
        while let vertex = currentVertex { /// 只要可选项不为nil 就遍历下去
            /// 设置节点访问情况 使用未访问的节点  删除代表已尽访问过if !vertex.visited then
            totalVerticesSet.remove(vertex) ///删除访问过的节点
            let filteredNeighbors = vertex.neighbors.filter { totalVerticesSet.contains($0.0) } ///neighbors: [(Vertex, Double)] 当前节点中是否包含临接节点 true 过滤出
            for neighbor in filteredNeighbors { ///取出所有临近节点进行松弛计算 进行比较取(如果当前节点到开始的距离+权值<临近节点 那么更新临近节点)
                let neighborVertex = neighbor.0
                let weight = neighbor.1
                let theoreticNewWeight = vertex.pathLengthFromStart + weight
                if theoreticNewWeight < neighborVertex.pathLengthFromStart { ///如果松弛后的值 < 从起点到该点的距离 更新
                    neighborVertex.pathLengthFromStart = theoreticNewWeight
                    neighborVertex.pathVerticesFromStart = vertex.pathVerticesFromStart /// 把当前pathVerticesFromStart 添加到临近节点的空数组 在其后边添加
                    neighborVertex.pathVerticesFromStart.append(neighborVertex)
                }
            }
            if totalVerticesSet.isEmpty { /// 可选项为nil就停止
                currentVertex = nil
                break
            } /// 删除一个vertex  重新赋值currentVertex 其值为set中最小的 根据从起点到当前节点的值判断
            currentVertex = totalVerticesSet.min { $0.pathLengthFromStart < $1.pathLengthFromStart }
        }
    }
}
// MARK: - VERSION 2
struct ShortestPath {
    var vertices = Set<Vertex>()
}
extension ShortestPath {
    final class Vertex {
        var identifier: String
        var adjacency: [(Vertex, Double)]
        var pathFromStart: (length: Double, member: [Vertex])
        init(identifier: String) {
            self.identifier = identifier
            adjacency = [(Vertex, Double)]()
            pathFromStart.length = Double.infinity
            pathFromStart.member = [Vertex]()
        }
        func clearPathInfo() {
            pathFromStart.length = Double.infinity
            pathFromStart.member = []
        }
    }
}
extension ShortestPath.Vertex: Equatable, Hashable, CustomDebugStringConvertible {
    static func ==(lhs: ShortestPath.Vertex, rhs: ShortestPath.Vertex) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    var debugDescription: String {
        return "\(identifier)"
    }
}
extension ShortestPath {
    mutating func clear() {
        vertices.forEach { $0.clearPathInfo()}
    }
    mutating func relaxation(from source: Vertex) {
        clear()
        var currentVertex: Vertex? = source
        var tempVertices = self.vertices
        source.pathFromStart.member.append(source)
        source.pathFromStart.length = 0
        while let current_Vertex = currentVertex {
            tempVertices.remove(current_Vertex)
            for anotherVertex in current_Vertex.adjacency where tempVertices.contains(anotherVertex.0) {
                let relaxedWeight = current_Vertex.pathFromStart.length + anotherVertex.1
                if relaxedWeight < anotherVertex.0.pathFromStart.length {
                    anotherVertex.0.pathFromStart.length = relaxedWeight
                    anotherVertex.0.pathFromStart.member = current_Vertex.pathFromStart.member
                    anotherVertex.0.pathFromStart.member.append(anotherVertex.0)
                }
            }
            guard !tempVertices.isEmpty else {
                currentVertex = nil
                break
            }
            currentVertex = tempVertices.min(by: { (a, b) -> Bool in
                a.pathFromStart.length < b.pathFromStart.length
            })
        }
    }
}
let vertexA = ShortestPath.Vertex.init(identifier: "a")
let vertexB = ShortestPath.Vertex.init(identifier: "b")
let vertexC = ShortestPath.Vertex.init(identifier: "c")

vertexA.adjacency.append((vertexB, 2))
vertexB.adjacency.append((vertexC, 3))
vertexA.adjacency.append((vertexC, 1))

var path = ShortestPath()
path.vertices.insert(vertexA)
path.vertices.insert(vertexB)
path.vertices.insert(vertexC)
path.relaxation(from: vertexA)
print(vertexC.pathFromStart.member)

// MARK: - Version 3
enum Direction {
    case directed
    case unDirected
}
protocol GraphProtocol: CustomDebugStringConvertible {
    associatedtype Vertex: Hashable
    typealias Edge = (Vertex, Vertex, Double)
    var edges: [Edge] { get set }
    var vertices: [Vertex] { get set }
}
extension GraphProtocol {
    var debugDescription: String {
        var literals = ""
        edges.forEach {
            literals += "\($0.0)-\($0.1): \($0.2)\n"
        }
        return literals
    }
}
extension GraphProtocol {
    mutating func addEdge(_ source: Vertex, destination: Vertex, weight: Double, direction: Direction = .directed) {
        if !vertices.contains(source) { vertices.append(source) }
        if !vertices.contains(destination) { vertices.append(destination) }
        edges.append((source, destination, weight))
        switch direction {
        case .directed: return
        case .unDirected:
            edges.append((destination, source, weight))
        }
    }
}
extension GraphProtocol {
    mutating func DikstraShortestPath(from source: Vertex, destination: Vertex) -> (length: Double, member: [Vertex])? {
        var currentVertex: Vertex? = source
        var currentVertices = Set.init(vertices)
        var pathFromStart = [Vertex: (length: Double, member:[Vertex] )]()
        vertices.forEach { pathFromStart[$0] = (Double.infinity, []) }
        pathFromStart[source]?.length = 0
        pathFromStart[source]?.member = [source]
        while let vertex = currentVertex {
            currentVertices.remove(vertex)
            for edge in (edges.filter { $0.0 == vertex }) where currentVertices.contains(edge.1) {
                guard let source = pathFromStart[edge.0], var destination = pathFromStart[edge.1] else { return nil }
                let relaxed = source.length + edge.2
                if relaxed < destination.length {
                    destination.length = relaxed
                    destination.member = source.member
                    destination.member.append(edge.1)
                    pathFromStart[edge.1] = destination
                }
            }
            guard !currentVertices.isEmpty else {
                currentVertex = nil
                break
            }
            /// a b c  remove a   b.length = 1 c.length = infiniti
            currentVertex = currentVertices.min { pathFromStart[$0]!.length < pathFromStart[$1]!.length }
        }
        return pathFromStart[destination]
    }
}
struct Grap: GraphProtocol {
    typealias Vertex = String
    var edges: [(String, String, Double)]
    var vertices: [String]
    init() {
        edges = [Edge]()
        vertices = [String]()
    }
}
var graph = Grap()
graph.addEdge("a", destination: "b", weight: 3)
graph.addEdge("b", destination: "c", weight: 2)
graph.addEdge("a", destination: "c", weight: 1)
let result = graph.DikstraShortestPath(from: "a", destination: "c")
print(result)
