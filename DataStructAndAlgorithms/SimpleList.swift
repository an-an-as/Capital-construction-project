import Foundation

enum List<Element> {
    case end
    indirect case node(Element,List<Element>)
}
extension List {
    func cons(_ value:Element) -> List<Element> {
        return .node(value,self)
    }
}
extension List {
    mutating func push(_ value:Element) {
        self = cons(value)
    }
    mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(value,next):
            self = next
            return value
        }
    }
}
extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reduce(.end){ $0.cons($1) }
    }
}

var list:List = [5,4,3,2,1]
list.cons(6)
list.pop()
