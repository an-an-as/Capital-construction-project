///        Richard Bellman . Lester Ford  1903/US
///
///        vertex A B C D E  from:A to:E
///        iteration 1 (tiems:0..<4)
///                                ordered edges       weights          result
///        -----> D .......        A-B:6               B:6              A:0
///        |              :        A-D:7               D:7              B:6
///        |              :        B-C:5               C:11             C:4 < UPDATE
///        A ---> B ----> C        B-E:-4              E:2              D:7
///               | <----          C-B:-2              B:6  NO UPDATE   E:2
///               E                D-C:-3              C:11 -> 4
///       BC 先于 DC 确定C的值 在更新完DC 基于C的 CB需要重新relax 之后的vertex 也随之变化

///        vertex A B C D E
///        iteration 2 (tiems:0..<4)
///                                ordered edges       weights                result
///         ----> D .......        A-B:6               B:6    NO UPDATE       A:0
///        |              :        A-D:7               D:7    NO UPDATE       B:4 < UPDATE
///        |              :        B-C:5               C:4    NO UPDATE       C:4
///        A ---> B ----> C        B-E:-4              E:2    NO UPDATE       D:7
///               | <......        C-B:-2              B:6 -> 4               E:2
///               E                D-C:-3              C:4    NO UPDATE

///        vertex A B C D E
///        iteration 3 (tiems:0..<4)
///                                ordered edges       weights                       result
///         ----> D .......        A-B:6               B:4          NO UPDATE        A:0
///        |              :        A-D:7               D:7          NO UPDATE        B:4
///        |              :        B-C:5               C:4          NO UPDATE        C:4
///        A ---> B ----> C        B-E:-4              E:2 -> -2                     D:7
///               : <......        C-B:-2              B:4          NO UPDATE        E:-2 < UPDATE
///               E                D-C:-3              C:4          NO UPDATE

///        vertex A B C D E
///        iteration 4 (tiems:0..<4)
///                                ordered edges       weights                   result     UPDATE - false
///         ----> D .......        A-B:6               B:4      NO UPDATE        A:0
///        |              :        A-D:7               D:7      NO UPDATE        B:4
///        |              :        B-C:5               C:4      NO UPDATE        C:4
///        A ---> B ----> C        B-E:-4              E:2      NO UPDATE        D:7
///               : <......        C-B:-2              B:4      NO UPDATE        E:-2
///               E                D-C:-3              C:4      NO UPDATE

///Bellman-Ford 优于Dijkstra算法的方面是边的权值可以为负数  缺点是时间复杂度过高，高达O(|V||E|).
// swiftlint:disable identifier_name line_length type_name
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
        for edge in graph.edges {
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

///Single-Source Shortest Path
protocol SSSPAlgorithm {
    associatedtype Q: Equatable, Hashable
    associatedtype P: SSSPResult
    static func apply(_ graph: AbstractGraph<Q>, source: Vertex<Q>) -> P?
}
protocol SSSPResult {
    associatedtype T: Equatable, Hashable
    func distance(to: Vertex<T>) -> Double?
    func path(to: Vertex<T>, inGraph graph: AbstractGraph<T>) -> [T]?
}
public struct BellmanFord<T> where T: Hashable {
    public typealias Q = T
}
extension BellmanFord: SSSPAlgorithm {
    /// 对于每一条边e(u, v)，如果Distant[u] + w(u, v) < Distant[v]，则另Distant[v] = Distant[u]+w(u, v)。w(u, v)为边e(u,v)的权值；
    /// 若上述操作没有对Distant进行更新，说明最短路径已经查找完毕，或者部分点不可达，跳出循环。否则执行下次循环；
    /// 第一，初始化所有点。每一个点保存一个值，表示从原点到达这个点的距离，将原点的值设为0，其它的点的值设为无穷大（表示不可达）。
    /// 第二，进行循环，循环下标为从1到n－1（n等于图中点的个数）。在循环内部，遍历所有的边，进行松弛计算。
    /// 第三，遍历途中所有的边（edge（u，v）），判断是否存在这样情况：
    /// d（v） > d (u) + w(u,v)
    /// 则返回nil，表示途中存在从源点可达的权为负的回路
    /// 负权回路
    ///
    ///    A ..5.. B        A - B   A0  B5      B5 > A-2  return nil
    /// -10:...C...:3       B - C   B5  C8
    ///                     C - A   C8  A-2
    public static func apply(_ graph: AbstractGraph<T>, source: Vertex<Q>) -> BellmanFordResult<T>? {
        let vertices = graph.vertices
        let edges = graph.edges
        var predecessors = [Int?](repeating: nil, count: vertices.count)
        var weights = Array(repeating: Double.infinity, count: vertices.count)          ///relax 把所有的边计算count - 1次 完成迭代后得出最小路径
        predecessors[source.index] = source.index      /// 最长的距离的edge 需要目标点之前所有的点遍历一次  即 index < count - 1    a .. b .. c  .. d    a -> d 最长edge: 3 检查负权回路
        weights[source.index] = 0               ///     weights内其余点默认为infi无穷大 如果不是从source原点出发 infi + 权值  > infi     :..........:
        for _ in 0 ..< vertices.count - 1 {     ///     [s t x y z]
            var weightsUpdated = false          ///     s --> t: 6   s --> y: 6          t --> x: 5      t --> y: 8      t --> z: -4
            edges.forEach { edge in             ///     x --> t: -2                      y --> x: -3     y --> z: 9
                let weight = edge.weight!       ///     z --> s: 2   z --> x: 7
                let relaxedDistance = weights[edge.vertexFrom.index] + weight   /// 松弛计算  s的值 加上 权重
                let vertextToIndex = edge.vertexTo.index                        /// 如果relaxedDistance < t 找到了一条通向t点更短的路线 更新t 的值 分拣出到t的前驱
                if relaxedDistance < weights[vertextToIndex] {                  /// 0    1    2     3    4  <-vertexToIndex     predecessprs[edge.vertexTo.index]
                    predecessors[vertextToIndex] = edge.vertexFrom.index        /// s    t    x     y    z  <-vertexFromIndex
                    weights[vertextToIndex] = relaxedDistance                   /// weight[infi,infi,infi,infi.infi]
                    weightsUpdated = true                                       /// predecessors[nil.nil,nil.nil.nil]
                }                                                               /// traver edges  $0.weight   weight[s.index] + 6 < weight[t.index] infi
            }                                                                   /// weights[$0.vertexFrom.index] + weight  <  weights[$0.vertexTo.index]
            guard weightsUpdated else {  break  }                               /// update
        }
        for edge in edges where weights[edge.vertexTo.index] > weights[edge.vertexFrom.index] + edge.weight! { return nil }
        return BellmanFordResult(predecessors: predecessors, weights: weights)  /// 边权可正可负(如有负权回路nil)
    }                                                                           /// 0   1   2   3   4 vertexToIndex
}                                                                               /// 6
public struct BellmanFordResult<T> where T: Hashable {
    fileprivate var predecessors: [Int?]
    fileprivate var weights: [Double]
}
extension BellmanFordResult: SSSPResult {
    public func distance(to: Vertex<T>) -> Double? {
        let distance = weights[to.index]
        guard distance != Double.infinity else { return nil }
        return distance
    }
    public func path(to: Vertex<T>, inGraph graph: AbstractGraph<T>) -> [T]? {
        guard weights[to.index] != Double.infinity else { return nil }
        guard let path = recursePath(to: to, inGraph: graph, path: [to]) else { return nil }
        return path.map { vertex in return vertex.data }
    /// vertextToIndex = edge.vertexTo.index
    /// predecessors[vertextToIndex] = edge.vertexFrom.index  通过B的下标返回A的下标 目标节点to 的前驱下标from = predecessor[to.index]-> 得出前驱节点 vertices[from]
    fileprivate func recursePath(to: Vertex<T>, inGraph graph: AbstractGraph<T>, path: [Vertex<T>]) -> [Vertex<T>]? {
        guard let predecessorIdx = predecessors[to.index] else { return nil } /// 目标to 在vertices中的index 通过递归从后往前
        let predecessor = graph.vertices[predecessorIdx]                      /// vertices   [0,index ]
        if predecessor.index == to.index { return [ to ]}                     /// predecesspr[0,to.index ] 两个数组count相同 =vertices.count
        guard let buildPath = recursePath(to: predecessor, inGraph: graph, path: path) else { return nil }
        return buildPath + [ to ]
    }
}
let graph = AdjacencyMatrixGraph<String>()
let s = graph.createVertex("s")
let t = graph.createVertex("t")
let x = graph.createVertex("x")
let y = graph.createVertex("y")
let z = graph.createVertex("z")

graph.addDirectedEdge(s, to: t, withWeight: 6)   ///
graph.addDirectedEdge(s, to: y, withWeight: 7)   ///
graph.addDirectedEdge(t, to: x, withWeight: 5)   ///
graph.addDirectedEdge(t, to: y, withWeight: 8)   ///
graph.addDirectedEdge(t, to: z, withWeight: -4)  ///
graph.addDirectedEdge(x, to: t, withWeight: -2)  ///
graph.addDirectedEdge(y, to: x, withWeight: -3)  ///
graph.addDirectedEdge(y, to: z, withWeight: 9)   ///
graph.addDirectedEdge(z, to: s, withWeight: 2)   ///
graph.addDirectedEdge(z, to: x, withWeight: 7)   ///

let result = BellmanFord<String>.apply(graph, source: s)!
let path = result.path(to: z, inGraph: graph)
print(path)

var arr = [Double](repeatElement(Double.infinity, count: 10))
let flag = arr[0] + 1 < arr[1] // false
let flag2 = arr[0] == arr[1]   // true
print(flag2)
// MARK: - Version: 2
public struct Vertex<T: Hashable>: Equatable {
    var data: T
    var indexInMarix: Int
}
public struct Edge<T: Hashable>: Equatable {
    var vertexFrom: Vertex<T>
    var vartexTo: Vertex<T>
    var weight: Double?
}
public struct AdjacencyMatrixGraph<T: Hashable>: Equatable {
    typealias ColumnVertices = [Double?]
    var matrix = [ColumnVertices]()
    var vertices = [Vertex<T>]()
}
extension AdjacencyMatrixGraph {
    var edges: [Edge<T>] {
        var temp = [Edge<T>]()
        for columnIndex in 0..<matrix.count {
            for rowIndex in 0..<matrix.count {
                if let weight = matrix[columnIndex][rowIndex] {
                    temp.append(Edge(vertexFrom: vertices[columnIndex], vartexTo: vertices[rowIndex], weight: weight))
                }
            }
        }
        return temp
    }
}
extension AdjacencyMatrixGraph {
    mutating func createVertex(_ newValue: T) -> Vertex<T> {
        let matchingVertex = vertices.filter { $0.data == newValue }
        if matchingVertex.count > 0 {
            return matchingVertex.last!
        }
        for columnIndex in 0..<matrix.count {
            matrix[columnIndex].append(nil)
        }
        let newVertex = Vertex(data: newValue, indexInMarix: matrix.count)
        let newRow = ColumnVertices(repeating: nil, count: matrix.count + 1)
        vertices.append(newVertex)
        matrix.append(newRow)
        return newVertex
    }
}
extension AdjacencyMatrixGraph {
    mutating func addDirectEdge(lhs: Vertex<T>, rhs: Vertex<T>, weight: Double?) {
        matrix[lhs.indexInMarix][rhs.indexInMarix] = weight
    }
}
extension AdjacencyMatrixGraph {
    func getWeight(source: Vertex<T>, destination: Vertex<T>) -> Double? {
        return matrix[source.indexInMarix][destination.indexInMarix]
    }
}                                                                               /// predecessor A -> B  source = "A" indexInMarix = 0 weight = 2  "B" indexInMatrix = 1
extension AdjacencyMatrixGraph {                                                /// 0   1   2      --->   0   1   2
    func apply(source: Vertex<T>) -> BellmanFordResult<T>? {                    /// 0   nil nil               0          vertexFromIndex
        var predecessors = [Int?](repeating: nil, count: vertices.count)        ///
        var weights = Array(repeating: Double.infinity, count: vertices.count)  /// weight               A   B   C  A - C 5 false
        predecessors[source.indexInMarix] = source.indexInMarix                 /// 0   1   2      --->  0   1   2
        weights[source.indexInMarix] = 0                                        /// 0  infi infi         0   2   3      vertexToIndex
        for _ in 0..<vertices.count - 1 {                                       /// count - 1
            var weightUpdated = false
            edges.forEach {                                                     /// edges[A-B:2, B-C:1, A-C:5]
                let weight = $0.weight!
                let relaxDistance = weights[$0.vertexFrom.indexInMarix] + weight/// 100 < infi        true
                if relaxDistance < weights[$0.vartexTo.indexInMarix] {          /// infi + 100 < infi false
                    predecessors[$0.vartexTo.indexInMarix] = $0.vertexFrom.indexInMarix
                    weights[$0.vartexTo.indexInMarix] = relaxDistance
                    weightUpdated = true
                }
            }
            guard weightUpdated else { break }
        }
        for edge in edges where weights[edge.vartexTo.indexInMarix] > weights[edge.vertexFrom.indexInMarix] + edge.weight! { return nil } /// 是否存在负权回路
        return BellmanFordResult(predecessors: predecessors, weights: weights)
    }
}
public struct BellmanFordResult<T: Hashable> {
    fileprivate var predecessors: [Int?]
    fileprivate var weights: [Double]
}
extension BellmanFordResult {
    func distance(vertexTo: Vertex<T>) -> Double? {
        let distance = weights[vertexTo.indexInMarix]
        guard distance != Double.infinity else { return nil }
        return distance
    }
    func recursePathTo(vertex: Vertex<T>, graph: AdjacencyMatrixGraph<T>) -> [Vertex<T>]? {
        guard weights[vertex.indexInMarix] != Double.infinity else { return nil }
        guard let predecessorIndex = predecessors[vertex.indexInMarix] else { return nil }
        let prevVertex = graph.vertices[predecessorIndex]
        if prevVertex.indexInMarix == vertex.indexInMarix { return [vertex] }                    /// predecessor    A    B    C
        guard let buildPath = recursePathTo(vertex: prevVertex, graph: graph) else { return nil }///                0    1    2
        return buildPath + [vertex]                                                              ///                0    0    1
    }
}
var graph = AdjacencyMatrixGraph<String>()
let vertexA = graph.createVertex("A")
let vertexB = graph.createVertex("B")
let vertexC = graph.createVertex("C")
///       2
graph.addDirectEdge(lhs: vertexA, rhs: vertexB, weight: 2)  ///   A ----- B
graph.addDirectEdge(lhs: vertexB, rhs: vertexC, weight: 1)  ///   |       |  1
graph.addDirectEdge(lhs: vertexA, rhs: vertexC, weight: 5)  ///   5------ C

let bellManResult = graph.apply(source: vertexA)
let vertexArray = bellManResult?.recursePathTo(vertex: vertexC, graph: graph)
vertexArray?.forEach { print($0.data) } //A B C

// MARK: - Version: 3
enum Direction {
    case directed
    case unDirected
}
struct AdjacencyMatrix<Vertex: Hashable, Weight: Comparable> {
    typealias Edge = (Vertex, Vertex, Weight)
    var edges = [Edge]()
    var vertices = Set<Vertex>()
    var matrix = [[Weight?]]()
    var index = [Vertex: Int]()
}
extension AdjacencyMatrix {
    mutating func addVertex(_ vertex: Vertex) {
        matrix.indices.forEach {
            matrix[$0].append(nil)
        }
        index[vertex] = matrix.count
        let newRow = [Weight?](repeating: nil, count: matrix.count.advanced(by: 1))
        matrix.append(newRow)
    }
    mutating func addEdge(_ source: Vertex, destination: Vertex, weight: Weight, direction: Direction = .directed) {
        if vertices.insert(source).inserted { addVertex(source) }
        if vertices.insert(destination).inserted { addVertex(destination) }
        guard let sourceIndex = index[source], let destinationIndex = index[destination] else { return }
        matrix[sourceIndex][destinationIndex] = weight
        edges.append((source, destination, weight))
        switch direction {
        case.directed: return
        case.unDirected:
            edges.append((destination, source, weight))
            matrix[destinationIndex][sourceIndex] = weight
        }
    }
    mutating func getWeight(_ source: Vertex, destination: Vertex) -> Weight? {
        guard let sourceIndex = index[source], let destinationIndex = index[destination] else { return nil }
        return matrix[sourceIndex][destinationIndex]
    }
}
extension AdjacencyMatrix: CustomDebugStringConvertible {
    var debugDescription: String {
        var literal = ""
        edges.forEach {
            literal += "\($0.0)-\($0.1): \($0.2)\n"
        }
        return literal
    }
}
struct ShortestPath {
    static var index = [String: Int]()
    static var parentIndex = [Int?]()
    static var vertices = [String?]()
    static var weights = [Double]()
    static func relaxion(graph: AdjacencyMatrix<String, Int>, source: String, destination: String) -> [String]? {
        self.vertices = [String?](repeating: nil, count: graph.vertices.count)
        for (cursor, element) in graph.vertices.enumerated() {
            index[element] = cursor
            self.vertices[cursor] = element
        }
        parentIndex = [Int?](repeating: nil, count: graph.vertices.count)
        weights = [Double](repeating: Double.infinity, count: graph.vertices.count)
        /// 递归到源点的的前驱下标 就是源点本身
        parentIndex[index[source] ?? index.count] = index[source] ?? index.count
        weights[index[source] ?? index.count] = 0
        for _ in 1...graph.vertices.count - 1 {
            var weightsUpdated = false
            graph.edges.forEach { /// 遍历到source开始松弛计算
                let edge = (sourceIndex: index[$0.0] ?? index.count, destinationIndex: index[$0.1] ?? index.count, weight: $0.2)
                let relaxedDistance = weights[edge.sourceIndex] + Double(edge.weight)
                if relaxedDistance < weights[edge.destinationIndex] {
                    parentIndex[edge.destinationIndex] = edge.sourceIndex
                    weights[edge.destinationIndex] = relaxedDistance
                    weightsUpdated = true
                }
            }
            guard weightsUpdated else {  break  }
        }
        graph.edges.forEach {
            let edge = (sourceIndex: index[$0.0] ?? index.count, destinationIndex: index[$0.1] ?? index.count, weight: $0.2)
            if weights[edge.sourceIndex] > weights[edge.destinationIndex] + Double(edge.weight) { return }
        }
        return recursePathTo(vertex: destination)
    }
}
extension ShortestPath {
    static func recursePathTo(vertex: String) -> [String]? {
        /// 该节点已经经过松弛计算
        guard weights[index[vertex] ?? index.count] != Double.infinity else { return nil }
        /// parentIndex记录的是松弛的前驱节点 递归到 a source节点 已经初始化为index[sorce]
        guard let parentIndex = parentIndex[index[vertex]!] else { return nil }
        /// 如果parentIndex(a) -> nil parentVertex = []
        let parentVertex = self.vertices[parentIndex]!
        if parentIndex == index[vertex] ?? index.count { return [vertex] }
        guard let buildPath = recursePathTo(vertex: parentVertex) else { return nil }
        return buildPath + [vertex]
    }
}
var matrix = AdjacencyMatrix<String, Int>()
matrix.addEdge("a", destination: "b", weight: 1)
matrix.addEdge("a", destination: "c", weight: 20)
matrix.addEdge("b", destination: "c", weight: 3, direction: .unDirected)
print(matrix)
print(matrix.getWeight("c", destination: "b")!)
let result = ShortestPath.relaxion(graph: matrix, source: "a", destination: "c")
print(result)

// MARK: - Version 4
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
    mutating func BellmanShortestPath(from source: Vertex, destination: Vertex) -> [Vertex]? {
        var precusor = [Int?](repeating: nil, count: vertices.count)
        var weight = [Double](repeating: Double.infinity, count: vertices.count)
        getVertexIndex(source).map {
            precusor[$0] = $0
            weight[$0] = 0
        }
        for _ in 1..<vertices.count {
            var updated = false
            edges.forEach {
                guard let edgeIndex = getEdgeIndex($0) else { return }
                let relaxed = weight[edgeIndex.source] + $0.2
                if relaxed < weight[edgeIndex.destination] {
                    weight[edgeIndex.destination] = relaxed
                    precusor[edgeIndex.destination] = edgeIndex.source
                    updated = true
                }
            }
            /// 出现负权回路
            guard updated else { break }
        }
        ///检查是否存在负权回路
        edges.forEach {
            guard let edgeIndex = getEdgeIndex($0) else { return }
            guard weight[edgeIndex.source] < weight[edgeIndex.destination] + $0.2 else { return }
        }
        return getShorestPath(destination: destination, relaxedWeight: weight, precursor: precusor)
    }
}
extension GraphProtocol {
    private func getVertexIndex(_ vertex: Vertex) -> Int? {
        for (index, element) in vertices.enumerated() where element == vertex { return index }
        return nil
    }
    private func getEdgeIndex(_ edge: Edge) -> (source: Int, destination: Int)? {
        guard let indexA = getVertexIndex(edge.0), let indexB = getVertexIndex(edge.1) else { return nil }
        return (indexA, indexB)
    }
    private func getShorestPath(destination: Vertex, relaxedWeight: [Double], precursor: [Int?] ) -> [Vertex]? {
        ///判断destination是否已经松弛
        guard let indexB = getVertexIndex(destination), relaxedWeight[indexB] != Double.infinity else { return nil }
        ///经过松弛edge的source节点
        guard let indexA = precursor[indexB] else { return nil }
        ///如果相等为起始点
        if indexA == indexB { return [vertices[indexA]] }
        guard let path = getShorestPath(destination: vertices[indexA], relaxedWeight: relaxedWeight, precursor: precursor) else {return nil}
        return path + [destination]
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

class Graph: GraphProtocol {
    typealias Vertex = String
    var edges: [(String, String, Double)]
    var vertices: [String]
    init() {
        edges = [Edge]()
        vertices = [String]()
    }
}
var graph = Graph()
graph.addEdge("a", destination: "b", weight: 1)
graph.addEdge("b", destination: "c", weight: 2)
graph.addEdge("a", destination: "c", weight: 110)
let result = graph.BellmanShortestPath(from: "a", destination: "c")
print(result)
