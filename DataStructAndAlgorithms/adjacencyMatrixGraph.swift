/*
 | Operation       | Adjacency List | Adjacency Matrix |
 |-----------------|----------------|------------------|
 | Storage Space   | O(V + E)       | O(V^2)           |
 | Add Vertex      | O(1)           | O(V^2)           |
 | Add Edge        | O(1)           | O(1)             |
 | Check Adjacency | O(V)           | O(1)             |
 */
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
public struct Edge<T>: Equatable where T: Hashable {
    public let vertexFrom: Vertex<T>
    public let vertexTo: Vertex<T>
    public let weight: Double?
}
extension Edge: CustomStringConvertible {
    public var description: String {
        guard let unwrappedWeight = weight else {
            return "\(vertexFrom.description) -> \(vertexTo.description)"
        }
        return "\(vertexFrom.description) -(\(unwrappedWeight))-> \(vertexTo.description)"
    }
}

open class AbstractGraph<T>: CustomStringConvertible where T: Hashable {
    public required init() {}
    public required init(fromGraph graph: AbstractGraph<T>) {
        for edge in graph.edges { /// 遍历edge [Edge] -> vertexFrom:Vertex vertexTo.data -> data index
            ///获取edge数组每个元素内两节点的信息
            let from = createVertex(edge.vertexFrom.data)
            let to = createVertex(edge.vertexTo.data)
            addDirectedEdge(from, to: to, withWeight: edge.weight) ///根据节点具体信息创建
        }
    }
    open var description: String { fatalError("abstract property accessed") }
    open var vertices: [Vertex<T>] { fatalError("abstract property accessed")}
    open var edges: [Edge<T>] { fatalError("abstract property accessed") }
    
    open func createVertex(_ data: T) -> Vertex<T> { fatalError("abstract function called") }
    open func addDirectedEdge(_ from: Vertex<T>, to vertext: Vertex<T>, withWeight weight: Double?) {
        fatalError("abstract function called")
    }
    open func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        fatalError("abstract function called")
    }
    open func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        fatalError("abstract function called")
    }
}
open class AdjacencyMatrixGraph<T>: AbstractGraph<T> where T: Hashable {
    fileprivate var adjacencyMatrix: [[Double?]] = []
    fileprivate var _vertices: [Vertex<T>] = []
    public required init() {
        super.init()
    }
    public required init(fromGraph graph: AbstractGraph<T>) {
        super.init(fromGraph: graph)
    }
    open override var vertices: [Vertex<T>] {
        return _vertices
    }
    ///将二维数组内的内容添加到edges数组内
    open override var edges: [Edge<T>] {
        var edges = [Edge<T>]()
        for row in 0 ..< adjacencyMatrix.count {
            for column in 0 ..< adjacencyMatrix.count {
                if let weight = adjacencyMatrix[row][column] {
                    edges.append(Edge(vertexFrom: vertices[row], vertexTo: vertices[column], weight: weight))
                }
            }
        }
        return edges
    }
    /// 每加入一个节点 矩阵增加
    open override func createVertex(_ data: T) -> Vertex<T> {
        let matchingVertices = vertices.filter { $0.data == data }
        if matchingVertices.count > 0 {
            return matchingVertices.last!
        }
        let vertex = Vertex(data: data, index: adjacencyMatrix.count)
        /// adj每个元素内添加 nil
        for index in 0 ..< adjacencyMatrix.count {
            adjacencyMatrix[index].append(nil)
            ///     新加入一个元素 在每个元素的末尾添加nil
            ///     a0         a0  b1          a0  b1  c2
            /// a0  nil        nil nil         nil nil nil
            /// b1             nil nil         nil nil nli
            /// c2                             nil nil nli
        }   ///
        /// 添加一个元素创建一行
        let newRow = [Double?](repeating: nil, count: adjacencyMatrix.count + 1)
        adjacencyMatrix.append(newRow)
        _vertices.append(vertex)
        return vertex
    }
    // []                     [[nil]]                 [[nil,nil],[nil,nil]]
    // adj.count = 0          add.count = 1           add.count =  2
    // data:a  index:0        data:b  index: 1        data:c   index: 2
    // 初次 0..<0 返回空        0..<1                   0..<2
    //                        [[nil,nil]]             [[nil,nil,nil],[nil,nil.nil],[nil,nil,nil]]        adjacency[index].append(nil)
    // [nil]                  [nil nil]                                                                  newRow = [](repeat:nil,count:adj.count + 1)
    // [[nil]]                [[nil nil],[nil,nil]]                                                      adjacency
    
    open override func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
        adjacencyMatrix[from.index][to.index] = weight
    }
    open override func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }
    open override func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
        return adjacencyMatrix[sourceVertex.index][destinationVertex.index]
    }
    open  func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
        ///一个节点内的各个分支
        var outEdges = [Edge<T>]()
        let fromIndex = sourceVertex.index
        for column in 0..<adjacencyMatrix.count {
            if let weight = adjacencyMatrix[fromIndex][column] {
                outEdges.append(Edge(vertexFrom: sourceVertex, vertexTo: vertices[column], weight: weight))
            }
        }
        return outEdges
    }
    open override var description: String {
        var grid = [String]()
        let nnnn = self.adjacencyMatrix.count
        for iii in 0..<nnnn {
            var row = ""
            for jjj in 0..<nnnn {
                if let value = self.adjacencyMatrix[iii][jjj] {
                    let number = NSString(format: "%.1f", value)
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
let graph = AdjacencyMatrixGraph<String>()
let aaa = graph.createVertex("a")
let bbb = graph.createVertex("b")
let ccc = graph.createVertex("c")
graph.addUndirectedEdge((aaa, bbb), withWeight: 1)
graph.addDirectedEdge(aaa, to: ccc, withWeight: 2.0)
graph.edges.forEach{ print($0.weight) }

/**/
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
    public func peek() -> T? {
        return array.first
    }
}
func breadthFirstSearch(_ graph: Graph, source: Node) -> [String] {
    var queue = Queue<Node>()
    queue.enqueue(source)
    
    var nodesExplored = [source.label]
    source.visited = true
    
    while let current = queue.dequeue() {
        for edge in current.neighbors {
            let neighborNode = edge.neighbor
            if !neighborNode.visited {
                queue.enqueue(neighborNode)
                neighborNode.visited = true
                nodesExplored.append(neighborNode.label)
            }
        }
    }
    
    return nodesExplored
}
