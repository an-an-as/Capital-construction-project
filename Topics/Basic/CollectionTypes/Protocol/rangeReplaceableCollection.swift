/***********************************************    collection  mutability  ********************************************
 * A collection that supports replacement of an arbitrary subrange of elements with the elements of another collection
 * Conforming : You can override any of the protocol’s required methods to provide your own custom implementation.
 * add an empty initializer and the replaceSubrange(_:with:) method to your custom type.
 * Inherits From Collection Adopted By Array String Data ...
 ************************************************************************************************************************/
associatedtype SubSequence //Required.
init()//Required Creates a new, empty collection.

mutating func insert<S>(contentsOf newElements: S, at i: Self.Index) where S : Collection, Self.Element == S.Element //Required. Default
mutating func replaceSubrange<C>(_ subrange: Range<Self.Index>, with newElements: C) where C : Collection, Self.Element == C.Element

mutating func removeFirst(_ n: Int)//Required. Default
mutating func removeAll(keepingCapacity keepCapacity: Bool)//Required. Default

func + <C, S>(lhs: C, rhs: S) -> C where C : RangeReplaceableCollection, S : Sequence, C.Element == S.Element
func + <RRC1, RRC2>(lhs: RRC1, rhs: RRC2) -> RRC1 where RRC1 : RangeReplaceableCollection, RRC2 : RangeReplaceableCollection, RRC1.Element == RRC2.Element
func += <R, S>(lhs: inout R, rhs: S) where R : RangeReplaceableCollection, S : Sequence, R.Element == S.Element

init<S>(_ elements: S) where S : Sequence, Self.Element == S.Element///Creates a new instance of a collection containing the elements of a sequence.//Required. Default
init(repeating repeatedValue: Self.Element, count: Int)//Required. Default

mutating func append(_ newElement: Self.Element)//Required. Default
mutating func append<S>(contentsOf newElements: S) where S : Sequence, Self.Element == S.Element//Required. Default
func filter(_ isIncluded: (Self.Element) throws -> Bool) rethrows -> Self
mutating func insert(_ newElement: Self.Element, at i: Self.Index)//Required. Default
mutating func remove(at i: Self.Index) -> Self.Element //Required. Default
mutating func removeFirst() -> Self.Element//Required. Default
mutating func removeLast() -> Self.Element //Complexity: O(1) The collection must not be empty.
mutating func removeLast(_ n: Int)
mutating func removeSubrange(_ bounds: Range<Self.Index>)//Required. Default
mutating func reserveCapacity(_ n: Int)//Required. Default
///Depending on the type, it may make sense to allocate more or less storage than requested, or to take no action at all.

subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get }//Required.
subscript(bounds: Self.Index) -> Self.Element { get }//Required.


//insert
///Complexity: O(m), where m is the combined length of the collection and newElements.
var numbers = [1, 2, 3, 4, 5]
numbers.insert(contentsOf: 100...103, at: 3)
print(numbers)
/// Prints "[1, 2, 3, 100, 101, 102, 103, 4, 5]"


//insert at
///Complexity: O(n)
var numbers = [1, 2, 3, 4, 5]
numbers.insert(100, at: 3)
numbers.insert(200, at: numbers.endIndex)
print(numbers)
/// Prints "[1, 2, 3, 100, 4, 5, 200]"


//replaceSubrange
///Complexity: O(m), where m is the combined length of the collection and newElements.
var nums = [10, 20, 30, 40, 50]
nums.replaceSubrange(1...3, with: repeatElement(1, count: 5))
print(nums)
/// Prints "[10, 1, 1, 1, 1, 1, 50]"


//+
let numbers = [1, 2, 3, 4]
let moreNumbers = numbers + 5...10
print(moreNumbers)
/// Prints "[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]"
let lowerNumbers = [1, 2, 3, 4]
let higherNumbers: ContiguousArray = [5, 6, 7, 8, 9, 10]
let allNumbers = lowerNumbers + higherNumbers
print(allNumbers)
/// Prints "[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]"


//+=
var numbers = [1, 2, 3, 4, 5]
numbers += 10...15
print(numbers)
/// Prints "[1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15]"


//remove
///Complexity:O(n)
var measurements = [1.2, 1.5, 2.9, 1.2, 1.6]
let removed = measurements.remove(at: 2)
print(measurements)
/// Prints "[1.2, 1.5, 1.2, 1.6]"


//remove first
///Complexity: O(n) where n is the length of the collection.
var bugs = ["Aphid", "Bumblebee", "Cicada", "Damselfly", "Earwig"]
bugs.removeFirst()
print(bugs)
/// Prints "["Bumblebee", "Cicada", "Damselfly", "Earwig"]"
var bugs = ["Aphid", "Bumblebee", "Cicada", "Damselfly", "Earwig"]
bugs.removeFirst(3)
print(bugs)
/// Prints "["Damselfly", "Earwig"]"


//remove subrange
var bugs = ["Aphid", "Bumblebee", "Cicada", "Damselfly", "Earwig"]
bugs.removeSubrange(1...3)
print(bugs)
/// Prints "["Aphid", "Earwig"]"
