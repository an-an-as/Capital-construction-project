/// newGraph addNode <--- for in nodes[Node]
/// newGraoth.nodes[Nodes1 Nodes Nodes]     fliter condition:
///                   |     |     |         new nodeLable == oldNodeLable
///                  Node
/// createEdge sourceNode.append edge
public struct UnweightGraph: Equatable {
    public private(set) var nodes = [Node]()
}
extension UnweightGraph {
    public class Node: Equatable {
        var lable: String
        var edges: [Edge]
        init(lable: String) {
            self.lable = lable
            self.edges = [Edge]()
        }
        public static func == (lhs: UnweightGraph.Node, rhs: UnweightGraph.Node) -> Bool {
            return lhs.lable == rhs.lable
        }
    }
    public struct Edge {
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
