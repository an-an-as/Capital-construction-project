import Foundation

public protocol SortedSet: BidirectionalCollection, CustomStringConvertible where Element: Comparable{
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

private class Canary {}
public struct OrderedSet<Element: Comparable>: SortedSet {
    fileprivate var storage = NSMutableOrderedSet()
    fileprivate var canary = Canary()
    public init() {}
}
extension OrderedSet {
    public func forEach(_ body: (Element) -> Void) {
        storage.forEach { body($0 as! Element) }
    }
}
extension OrderedSet {
    fileprivate static func compare(_ a: Any, _ b: Any) -> ComparisonResult{
        let a = a as! Element, b = b as! Element
        if a < b { return .orderedAscending }
        if a > b { return .orderedDescending }
        return .orderedSame
    }
}
extension OrderedSet {
    public func index(of element: Element) -> Int? {
        let index = storage.index(of: element,inSortedRange: NSRange(0 ..< storage.count),
                                  usingComparator: OrderedSet.compare)
        
        return index == NSNotFound ? nil : index
    }
}
extension OrderedSet {
    public func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
    }
}
extension OrderedSet {
    public func contains2(_ element: Element) -> Bool {
        return storage.contains(element) || index(of: element) != nil
    }
}
extension OrderedSet: RandomAccessCollection {
    public typealias Index = Int
    public typealias Indices = CountableRange<Int>
    
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return storage.count }
    public subscript(i: Int) -> Element { return storage[i] as! Element }
}
extension OrderedSet {
    fileprivate mutating func makeUnique() {
        if !isKnownUniquelyReferenced(&canary) {
            storage = storage.mutableCopy() as! NSMutableOrderedSet
            canary = Canary()
        }
    }
}
extension OrderedSet {
    fileprivate func index(for value: Element) -> Int {
        return storage.index(
            of: value,
            inSortedRange: NSRange(0 ..< storage.count),
            options: .insertionIndex,
            usingComparator: OrderedSet.compare)
    }
}
extension OrderedSet {
    @discardableResult
    public mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element){
        let index = self.index(for: newElement)
        if index < storage.count, storage[index] as! Element == newElement {
            return (false, storage[index] as! Element)
        }
        makeUnique()
        storage.insert(newElement, at: index)
        return (true, newElement)
    }
}
struct Value: Comparable {
    let value: Int
    init(_ value: Int) { self.value = value }
    static func ==(left: Value, right: Value) -> Bool {
        return left.value == right.value
    }
    static func <(left: Value, right: Value) -> Bool {
        return left.value < right.value
    }
}

extension BinaryInteger{
    static func arc4random_uniform(_ upper_bound:Self)->Self{
        precondition(upper_bound > 0 && UInt32(upper_bound) < UInt32.max,
                     "arc4random_uniform only callable up to \(UInt32.max)")
        return Self(Darwin.arc4random_uniform(UInt32(upper_bound)))
    }
}
extension MutableCollection where Self:RandomAccessCollection{
    mutating func shuffle(){
        var i = startIndex
        let beforeEndIndex = index(before: endIndex)
        while i < beforeEndIndex {
            let dist = distance(from: i, to: endIndex)
            let randomDistance = IndexDistance.arc4random_uniform(dist)
            let j = index(i, offsetBy: randomDistance)
            self.swapAt(i, j)
            formIndex(after: &i)
        }
    }
}
extension Sequence {
    func shuffled()->[Element]{
        var clone = Array(self)
        clone.shuffle()
        return clone
    }
}

var set = OrderedSet<Int>()
for i in (1 ... 20).shuffled() {
    set.insert(i)
}
print(set)
set.contains(10)
set.reduce(0, +)

var copy = set
copy.insert(42)
print(set)
print(copy)

let value = Value(42)
let a = value as AnyObject
let b = value as AnyObject
a.isEqual(b)
a.hash
b.hash

var values = OrderedSet<Value>()
(1 ... 20).shuffled().map(Value.init).forEach { values.insert($0) }
