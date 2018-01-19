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
