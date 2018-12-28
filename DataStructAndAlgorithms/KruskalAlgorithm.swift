struct Edge<T> {
    let vertex1: T
    let vertex2: T
    let weight: Int
}
extension Edge: CustomStringConvertible {
    var description: String {
        return "[\(vertex1)-\(vertex2): \(weight)]"
    }
}
struct Graph<T: Hashable> {
    private(set) var edgeList: [Edge<T>]
    private(set) var vertices: Set<T>
    private(set) var adjacentList: [T: [(vertex: T, weight: Int)]]
    init() {
        edgeList = [Edge<T>]()
        vertices = Set<T>()
        adjacentList = [T: [(vertex: T, weight: Int)]]()
    }
}
extension Graph: CustomDebugStringConvertible {
    var debugDescription: String {
        var description = ""
        for edge in edgeList {
            description += edge.description + "\n"
        }
        return description
    }
    mutating func addEdge(_ source: T, destionation: T, weight: Int) {
        edgeList.append(Edge(vertex1: source, vertex2: destionation, weight: weight))
        vertices.insert(source)
        vertices.insert(destionation)
        adjacentList[source] = adjacentList[source] ?? []
        adjacentList[source]?.append((vertex: destionation, weight: weight))
        adjacentList[destionation] = adjacentList[destionation] ?? []
        adjacentList[destionation]?.append((vertex: source, weight: weight))
    }
}
struct UnionFind<T: Hashable> {
    private var indexDict = [T: Int]()
    private var indexInStorage = [Int]()
    private var comboSize = [Int]()
    public init() {}
}
extension UnionFind {
    mutating func setIndexAndInitialStorage(for element: T) {
        indexDict[element] = indexInStorage.count
        indexInStorage.append(indexInStorage.count)
        comboSize.append(1)
    }
    private mutating func getInitialIndexAndTransformOnceAgainVisted(_ index: Int) -> Int {
        if indexInStorage[index] == index {                 /// 相等为初次查找该值返回其index 连通后 storage[indexB] = indexA  后续 storage[indexA] = indexC
            return index                                    /// 如果再次查找storage[index]存储新的值 变为
        } else {
            indexInStorage[index] = getInitialIndexAndTransformOnceAgainVisted(indexInStorage[index]) /// 转换为后继 a -> b 初次b记录a
            return indexInStorage[index]                                            /// a -> b -> c -> d   b再次访问后递归到d 这是b==d 就连通
        }                                                                           //  再一次访问就会变味另一端下标 递归到最后
    }
    public mutating func getIndex(_ element: T) -> Int? {
        guard let index = indexDict[element] else {return nil }
        return getInitialIndexAndTransformOnceAgainVisted(index)
    }
    mutating func isSameIndex(_ firstElement: T, secondElement: T) -> Bool {
        if let precursor = getIndex(firstElement), let follower = getIndex(secondElement) {
            return precursor == follower                /// a -> b  b存储a 再一次访问b 和dict不一致 转换为a a存储c  这时 连同b - c
        } else {
            return false
        }
    }
    mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
        guard let precursor = getIndex(firstElement), let follower = getIndex(secondElement) else { return }
        guard firstElement != secondElement else { return }
        if comboSize[precursor] > comboSize[follower] { // 后续记录
            indexInStorage[precursor] = follower
            comboSize[follower] += comboSize[precursor]
        } else {
            indexInStorage[follower] = precursor        // 初次记录
            comboSize[precursor] += comboSize[follower]
        }
    }
}
func minimumSpanningTreeKruskal<T>(graph: Graph<T>) -> (cost: Int, tree: Graph<T>) {
    var cost: Int = 0
    var tree = Graph<T>()
    let sortedEdgeListByWeight = graph.edgeList.sorted(by: { $0.weight < $1.weight })
    var unionFind = UnionFind<T>()
    for vertex in graph.vertices {
        unionFind.setIndexAndInitialStorage(for: vertex)
    }
    for edge in sortedEdgeListByWeight {
        let v1 = edge.vertex1
        let v2 = edge.vertex2
        if !unionFind.isSameIndex(v1, secondElement: v2) {
            cost += edge.weight
            tree.addEdge(edge.vertex1, destionation: edge.vertex2, weight: edge.weight)
            unionFind.unionSetsContaining(v1, and: v2)
        }
    }
    return (cost: cost, tree: tree)
}
var graph = Graph<String>()
graph.addEdge("a", destionation: "b", weight: 1)
graph.addEdge("a", destionation: "c", weight: 2)
graph.addEdge("b", destionation: "c", weight: 3)
graph.addEdge("b", destionation: "d", weight: 4)

print(graph.vertices)
let result = minimumSpanningTreeKruskal(graph: graph)
print(result.tree)
print(result.cost)
///       1
///    a ---> b
///   2|      |4
///    c      d
///
///    b -- > d: 4
///
/// vertices       a  b  c  d
/// indexDirc     [0, 1, 2, 3]
/// storage       [0, 1, 2, 3]
/// size          [1, 1, 1, 1]
///
/// sortedEdge    a-b 1
///               a-c 2
///               b-c 3
///               b-d 4
///
///           indexInStorage[second] = first
///           size[first] += size[second]
/// inStorage[a0]=0 != inStorage[b1]=1 false cost: 1    tree.addEdge a-b
/// size[a0=0]=0 !> size[b1=1]=1  storage[b0=0] = a2  size[a2=2] += size[b3=3]
/// vertices       a    b    c    d
/// indexDict     [0,   1,   2,   3]
/// storage       [0,  >0<   2,   3]   b 存储 a 的下标0
/// size          [>2<  1,   1,   1]   a 合并 b 的size1
///
/// inStorage[a0]=0 != inStorage[c2]=2 true cost: 1+2   tree.addEdge a-c
/// size[a0=0]=2 > size[c0=0]=1  storage[a2] = c3  size[c3] += size[a1]
/// vertices       a    b    c    d
/// indexDirc     [0,   1,   2,   3]
/// storage       [2,   0    2,   3]   a 存储 c 的下标0
/// size          [2,   1,  >3<   1]   c 合并 a 的size2
///
/// inStorage inStorage[b0]=2 == inStorage[c2]=2 false 不合并          b indexInDict --> 1  storage[1] = 0 != 1  a -> b 更改了b的下标为a
///                                                                                        storage[1] = storage[storage[1]] = 2
/// 查找b
/// vertices       a    b    c    d
/// indexDirc     [0,   1,   2,   3]
/// storage       [2,   2    2,   3]   a 存储 c 的下标0
/// size          [2,   1,  >3<   1]   c 合并 a 的size2
///
/// if size[first] > size[second] { indexInStorage[first] = second    1. a--->b b存储a的下标
///     size[second] += size[first]                                   2. a--->c a存储c的下标
/// } else {                                                          3. 查找b已经改变(和Dict中的index不一致) 转换为sstorage[storage[b]] a 存在两个相同下标构成回路
///     indexInStorage[second] = first
///     size[first] += size[second]
/// }
///  初次(1,1) b的size需要传递到a 后继才能继续  初次的下标通过下一个下标存储storage[b] = a 以便后续判断 -----   再一次用到b的时候则变为storage[a] 比较是否相同构成回路
///                                                                                             |                                由于按顺序从小添加, a-b a-c避免回路
///  如果 size a > c 合并到c  c > d 合并到d  有新的节点(size 默认1)就会一直传递  新的下标通过前一个下标存储 storage[a] = c  storage[c] = d
///
