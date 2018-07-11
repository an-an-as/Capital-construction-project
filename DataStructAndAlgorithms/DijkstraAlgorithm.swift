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

var vertices: Set<Vertex> = Set()

func createNotConnectedVertices() {
    //change this value to increase or decrease amount of vertices in the graph
    let numberOfVerticesInGraph = 15
    for i in 0..<numberOfVerticesInGraph {
        let vertex = Vertex(identifier: "\(i)")
        vertices.insert(vertex)
    }
}

func setupConnections() {
    for vertex in vertices {
        //the amount of edges each vertex can have
        let randomEdgesCount = arc4random_uniform(4) + 1
        for _ in 0..<randomEdgesCount {
            //randomize weight value from 0 to 9
            let randomWeight = Double(arc4random_uniform(10))
            let neighborVertex = randomVertex(except: vertex) ///获取临近的节点
            //we need this check to set only one connection between two equal pairs of vertices
            if vertex.neighbors.contains(where: { $0.0 == neighborVertex }) { ///如果存在相同节点就跳过
                continue
            }
            //creating neighbors and setting them
            let neighbor1 = (neighborVertex, randomWeight)
            let neighbor2 = (vertex, randomWeight)
            vertex.neighbors.append(neighbor1)
            neighborVertex.neighbors.append(neighbor2)
        }
    }
}

func randomVertex(except vertex: Vertex) -> Vertex {
    var newSet = vertices
    newSet.remove(vertex)///如果存在相同节点删除
    let offset = Int(arc4random_uniform(UInt32(newSet.count)))
    let index = newSet.index(newSet.startIndex, offsetBy: offset)
    return newSet[index]
}

func randomVertex() -> Vertex {
    let offset = Int(arc4random_uniform(UInt32(vertices.count)))
    let index = vertices.index(vertices.startIndex, offsetBy: offset)
    return vertices[index]
}

//initialize random graph
createNotConnectedVertices()
setupConnections()

//initialize Dijkstra algorithm with graph vertices
let dijkstra = Dijkstra(vertices: vertices)

//decide which vertex will be the starting one
let startVertex = randomVertex()

let startTime = Date()

//ask algorithm to find shortest paths from start vertex to all others
dijkstra.findShortestPaths(from: startVertex)

let endTime = Date()

print("calculation time is = \((endTime.timeIntervalSince(startTime))) sec")

//printing results
let destinationVertex = randomVertex(except: startVertex)
print(destinationVertex.pathLengthFromStart)
var pathVerticesFromStartString: [String] = []
for vertex in destinationVertex.pathVerticesFromStart {
    pathVerticesFromStartString.append(vertex.identifier)
}

print(pathVerticesFromStartString.joined(separator: "->"))

