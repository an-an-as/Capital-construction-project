import Foundation

fileprivate enum ListNode<Element> {
    case end
    indirect case node(Element,ListNode<Element>)
    func cons(_ value:Element)->ListNode<Element> {
        return .node(value,self)
    }
}
public struct ListIndex<Element> {
    fileprivate var node:ListNode<Element>
    fileprivate var tag:Int
}
extension ListIndex:Comparable {
    public static func == <T>(lhs:ListIndex<T>,rhs:ListIndex<T>)->Bool {
        return lhs.tag == rhs.tag
    }
    public static func < <T>(lhs:ListIndex<T>,rhs:ListIndex<Element>)->Bool {
        return lhs.tag > rhs.tag
    }
}
extension ListIndex:CustomStringConvertible {
    public var description: String{
        return "ListIndexTag:\(tag)"
    }
}
struct List<Element>:Collection {
    typealias Index = ListIndex<Element>
    var startIndex: ListIndex<Element>
    var endIndex: ListIndex<Element>
    func index(after i: ListIndex<Element>) -> ListIndex<Element> {
        switch i.node{
        case .end: fatalError("Out of range")
        case let .node(_,next): return Index(node: next, tag: i.tag - 1)
        }
    }
    subscript(position:Index)->Element {
        switch position.node {
        case .end: fatalError("Out of range")
        case let .node(value, _): return value
        }
    }
    subscript(bounds:Range<Index>)->List<Element> {
        return List(startIndex: bounds.lowerBound, endIndex: bounds.upperBound)
    }
}
extension List:ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        startIndex = Index(node: elements.reversed().reduce(.end, {$0.cons($1)}), tag: elements.count)
        endIndex = Index(node: .end, tag: 0)
    }
}
extension List:CustomStringConvertible {
    var description: String {
        let element = self.map{String(describing:$0)}.joined(separator: ",")
        return "List:\(element)"
    }
}
extension List {
    var count: Int {
        return startIndex.tag - endIndex.tag
    }
    mutating func push(_ value:Element) {
        startIndex = Index(node: startIndex.node.cons(value), tag: startIndex.tag + 1)
    }
    mutating func pop()->Index {
        let current = startIndex
        startIndex = index(after: startIndex)
        return current
    }
}
extension List:Sequence,IteratorProtocol {
    mutating func next() -> Element? {
        switch pop().node{
        case .end: return nil
        case let .node(value,_): return value
        }
    }
    static func ==<T:Equatable>(lhs:List<T>,rhs:List<T>)->Bool {
        return lhs.elementsEqual(rhs)
    }
}

var list:List = [5,4,3,2,1]
list.index(of: 1)
list.push(6)
list.pop()
