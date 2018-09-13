v/**
 | Operation       | Adjacency List | Adjacency Matrix |
 |-----------------|----------------|------------------|
 | Storage Space   | O(V + E)       | O(V^2)           |
 | Add Vertex      | O(1)           | O(V^2)           |
 | Add Edge        | O(1)           | O(1)             |
 | Check Adjacency | O(V)           | O(1)             |
 
 + 邻接矩阵是表示顶点之间相邻关系的矩阵,图的物理存储结构可以分为邻接矩阵和邻接链表的形式。
 + 图的搜索分为广度优先搜索（BSF -- Breadth First Search）和深度优先搜索（DFS -- Depth First Search）
 + 用一个一维数组存放图中所有顶点数据,用一个二维数组存放顶点间关系（边或弧）的数据,这个二维数组称为邻接矩阵
 + 邻接矩阵又分为有向图邻接矩阵和无向图邻接矩阵
 + 无向图的邻接矩阵一定是对称的，而有向图的邻接矩阵不一定对称。因此，用邻接矩阵来表示一个具有n个顶点的有向图时需要n^2个单元来存储邻接矩阵
 + 对有n个顶点的无向图则只存入上（下）三角阵中剔除了左上右下对角线上的0元素后剩余的元素，故只需1+2+...+(n-1)=n(n-1)/2个单元
 + 无向图邻接矩阵的第i行（或第i列）非零元素的个数正好是第i个顶点的度。
 + 有向图邻接矩阵中第i行非零元素的个数为第i个顶点的出度，第i列非零元素的个数为第i个顶点的入度，第i个顶点的度为第i行与第i列非零元素个数之和
 + 用邻接矩阵表示图，很容易确定图中任意两个顶点是否有边相连
 */
import Foundation
public struct Vertex<T>: Equatable where T: Hashable {        ///       A ----- E
    public var data: T                                        ///       |       | Edge-weight: option
    public let columIndex: Int                                ///       B - C - D
}
public struct Edge<T>: Equatable where T: Hashable {          ///         A   B   C
    public let vertexFrom: Vertex<T>                          ///       A     1            A - B: 1
    public let vertexTo: Vertex<T>                            ///       B 1       2        B - A: 1
    public let weight: Double?                                ///       C     2            B - C: 2
}                                                             ///                          C - B: 2
public struct AdjacencyMatrixGraph<T: Hashable> {
    typealias ColumnVertice = [Double?]
    fileprivate var adjacencyMatrix = [ColumnVertice]()       /// 记录所有 weight
    fileprivate var vertices = [Vertex<T>]()                  /// 记录所有 vertices
}
extension AdjacencyMatrixGraph {                              /// 取出weight的同时 根据vertices的Index建立Edges
    var edges: [Edge<T>] {
        var edges = [Edge<T>]()
        for columnIndex in 0 ..< adjacencyMatrix.count {
            for rowIndex in 0 ..< adjacencyMatrix.count {
                if let weight = adjacencyMatrix[columnIndex][rowIndex] {
                    edges.append(Edge(vertexFrom: vertices[columnIndex], vertexTo: vertices[rowIndex], weight: weight))
                }
            }
        }
        return edges
    }
}
extension AdjacencyMatrixGraph {
    mutating func createVertex(_ data: T) -> Vertex<T> {
        let matchingVertices = vertices.filter { $0.data == data }
        if matchingVertices.count > 0 {                       ///  nil      forin    nil nil    VertexColumnIndex: 0  Vertices[V0,V1]
            return matchingVertices.last!                     ///  ------>  newRow   nil nil    VertexColumnIndex: 1
        }
        let vertex = Vertex(data: data, columIndex: adjacencyMatrix.count)
        for columnVertexIndex in 0 ..< adjacencyMatrix.count {
            adjacencyMatrix[columnVertexIndex].append(nil)
        }
        let newRow = ColumnVertice(repeating: nil, count: adjacencyMatrix.count + 1)
        adjacencyMatrix.append(newRow)
        vertices.append(vertex)
        return vertex
    }
}
extension AdjacencyMatrixGraph {
    mutating func addDirectedEdge(lhs: Vertex<T>, rhs: Vertex<T>, withWeight weight: Double?) {
        adjacencyMatrix[lhs.columIndex][rhs.columIndex] = weight
    }
    mutating func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        addDirectedEdge(lhs: vertices.0, rhs: vertices.1, withWeight: weight)
        addDirectedEdge(lhs: vertices.1, rhs: vertices.0, withWeight: weight)
    }
}
extension AdjacencyMatrixGraph {
    mutating func weightFrom(_ sourceVertex: Vertex<T>, to Vertex: Vertex<T>) -> Double? {
        return adjacencyMatrix[sourceVertex.columIndex][destinationVertex.columIndex]
    }
}
extension AdjacencyMatrixGraph {
    func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        var outEdges = [Edge<T>]()
        let fromIndex = sourceVertex.columIndex
        for column in 0..<adjacencyMatrix.count {
            if let weight = adjacencyMatrix[fromIndex][column] {
                outEdges.append(Edge(vertexFrom: sourceVertex, vertexTo: vertices[column], weight: weight))
            }
        }
        return outEdges
    }
}
extension AdjacencyMatrixGraph: CustomDebugStringConvertible {
    public var debugDescription: String {
        var grid = [String]()
        let matrixCount = self.adjacencyMatrix.count
        for columnIndex in 0..<matrixCount {
            var row = ""
            for rowIndex in 0..<matrixCount {
                if let value = self.adjacencyMatrix[columnIndex][rowIndex] {
                    let number = String(format: "%.1f", value)
                    row += "\(value >= 0 ? " " : "")\(number) "
                } else {
                    row += "  ø  "
                }
            }
            grid.append(row)
        }
        return grid.joined(separator: "\n")
    }
}
var graph = AdjacencyMatrixGraph<String>()
let aaa = graph.createVertex("a")
let bbb = graph.createVertex("b")
let ccc = graph.createVertex("c")
graph.addUndirectedEdge((aaa, bbb), withWeight: 1)
graph.addDirectedEdge(lhs: aaa, rhs: ccc, withWeight: 2.0)
print(graph.debugDescription)
print(graph.weightFrom(aaa, to: ccc)!)

public struct Queue<T> {
    private var operation = [T]()
    private var storage = [T]()
}
extension Queue {
    var count: Int {
        return storage.count + operation.count
    }
    var isEmpty: Bool {
        return operation.isEmpty && storage.isEmpty
    }
}
extension Queue {
    public mutating func enQueue(_ newElement: T) {
        storage.append(newElement)
    }
    public mutating func deQueue() -> T? {
        if operation.isEmpty {
            operation = storage.reversed()
            storage.removeAll()
        }
        return operation.popLast()
    }
}
/************   version 2 ***************/
import Foundation
public struct Vertex<T: Hashable>: Equatable {
    var data: T
    var index: Int
}
public struct Edge<T: Hashable>: Equatable {
    var vertexFrom: Vertex<T>
    var vartexTo: Vertex<T>
    var weight: Double?
}
public struct AdjacencyMatrixGraph<T: Hashable> {
    typealias ColumVertices = [Double?]
    private var matrix = [ColumVertices]()
    private var vertices = [Vertex<T>]()
}
extension AdjacencyMatrixGraph {
    var edges: [Edge<T>] {
        var edges = [Edge<T>]()
        for colum in 0..<matrix.count {
            for index in 0..<matrix.count {
                if let weight = matrix[colum][index] {
                    edges.append(Edge(vertexFrom: vertices[colum], vartexTo: vertices[index], weight: weight))
                }
            }
        }
        return edges
    }
}
extension AdjacencyMatrixGraph {
    mutating func createVertix(_ data: T) -> Vertex<T> {
        let matchingVertices = vertices.filter { $0.data == data }
        if matchingVertices.count > 0 {
            return matchingVertices.last!
        }
        for index in 0..<matrix.count {
            matrix[index].append(nil)
        }
        let newVertex = Vertex(data: data, index: matrix.count)
        let newRow = ColumVertices(repeating: nil, count: matrix.count + 1)
        matrix.append(newRow)
        vertices.append(newVertex)
        return newVertex
    }
}
extension AdjacencyMatrixGraph {
    mutating func addDirectEdge(lhs: Vertex<T>, rhs: Vertex<T>, weight: Double?) {
        matrix[lhs.index][rhs.index] = weight
    }
    mutating func addUnDirectEdge(vertices: (Vertex<T>, Vertex<T>), weight: Double?) {
        addDirectEdge(lhs: vertices.0, rhs: vertices.1, weight: weight)
        addDirectEdge(lhs: vertices.1, rhs: vertices.0, weight: weight)
    }
}
extension AdjacencyMatrixGraph {
    mutating func weightFrom(_ source: Vertex<T>, to destination: Vertex<T>) -> Double? {
        return matrix[source.index][destination.index]
    }
}
extension AdjacencyMatrixGraph {
    func edgesFrom(source: Vertex<T>) -> [Edge<T>] {
        var outEdges = [Edge<T>]()
        let sourceVertxtIndex = source.index
        for index in 0..<matrix.count {
            if let weight = matrix[sourceVertxtIndex][index] {
                outEdges.append(Edge(vertexFrom: source, vartexTo: vertices[index], weight: weight))
            }
        }
        return outEdges
    }
}
extension AdjacencyMatrixGraph: CustomDebugStringConvertible {
    public var debugDescription: String {
        var grid = [String]()
        let matrixCount = self.matrix.count
        for columnIndex in 0..<matrixCount {
            var row = ""
            for rowIndex in 0..<matrixCount {
                if let value = self.matrix[columnIndex][rowIndex] {
                    let number = String(format: "%.1f", value)
                    row += "\(value >= 0 ? " " : "")\(number) "
                } else {
                    row += "  ø  "
                }
            }
            grid.append(row)
        }
        return grid.joined(separator: "\n")
    }
}
var graph = AdjacencyMatrixGraph<String>()
let vertexA = graph.createVertix("a")
let vertexB = graph.createVertix("b")
let vertexC = graph.createVertix("c")
graph.addUnDirectEdge(vertices: (vertexA, vertexB), weight: 1)
graph.addDirectEdge(lhs: vertexA, rhs: vertexC, weight: 2.0)
print(graph.debugDescription)
print(graph.weightFrom(vertexA, to: vertexB)!)
 /***************** version 2 ******************/
import Foundation
public struct AdjacencyMatrixGraph<T: Hashable> {
    typealias ColumnVertices = [Double?]
    fileprivate var matrix = [ColumnVertices]()
    fileprivate var vertices = [Vertex<T>]()
}
extension AdjacencyMatrixGraph {
    public struct Vertex<T: Hashable>: Equatable {
        var data: T
        let indexInMatrix: Int
    }
    public struct Edge<T: Hashable>: Equatable {
        let vertexL: Vertex<T>
        let vertexR: Vertex<T>
        let weight: Double?
    }
}
extension AdjacencyMatrixGraph {
    var edges: [Edge<T>] {
        var temp = [Edge<T>]()
        for columnIndex in 0..<matrix.count {
            for rowIndex in 0..<matrix.count {
                if let weight = matrix[columnIndex][rowIndex] {
                    temp.append(Edge(vertexL: vertices[columnIndex], vertexR: vertices[rowIndex], weight: weight))
                }
            }
        }
        return temp
    }
}
extension AdjacencyMatrixGraph {
    public mutating func createVertexAndInitialMatrix(_ newData: T) -> Vertex<T> {
        let matchingVertex = vertices.filter { $0.data == newData }
        if matchingVertex.count > 0 {
            return matchingVertex.last!
        }
        for index in 0..<matrix.count {
            matrix[index].append(nil)
        }
        let newVertex = Vertex(data: newData, indexInMatrix: matrix.count)
        let newRow = ColumnVertices(repeating: nil, count: matrix.count + 1)
        vertices.append(newVertex)
        matrix.append(newRow)
        return newVertex
    }
}
extension AdjacencyMatrixGraph {
    mutating func addDirectedEdge(lhs: Vertex<T>, rhs: Vertex<T>, weight: Double?) {
        matrix[lhs.indexInMatrix][rhs.indexInMatrix] = weight
    }
    mutating func addUndirectEdge(_ vertices: (Vertex<T>, Vertex<T>), weight: Double?) {
        addDirectedEdge(lhs: vertices.0, rhs: vertices.1, weight: weight)
        addDirectedEdge(lhs: vertices.1, rhs: vertices.0, weight: weight)
    }
}
extension AdjacencyMatrixGraph {
    func getWeight(source: Vertex<T>, destination: Vertex<T>) -> Double? {
        return matrix[source.indexInMatrix][destination.indexInMatrix]
    }
    func getEdges(from source: Vertex<T>) -> [Edge<T>] {
        var edges = [Edge<T>]()
        for rowIndex in 0..<matrix.count {
            if let weight = matrix[source.indexInMatrix][rowIndex] {
                edges.append(Edge(vertexL: vertices[source.indexInMatrix], vertexR: vertices[rowIndex], weight: weight))
            }
        }
        return edges
    }
}
var graph = AdjacencyMatrixGraph<String>()
let beijing = graph.createVertexAndInitialMatrix("北京")
let shanghai = graph.createVertexAndInitialMatrix("上海")
let shenzhen = graph.createVertexAndInitialMatrix("深圳")
graph.addDirectedEdge(lhs: beijing, rhs: shanghai, weight: 1_213)
graph.addDirectedEdge(lhs: shanghai, rhs: shenzhen, weight: 1_427)
print(graph.debugDescription)
print(graph.getWeight(source: beijing, destination: shanghai))
