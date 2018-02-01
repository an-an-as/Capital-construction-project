import Foundation
import Darwin

protocol SortedSet: BidirectionalCollection, CustomStringConvertible where Element: Comparable {
    init()
    func contains(_ element: Element) -> Bool
    mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element)
}
extension SortedSet {
    public var description: String {
        let contents = self.lazy.map { "\($0)" }.joined(separator: ", ")
        return "[\(contents)]"
    }
}

public let cacheSize: Int? = {
    var result: Int = 0
    var size = MemoryLayout<Int>.size
    let status =  sysctlbyname("hw.l1dcachesize", &result, &size, nil, 0)
    guard status != -1 else { return nil }
    return result
    
}()
public struct BTree<Element: Comparable> {
    fileprivate var root: Node
    init(order: Int) { self.root = Node(order: order) }
}
extension BTree{
    final class Node {
        let order: Int
        var mutationCount:Int64 = 0
        var elements: [Element] = []
        var children: [Node] = []
        init(order: Int) { self.order = order }
    }
}
extension BTree {
    public  init() {
        let order = (cacheSize ?? 32768) / (4 * MemoryLayout<Element>.stride)
        self.init(order: Swift.max(16, order))
    }
}
extension BTree {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root.forEach(body)
    }
}
extension BTree.Node {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        if children.isEmpty { try elements.forEach(body) }
        else {
            for i in 0 ..< elements.count {
                try children[i].forEach(body)
                try body(elements[i])
            }
            try children[elements.count].forEach(body)
        }
    }
}
extension BTree.Node{
    internal func slot(of element: Element) -> (match: Bool, index: Int) {
        var start = 0
        var end = elements.count
        while start < end {
            let mid = start + (end - start) / 2
            if elements[mid] < element {
                start = mid + 1
            }
            else {
                end = mid
            }
        }
        let match = start < elements.count && elements[start] == element
        return (match, start)
    }
}
extension BTree {
    public func contains(_ element: Element) -> Bool  {
        return root.contains(element)
    }
}
extension BTree.Node {
    func contains(_ element: Element) -> Bool {
        let slot = self.slot(of: element)
        if slot.match { return true }
        guard !children.isEmpty else { return false }
        return children[slot.index].contains(element)
    }
}
extension BTree {
    fileprivate mutating func makeRootUnique() -> Node {
        if isKnownUniquelyReferenced(&root) { return root }
        root = root.clone()
        return root
    }
}
extension BTree.Node {
    func makeChildUnique(at slot: Int) -> BTree<Element>.Node {
        guard !isKnownUniquelyReferenced(&children[slot]) else { return children[slot] }
        let clone = children[slot].clone()
        children[slot] = clone
        return clone
    }
}
extension BTree.Node {
    func clone() -> BTree<Element>.Node {
        let clone = BTree<Element>.Node(order: order)
        clone.elements = self.elements
        clone.children = self.children
        return clone
    }
}
extension BTree.Node {
    var isLeaf: Bool { return children.isEmpty }
    var isTooLarge: Bool { return elements.count >= order }
}

extension BTree {
    struct Splinter {
        let separator: Element
        let node: Node
    }
}
extension BTree.Node {
    func split() -> BTree<Element>.Splinter {
        let count = elements.count
        let middle = count / 2
        let separator = elements[middle]
        let node = BTree<Element>.Node(order: order)
        node.elements.append(contentsOf: elements[middle + 1 ..< count])
        elements.removeSubrange(middle ..< count)
        if !isLeaf {
            node.children.append(contentsOf: children[middle + 1 ..< count + 1])
            children.removeSubrange(middle + 1 ..< count + 1)
        }
        return BTree.Splinter(separator: separator, node: node)
    }
}
extension BTree.Node {
    func insert(_ element: Element) -> (old: Element?, splinter: BTree<Element>.Splinter?) {
        let slot = self.slot(of: element)
        if slot.match { return (self.elements[slot.index], nil) }
        mutationCount += 1
        if self.isLeaf {
            elements.insert(element, at: slot.index)
            return (nil, self.isTooLarge ? self.split() : nil)
        }
        let (old, splinter) = makeChildUnique(at: slot.index).insert(element)
        guard let s = splinter else { return (old, nil) }
        elements.insert(s.separator, at: slot.index)
        children.insert(s.node, at: slot.index + 1)
        return (nil, self.isTooLarge ? self.split() : nil)
    }
}
extension BTree {
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let root = makeRootUnique()
        let (old, splinter) = root.insert(element)
        if let splinter = splinter {
            let r = Node(order: root.order)
            r.elements = [splinter.separator]
            r.children = [root, splinter.node]
            self.root = r
        }
        return (old == nil, old ?? element)
    }
}
