
/********************************* Conforming to the Collection Protocol  *********************************
 * Must declare at least the following requirements:
 1 The startIndex and endIndex properties
 2 A subscript that provides at least read-only access to your type’s elements
 3 The index(after:) method for advancing an index into your collection
 **********************************************************************************************************/
protocol Queue {
    /// The type of elements in `self`
    associatedtype Element
    /// Push an `element` into the queue
    mutating func push(_ element: Element)
    /// Pop and return an `element` out of the queue.
    /// Return `nil` if the queue is empty.
    mutating func pop() -> Element?
}
struct FIFOQueue<Element>:Queue {
    fileprivate var storage:[Element] = []
    fileprivate var operation:[Element] = []
    ///为了让pop和push一样，有近乎O(1)的性能，不能直接调用Array.remove(at: 0) 这个O(n)方法。
    ///一个用空间换时间的办法，就是我们再创建一个专门用于pop元素的数组，它是storage的逆序存储，这样就可以通过Array.popLast方法直接获取最先加入队列的对象
    mutating func push (_ element:Element){
        storage.append(element)
    }
    mutating func pop () -> Element?{
        if operation.isEmpty {
            operation = storage.reversed()
    ///reversed()是一个O(n)方法，但是把reversed的执行时间分摊到足够多次的popLast之后，可以认为pop的执行时间是个常量，并不随着数组规模的增大线性增长。因此，这是一个amortized O(1)的算法
            storage.removeAll()
        }
        return operation.popLast()
    }
}
extension FIFOQueue:Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int  {
        return operation.count + storage.count
    }
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    public subscript(pos:Int)->Element {
        precondition((startIndex..<endIndex).contains(pos),"Must in the range")
        if pos < operation.endIndex {
            return operation[operation.count - 1 - pos]
        }
        return storage[pos - operation.count]
    }
}
extension FIFOQueue: ExpressibleByArrayLiteral{
    init(arrayLiteral elements: Element...) {
        self.init(storage:[], operation: elements.reversed())
    }
}

/// 关于索引
/// 必需实现Comparable 有确定的顺序 Comparable继承Equatable
/// 字典的索引是 DictionaryIndex 类型
/// 索引失效 和 索引共享  索引步进
/// 自定义非整数索引集合(范围)
extension Substring {
    var nextWordRange: Range<Index> {
        let start = drop(while: { $0 == " "})
        /// Once the predicate returns false it will not be called again 移除前置空格的子字符串
        let end = start.index(where: { $0 == " "}) ?? endIndex
        return start.startIndex..<end
    }
}
struct WordsIndex: Comparable {
    fileprivate let range: Range<Substring.Index>
    fileprivate init(_ value: Range<Substring.Index>) {
        self.range = value
    }
    static func <(lhs: Words.Index, rhs: Words.Index) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }
    static func ==(lhs: Words.Index, rhs: Words.Index) -> Bool {
        return lhs.range == rhs.range
    }
}
struct Words: Collection {
    let string: Substring
    let startIndex: WordsIndex
    init(_ s: String) {
        self.init(s[...])
    }
    private init(_ s: Substring) {
        self.string = s
        self.startIndex = WordsIndex(string.nextWordRange)
        /// 范围的startIndex为除去前置空格后的第一个空格前的内容
    }
    var endIndex: WordsIndex {
        let e = string.endIndex
        return WordsIndex(e..<e)    //ArraySlice([])
    }
}
extension Words {
    subscript(index: WordsIndex) -> Substring {
        return string[index.range]
    }
}
extension Words {
    func index(after i: WordsIndex) -> WordsIndex {
        guard i.range.upperBound < string.endIndex
            else { return endIndex }
        let remainder = string[i.range.upperBound...]
        return WordsIndex(remainder.nextWordRange)
    }
}
Array(Words(" hello world test ").prefix(2)) // ["hello", "world"]”





/****************   BidirectionalCollection  *****************/
///描述: 双向索引,在前向索引的基础上只增加了获取上一个索引值的 index(before:)
///支持: suffix() removeLast() reversed()
extension BidirectionalCollection {
    public var last: Element? {
        return isEmpty ? nil : self[index(before: endIndex)]
    }
}



/****************   RandomAccessCollection   **************/
///描述: 能够在常数时间内跳转到任意索引
///要求: 满足该协议的类型必须能够 (a) 以任意距离移动一个索引，以及 (b) 测量任意两个索引之间的距离，两者都需要是 O(1) 时间常数的操作
///支持: index(_:offsetBy:)   distance(from:to:)






/****************   MutableCollection   *****************/
///描述: 下标赋值
///要求: 单个元素的下标访问方法 subscript 现在必须提供一个 setter
extension FIFOQueue: MutableCollection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }
    public func index(after i: Int) -> Int {
        return i + 1
    }
    public subscript(position: Int) -> Element {
        get {
            precondition((0..<endIndex).contains(position), "Index out of bounds")
            if position < left.endIndex {
                return left[left.count - position - 1]
            } else {
                return right[position - left.count]
            }
        }
        set {
            precondition((0..<endIndex).contains(position), "Index out of bounds")
            if position < left.endIndex {
                left[left.count - position - 1] = newValue
            } else {
                return right[position - left.count] = newValue
            }
        }
    }
}
var playlist: FIFOQueue = ["Shake It Off", "Blank Space", "Style"]
playlist.first // Optional("Shake It Off")
playlist[0] = "You Belong With Me"
playlist.first // Optional("You Belong With Me")




/****************   RangeReplaceableCollection   *****************/
///描述: 添加或删除元素
///要求: 一个空的初始化方法  replaceSubrange(_:with:)
///支持: append(_:)  append(contentsOf:)  remove(at:)   removeSubrange(_:)  insert(at:)   insert(contentsOf:at:)  removeAll























