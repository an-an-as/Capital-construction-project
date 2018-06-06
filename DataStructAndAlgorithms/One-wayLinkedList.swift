i ///链表是线性表的一种，所谓的线性表包含顺序线性表和链表，顺序线性表是用数组实现的，在内存中有顺序排列，通过改变数组大小实现。
///而链表不是用顺序实现的，用指针实现，在内存中不连续。意思就是说，链表就是将一系列不连续的内存联系起来，将那种碎片内存进行合理的利用，解决空间的问题。
///所以，链表允许插入和删除表上任意位置上的节点，但是不允许随即存取。链表有很多种不同的类型：单向链表、双向链表及循环链表。
///作用: 链表本质上就是一种数据结构，主要用来动态放置数据。也可用来构建许多数据结构，比如堆栈、队列及它们的派生。
///A singly linked list uses a little less memory than a doubly linked list because it doesn't need to store all those previous pointers.
///But if you have a node and you need to find its previous node, you're screwed.
///You have to start at the head of the list and iterate through the entire list until you get to the right node.

///feat:Persistent data structure
///每个节点一旦被创建不可变,将另一个元素添加到链表中并不会复制这个链表，它仅仅只是一个链接在既存的链表的前端的节点
///由于enum值语意可共享链表结尾 虽然节点的值通过引用的方式相互关联
///在数组中所有元素在内存中是连续，所以只需要知道数组中第一个元素的地址以及要获取元素的index就能算出该index内存的地址
///因为数组中所有元素的内存是连续的，所以如果想在中间插入一个新的元素，那么这个位置后面的所有元素都要后移，显然是非常低效的。
///而如果使用链表，只要把要插入到的index前后节点的指针赋给这个新的节点就可以了，不需要移动原有节点在内存中的位置

///在计算机科学的理论中，链表对一些常用操作会比数组高效得多。但是实际上，在当代的计算机架构上，CPU 缓存速度非常之快，相对来说主内存的速度要慢一些，这让链表的性能很难与数组相媲美。
///因为数组中的元素使用的是连续的内存，处理器能够以更高效的方式对它们进行访问。
import Foundation
enum List<Element> {
    case end
    indirect case node(Element,next:List<Element>)
}
extension List {
    func cons(_ value:Element) -> List<Element> {
        return .node(value,next: self)  ///  1 next self-> end
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
extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}
extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end){ $0.cons($1) }
    }
}
let emptyList = List<Int>.end
let oneElementList = List.node(1, next: emptyList)
print(oneElementList)///node(1, next: List<Swift.Int>.end)
let list = List.end.cons(1).cons(2)
let tail1 = list.cons(3)///共享链表结尾
let tail2 = list.cons(3)

var stack:List<Int> = [3,2,1]
var a = stack
var b = stack

a.pop() ///Optional(3)
a.pop() ///Optional(2)
a.pop() ///Optional(1)

stack.pop() ///Optional(3)
stack.push(4)

b.pop() ///Optional(3)
b.pop() ///Optional(2)
b.pop() ///Optional(1)

stack.pop() ///Optional(4)
stack.pop() ///Optional(2)
stack.pop() ///Optional(1)

list.map{"value:\($0)"}.joined(separator: ", ")se

/********************* Comforming to the Collection Protocol *****************/
fileprivate enum ListNode<Element> {
    case end
    indirect case node (Element,ListNode<Element>)
    func cons(_ value:Element) -> ListNode<Element> {
        return .node(value,self)
    }
}
public struct ListIndex<Element> {
    fileprivate var node: ListNode<Element>
    fileprivate var tag: Int
}
extension ListIndex: Comparable {
    public static func ==<T>(lhs:ListIndex<T>,rhs:ListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    public static func <<T>(lhs:ListIndex<T>,rhs:ListIndex<T>) -> Bool {
        return lhs.tag > rhs.tag
    }
}
extension ListIndex:CustomStringConvertible {
    public var description: String {
        return "ListIndx:\(tag)"
    }
}
public struct List<Element>: Collection {
    public typealias Index = ListIndex<Element>
    public var startIndex: Index
    public var endIndex: Index
    public func index(after i: Index) -> Index {
        switch i.node {
        case .end: fatalError("out of range")
        case .node(_, let next): return ListIndex(node: next, tag: i.tag - 1)
        }
    }
    public subscript(position:Index) -> Element {
        switch position.node {
        case .end: fatalError("out of range")
        case .node(let value, _): return value
        }
    }
    public subscript(bounds:Range<Index>) -> List<Element> {
        return List(startIndex: bounds.lowerBound, endIndex: bounds.upperBound)
    }
}
extension List {
    public var count: Int {
        return startIndex.tag - endIndex.tag
    }
    mutating func push(newElement:Element) {
        startIndex = Index(node: startIndex.node.cons(newElement), tag: startIndex.tag + 1)
    }
    mutating func pop() -> Index {
        let currentIndex = startIndex
        startIndex = index(after: currentIndex)
        return currentIndex
    }
}
extension List: IteratorProtocol,Sequence {
    public mutating func next() -> Element? {
        switch pop().node {
        case .end: return nil
        case .node(let value, _): return value
        }
    }
    static func ==<T:Equatable>(lhs:List<T>,rhs:List<T>) -> Bool {
        return lhs.elementsEqual(rhs)
    }
}
extension List: CustomStringConvertible {
    public var description: String {
        let element = self.map { String(describing: $0) }.joined(separator: ", ")
        return "List:\(element)"
    }
}
extension List: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        startIndex = Index(node: elements.reversed().reduce(.end, { $0.cons($1) }), tag: elements.count)
        endIndex = Index(node: .end, tag: 0)
    }
}
var list:List = [1,2,3,4,5]
print(list) ///List:1, 2, 3, 4, 5
