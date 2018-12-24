public class Graph: CustomStringConvertible, Equatable {///    Graph  >>>nodes  addNode  addEdge  findNodeWithLable  duplicate<<<
    public private(set) var nodes: [Node]               ///
    public init() {                                     ///    Node:lable               Node             nodes:[Node]           nodes.append Node
        self.nodes = []                                 ///      /   |   \            /   |   \          Node.neighbors[Edge]
    }                                                   ///    Node Node Node      Node Node  Node1      neighbor:Node
    public func addNode(_ label: String) -> Node {      ///     |    |    |          |    |    |         sourceNode:Node1       Edge(Node2)
        let node = Node(label)                          ///                                   Node2      Node1.neighbors.append Node2(edge.neighbor)
        nodes.append(node)
        return node
    }
    public func addEdge(_ source: Node, anotherNode: Node) {
        let edge = Edge(anotherNode)
        source.adjacentEdges.append(edge)
    }
    public var description: String {
        var description = ""
        for node in nodes {
            if !node.adjacentEdges.isEmpty {
                description += "[node: \(node.label) edges: \(node.adjacentEdges.map { $0.anotherNode.label})]"
            }
        }
        return description
    }
    public func findNodeWithLabel(_ label: String) -> Node {
        return nodes.filter { $0.label == label }.first!
    }
    public func duplicate() -> Graph {
        let duplicated = Graph()
        for node in nodes {
            _ = duplicated.addNode(node.label)
        }                                                                                   /// newGraph addNode <--- for in nodes[Node]
        for node in nodes {                                                                 /// newGraoth.nodes[Nodes1 Nodes Nodes]     fliter condition:
            for edge in node.adjacentEdges {                                                ///                   |     |     |         new nodeLable == oldNodeLable
                let source = duplicated.findNodeWithLabel(node.label)                       ///                  Node
                let neighbour = duplicated.findNodeWithLabel(edge.anotherNode.label)        /// createEdge sourceNode.append edge
                duplicated.addEdge(source, anotherNode: neighbour)
            }
        }
        return duplicated
    }
}
public func == (_ lhs: Graph, rhs: Graph) -> Bool {
    return lhs.nodes == rhs.nodes
}
