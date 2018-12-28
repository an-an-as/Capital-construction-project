///     1    6     4
///   a -- f -- b -- c
///             | 3
///        e -- d
///           2
///
///   c --> d 5
///   d --> f 7

/// vertices       a  c  b  c  d  e  f
/// indexDirc     [0, 1, 2, 3, 4, 5, 6]
/// storage       [0, 1, 2, 3, 4, 5, 6]
/// size          [1, 2, 3, 4 ,5, 6, 7]
///
/// sortedEdge    a-f 1
///               d-e 2
///               b-d 3
///               b-c 4
///               c-d 5
///               b-f 6
///               d-f 7
///
/// a0 != f6 false cost: 1  tree.addEdge a-f
/// union a0 < f6
/// vertices       a  c  b  c  d  e  f
/// indexDirc     [0, 1, 2, 3, 4, 5, 6]
/// storage       [0, 1, 2, 3, 4, 5, 0]
/// size          [8, 2, 3, 4 ,5, 6, 7]
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
    private var size = [Int]()
    public init() {}
}
extension UnionFind {
    mutating func setIndexAndInitialStorage(for element: T) {
        indexDict[element] = indexInStorage.count
        indexInStorage.append(indexInStorage.count)
        size.append(1)
    }
    private mutating func findElementInStorage(by index: Int) -> Int {
        if indexInStorage[index] == index {
            return index
        } else {
            indexInStorage[index] = findElementInStorage(by: indexInStorage[index])
            return indexInStorage[index]
        }
    }
    public mutating func findElementInStorage(by element: T) -> Int? {
        if let index = indexDict[element] {
            return findElementInStorage(by: index)
        } else {
            return nil
        }
    }
    mutating func isSameInStorage(_ firstElement: T, secondElement: T) -> Bool {
        if let first = findElementInStorage(by: firstElement), let second = findElementInStorage(by: secondElement) {
            return first == second
        } else {
            return false
        }
    }
    mutating func union(_ firstElement: T, secondElement: T) {
        guard let first = findElementInStorage(by: firstElement), let second = findElementInStorage(by: secondElement) else { return }
        guard firstElement != secondElement else { return }
        indexInStorage.indices.forEach {
            if indexInStorage[$0] == first { indexInStorage[$0] = second }
        }
        size[second] += size[first]
        /// indexDict "a" -> 0, "b" -> 1
        /// storage   [0, 1]               union---[1, 1]
        /// size      [1, 2]               union---[1, 3]
    }
    mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
        guard let first = findElementInStorage(by: firstElement), let second = findElementInStorage(by: secondElement) else { return }
        guard firstElement != secondElement else { return }
        if size[first] > size[second] {
            indexInStorage[first] = second
            size[second] += size[first]
        } else {
            indexInStorage[second] = first
            size[first] += size[second]                                                ///   1    6    4
        }                                                                              /// a -- f -- b -- c
    }                                                                                  ///           | 3
}                                                                                      ///      e -- d
func minimumSpanningTreeKruskal<T>(graph: Graph<T>) -> (cost: Int, tree: Graph<T>) {   ///        2
    var cost: Int = 0                                                                  ///
    var tree = Graph<T>()                                                              ///  c --> d 5
    let sortedEdgeListByWeight = graph.edgeList.sorted(by: { $0.weight < $1.weight })  ///  d --> f 7
    var unionFind = UnionFind<T>()                                                     ///
    for vertex in graph.vertices {                                                     /// vertices       a  c  b  c  d  e  f
        unionFind.setIndexAndInitialStorage(for: vertex)                               /// indexDirc     [0, 1, 2, 3, 4, 5, 6]
    }                                                                                  /// storage       [0, 1, 2, 3, 4, 5, 6]
    for edge in sortedEdgeListByWeight {                                               /// size          [1, 2, 3, 4 ,5, 6, 7]
        let v1 = edge.vertex1                                                          ///
        let v2 = edge.vertex2                                                          /// sortedEdge    a-f 1
        if !unionFind.isSameInStorage(v1, secondElement: v2) {                         ///               d-e 2
            cost += edge.weight                                                        ///               b-d 3
            tree.addEdge(edge.vertex1, destionation: edge.vertex2, weight: edge.weight)///               b-c 4
            unionFind.unionSetsContaining(v1, and: v2)                                 ///               c-d 5
        }                                                                              ///               b-f 6
    }                                                                                  ///               d-f 7
    return (cost: cost, tree: tree)                                                    ///
}                                                                                      /// a0 != f6 false cost: 1  tree.addEdge a-f
var graph = Graph<String>()                                                            /// union
graph.addEdge("a", destionation: "f", weight: 1)
graph.addEdge("d", destionation: "e", weight: 2)
graph.addEdge("b", destionation: "d", weight: 3)
graph.addEdge("b", destionation: "c", weight: 4)
graph.addEdge("c", destionation: "d", weight: 5)
graph.addEdge("b", destionation: "f", weight: 6)
graph.addEdge("d", destionation: "f", weight: 7)
print(graph.vertices)
let result = minimumSpanningTreeKruskal(graph: graph)
print(result.tree)
print(result.cost)
