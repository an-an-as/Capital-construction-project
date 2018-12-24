public class Edge: Equatable {
    public var anotherNode: Node
    public init(_ anotherNode: Node) {
        self.anotherNode = anotherNode
    }
}
public func == (_ lhs: Edge, rhs: Edge) -> Bool {
    return lhs.anotherNode == rhs.anotherNode
}
public class Node: CustomStringConvertible, Equatable {
    public var adjacentEdges: [Edge]                  ///       Node:lable     visited
    public private(set) var label: String             ///       /   |   \      adjacentEdges[edges]
    public var distance: Int?                         ///     Node Node Node   anotherNode:Node
    public var visited: Bool                          ///      |    |
    public init(_ label: String) {
        self.label = label
        adjacentEdges = []
        visited = false
    }
    public var description: String {
        if let distance = distance {
            return "Node(label: \(label), distance: \(distance))"
        }
        return "Node(label: \(label), distance: infinity)"
    }
    public var hasDistance: Bool {
        return distance != nil
    }
    public func remove(_ edge: Edge) {
        adjacentEdges.remove(at: adjacentEdges.index { $0 === edge }!)
    }
}
public func == (_ lhs: Node, rhs: Node) -> Bool {
    return lhs.label == rhs.label && lhs.adjacentEdges == rhs.adjacentEdges
}

// Graph
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
///-Version: 2
indirect enum Node<T> {
    case sourceNode(T, [Node], Int?, Bool)
    init(description: T, nodes: [Node<T>] = [], distance: Int? = nil, visted: Bool = false) {
        self = .sourceNode(description, nodes, distance, visted)
    }
}
extension Node {
    var details: (description: T, adjacentNodes: [Node], distace: Int?, visted: Bool) {
        switch self {
        case let .sourceNode(description, nodes, distace, visted):
            return (description, nodes, distace, visted)
        }
    }
}
extension Node {
    mutating func addAdjacentNode(_ another: Node<T>) {
        var nodes = details.adjacentNodes
        nodes.append(another)
        self = Node(description: details.description, nodes: nodes, distance: details.distace, visted: details.visted)
    }
}
extension Node: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(details.description)"
    }
}
struct Graph<T> {
    private(set) var nodes: [Node<T>]
}
extension Graph {
    mutating func append(_ newElement: Node<T>...) {
        newElement.forEach {
            nodes.append($0)
        }
    }
}
extension Graph: CustomDebugStringConvertible {
    var debugDescription: String {
        var description = ""
        nodes.forEach {
            description += "\($0.details.description): \($0.details.adjacentNodes.map { $0.details.description })\n"
        }
        return description
    }
}
var graph = Graph<String>.init(nodes: [])
var nodeA = Node(description: "a")
var nodeB = Node(description: "b")
var nodeC = Node(description: "c")
nodeA.addAdjacentNode(nodeB)
nodeA.addAdjacentNode(nodeC)
graph.append(nodeA, nodeB, nodeC)
print(graph)
