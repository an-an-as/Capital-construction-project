enum List<Element> {
    case end
    indirect case node(Element, List<Element>)
}
extension List {
    var isEmpty: Bool {
        if case .end = self {
            return true
        }
        return false
    }
}
extension List {
    @discardableResult
    func cons(_ newElement: Element) -> List<Element> {
        return .node(newElement, self)
    }
}
extension List {
    public mutating func push(_ newElement: Element) {
        self = cons(newElement)
    }
    @discardableResult
    public mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(value, nextNode):
            self = nextNode
            return value
        }
    }
}
extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reduce(.end) { $0.cons($1) }
    }
}
extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}
extension List: CustomStringConvertible {
    var description: String {
        return self.map { "\($0)" }.joined(separator: "\t--->\t")
    }
}
var list: List = [1, 2]
list.pop()
print(list.isEmpty)

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
public struct Stack<T> {
    fileprivate var array: [T] = []
    public var isEmpty: Bool {
        return array.isEmpty
    }
    public var count: Int {
        return array.count
    }
    public mutating func push(_ element: T) {
        array.append(element)
    }
    public mutating func pop() -> T? {
        return array.popLast()
    }
    public func peek() -> T? {
        return array.last
    }
}
extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator { curr.pop() }
    }
}
