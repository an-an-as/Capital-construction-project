/// newGraph addNode <--- for in nodes[Node]
/// newGraoth.nodes[Nodes1 Nodes Nodes]     fliter condition:
///                   |     |     |         new nodeLable == oldNodeLable
///                  Node
/// createEdge sourceNode.append edge
public struct Queue<Element> {
    var array = [Element?]()
    var head = 0
}
extension Queue {
    var isEmpty: Bool {
        return head == 0
    }
    var count: Int {
        return array.count - head
    }
}
extension Queue {
    public mutating func enqueue(_ newValue: Element) {
        array.append(newValue)
    }
    public mutating func dequeue() -> Element? {
        guard head < array.count, let element = array[head] else { return nil }
        array[head] = nil
        head += 1
        if array.count > 50 && Double(head / array.count) > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        return element
    }
}
public struct UnweightGraph: Equatable {
    public private(set) var nodes = [Node]()
}
extension UnweightGraph {
    public class Node: Equatable {
        var lable: String
        var edges: [Edge]
        var visited: Bool
        init(lable: String) {
            self.lable = lable
            self.edges = [Edge]()
            self.visited = false
        }
        public static func == (lhs: UnweightGraph.Node, rhs: UnweightGraph.Node) -> Bool {
            return lhs.lable == rhs.lable
        }
        public func remove(_ edge: Edge) {
            edges.remove(at: edges.index(where: { $0 == edge })!)
        }
    }
    public struct Edge: Equatable {
        var neighborNode: Node
    }
}
extension UnweightGraph {
    func findNodeWithLable(_ lable: String) -> Node {
        return nodes.filter { $0.lable == lable }.first!
    }
    mutating func append(_ newValue: String) -> Node {
        let newNode = Node(lable: newValue)
        nodes.append(newNode)
        return newNode
    }
    mutating func addEdges(source: Node, another: Node) {
        source.edges.append(Edge(neighborNode: another))
    }
}
extension UnweightGraph {
    mutating func duplicate() -> UnweightGraph {
        var duplicated = UnweightGraph()
        nodes.forEach {
            _ = duplicated.append($0.lable)
        }
        nodes.forEach { node in
            node.edges.forEach { edge in
                let sourceNode = duplicated.findNodeWithLable(node.lable)
                let neighborNode = duplicated.findNodeWithLable(edge.neighborNode.lable)
                duplicated.addEdges(source: sourceNode, another: neighborNode)
            }
        }
        return duplicated
    }
}
extension UnweightGraph {
    mutating func breadthFirstSearchMinimumSpanningTree(source: Node) -> UnweightGraph {
        var queue = Queue<Node>()
        let sourceInMinimumSpanningTree = findNodeWithLable(source.lable)
        queue.enqueue(sourceInMinimumSpanningTree)
        sourceInMinimumSpanningTree.visited = true
        while let current = queue.dequeue() {
            for edge in current.edges {
                let neighborNode = edge.neighborNode
                if !neighborNode.visited {
                    neighborNode.visited = true
                    queue.enqueue(neighborNode)
                } else {
                    current.remove(edge)
                }
            }
        }
        return self
    }
}
extension UnweightGraph: CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = ""
        for node in nodes {
            if !node.edges.isEmpty {
                description += "[node: \(node.lable) edges: \(node.edges.map { $0.neighborNode.lable})]"
            }
        }
        return description
    }
    
}
var graph = UnweightGraph()
let nodeA = graph.append("A")
let nodeB = graph.append("B")
let nodeC = graph.append("C")
let nodeD = graph.append("D")
graph.addEdges(source: nodeA, another: nodeB)
graph.addEdges(source: nodeA, another: nodeC)
graph.addEdges(source: nodeC, another: nodeD)
let result = graph.breadthFirstSearchMinimumSpanningTree(source: nodeA)
print(result)
//[node: A edges: ["B", "C"]][node: C edges: ["D"]]
