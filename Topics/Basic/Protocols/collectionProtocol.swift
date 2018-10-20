/***************************************************  collection  **********************************************
 * A sequence whose elements can be traversed multiple times, nondestructively, and accessed by an indexed subscript.
 * Conforming:The
 * startIndex and endIndex properties
 * A subscript that provides at least read-only access to your type’s elements
 * The index(after:) method for advancing an index into your collection
 * Inherits From Sequence
 ***************************************************************************************************************/

associatedtype Indices ///A type that represents the indices that are valid for subscripting the collection, in ascending order. Required.
associatedtype Iterator///A type that provides the collection’s iteration interface and encapsulates its iteration state. Required.
associatedtype SubSequence///A sequence that represents a contiguous subrange of the collection’s elements.Required.
associatedtype Element ///Required.
associatedtype Index ///A type that represents a position in the collection. Required.


func index(of element: Self.Element) -> Self.Index?
func index(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Index?
func prefix(upTo end: Self.Index) -> Self.SubSequence
func prefix(through position: Self.Index) -> Self.SubSequence
func suffix(from start: Self.Index) -> Self.SubSequence
mutating func popFirst() -> Self.Element? //O(1)
mutating func removeFirst() -> Self.Element//O(1)
mutating func removeFirst(_ n: Int)
var indices: Self.Indices { get }
var lazy: LazyCollection<Self> { get }
var lazy: Self { get }
subscript(position: Self.Index) -> Self.Element { get }


func makeIterator() -> Self.Iterator
func split(separator: Self.Element, maxSplits: Int = default, omittingEmptySubsequences: Bool = default) -> [Self.SubSequence]
func joined() -> FlattenCollection<Self>

var count: Int { get }///Complexity: O(1) if the collection conforms to RandomAccessCollection; otherwise, O(n), where n is the length of the collection.
var endIndex: Self.Index { get }
var first: Self.Element? { get }
var isEmpty: Bool { get }
var startIndex: Self.Index { get }

func distance(from start: Self.Index, to end: Self.Index) -> Int
func formIndex(_ i: inout Self.Index, offsetBy n: Int)
func formIndex(after i: inout Self.Index)
func index(_ i: Self.Index, offsetBy n: Int, limitedBy limit: Self.Index) -> Self.Index?
func index(after i: Self.Index) -> Self.Index
subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get }


//index
let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
if let i = students.index(where: { $0.hasPrefix("A") }) {
    print("\(students[i]) starts with 'A'!")
}
/// Prints "Abena starts with 'A'!"


//prefix
let numbers = [10, 20, 30, 40, 50, 60]
if let i = numbers.index(of: 40) {
    print(numbers.prefix(upTo: i))
}
/// Prints "[10, 20, 30]"
let numbers = [10, 20, 30, 40, 50, 60]
if let i = numbers.index(of: 40) {
    print(numbers.prefix(through: i))
}
/// Prints "[10, 20, 30, 40]"



//indices
///A collection’s indices property can hold a strong reference to the collection itself
///If you mutate the collection while iterating over its indices, a strong reference can result in an unexpected copy of the collection.
///To avoid the unexpected copy, use the index(after:) method starting with startIndex to produce indices instead.
var c = MyFancyCollection([10, 20, 30, 40, 50])
var i = c.startIndex
while i != c.endIndex {
    c[i] /= 5
    i = c.index(after: i)
}
/// c == MyFancyCollection([2, 4, 6, 8, 10])
