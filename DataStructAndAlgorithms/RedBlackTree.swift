import Foundation

protocol SortedSet: BidirectionalCollection,CustomStringConvertible where Element:Comparable {
    init()
    func contain(_ element:Element) -> Bool
    mutating func insert(_ newElement:Element)->(instered:Bool,memberAfterInsert:Element)
}
extension SortedSet {
    public var description: String{
        let contents = self.lazy.map { "\($0)" }.joined(separator: ", ")
        return "[\(contents)]"
    }
}
public enum Color {
    case black
    case red
}
public enum RedBlackTree<Element:Comparable> {
    case empty
    indirect case node(Color,Element,RedBlackTree,RedBlackTree)
}
public extension RedBlackTree {
    func contains(_ elements:Element)->Bool{
        switch self {
        case .empty: return false
        case let .node(_,elements,_,_):return true
        case let .node(_,value,left,_) where value > elements: return left.contains(elements)
        case let .node(_,_,_,right): return right.contains(elements)
        }
    }
}
public extension RedBlackTree {
    func forEach(_ body:(Element) throws -> Void) rethrows {
        switch self {
        case .empty: break
        case let .node(_,value,left,right):
            try left.forEach(body)
            try body(value)
            try right.forEach(body)
        }
    }
}
extension Color {
    var symbol: String{
        switch self {
        case .red: return "◉"
        case .black: return "◯"
        }
    }
}
extension RedBlackTree:CustomStringConvertible {
    func diagram(_ top:String, _ root:String,_ bottom:String)->String{
        switch self {
        case .empty: return root + "⚫︎\n"
        case let .node(color,value,.empty,.empty): return root + "\(color.symbol)\(value)\n"
        case let .node(color,value,left,right): return right.diagram(top + "    ",top + "┌───",top + "│   ")
            + root + "\(color.symbol)\(value)\n"
            + left.diagram(bottom + "│   ", bottom + "└───",bottom + "    " )
        }
    }
    public var description: String{
        return diagram("", "", "")
    }
}
extension RedBlackTree {
    @discardableResult
    public mutating func insert(_ element:Element)->(inserted:Bool,memberAfterInsert:Element){
        let (tree,old) = changeToBlack(element)
        self = tree
        return (old == nil, old ?? element)
    }
}
extension RedBlackTree {
    public func changeToBlack(_ element:Element)->(tree:RedBlackTree,existingMember:Element?){
        let (tree,old) = inserting(element)
        switch tree {
        case let .node(.red,value,left,right):
            return (.node(.black,value,left,right),old)
        default:
            return (tree,old)
        }
    }
}
extension RedBlackTree {
    public func inserting (_ element:Element)->(tree:RedBlackTree,old:Element?){
        switch self {
        case .empty:
            return (.node(.red,element,.empty,.empty),nil)
        case let .node(_,oldValue,_,_) where oldValue == element:
            return (self,oldValue)
        case let .node(color,oldValue,left,right) where oldValue > element:
            let(l,old) = left.inserting(element)
            if let old = old  { return (self,old) }
            return (blanced(color, oldValue, l, right),nil)
        case let .node(color,oldValue,left,right):
            let (r,old) = right.inserting(element)
            if let old = old { return (self,old) }
            return (blanced(color, oldValue, left, r),nil)
        }
    }
}
extension RedBlackTree {
    func blanced(_ color:Color,_ value:Element,_ left:RedBlackTree,_ right:RedBlackTree) -> RedBlackTree {
        switch (color,value,left,right) {
        case let (.black,z,.node(.red,y,.node(.red,x,a,b),c),d):
            return .node(.black,y,.node(.red,x,a,b),.node(.red,z,c,d))
        case let (.black,z,.node(.red,x,.node(.red,y,b,c),a),d):
            return .node(.black,z,.node(.red,x,a,b),.node(.red,y,c,d))
        case let (.black,x,a,.node(.red,y,b,.node(.red,z,c,d))):
            return .node(.black,z,.node(.red,x,a,b),.node(.red,y,c,d))
        case let (.black,x,a,.node(.red,z,d,.node(.red,y,b,c))):
            return .node(.black,z,.node(.red,x,a,b),.node(.red,y,c,d))
        default:
            return .node(color,value,left,right)
        }
    }
}
extension RedBlackTree {
    public init(){
        self = .empty
    }
}

let emptyTree: RedBlackTree<Int> = .empty

let bigTree: RedBlackTree<Int> =
    .node(.black, 9,
          .node(.red, 5,
                .node(.black, 1, .empty, .node(.red, 4, .empty, .empty)),
                .node(.black, 8, .empty, .empty)),
          .node(.red, 12,
                .node(.black, 11, .empty, .empty),
                .node(.black, 16,
                      .node(.red, 14, .empty, .empty),
                      .node(.red, 17, .empty, .empty))))
print(bigTree)
