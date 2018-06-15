/***********************************************    collection  traversal  ********************************************
 * A collection that supports backward as well as forward traversal.
 * Inherits From Collection
 * Conforming: implement the index(before:) method in addition to the requirements of the Collection protocol
 ************************************************************************************************************************/

associatedtype Element     //Required.
associatedtype Index       //Required.
associatedtype Indices     //A type that represents the indices that are valid for subscripting the collection, in ascending order. Required.
associatedtype SubSequence //A sequence that can represent a contiguous subrange of the collection’s elements. Required.

var endIndex: Self.Index { get } //Required.
var indices: Self.Indices { get } //Required.
var last: Self.Element? { get } //Complexity: O(1)
var lazy: Self { get } //Required.
var startIndex: Self.Index { get } //Required.

func dropLast(_ n: Int) -> Self.SubSequence ///Complexity: O(n), where n is the number of elements to drop.
func formIndex(before i: inout Self.Index)    ///Replaces the given index with its predecessor. ///Required. Default
func index(before i: Self.Index) -> Self.Index///Returns the position immediately before the given index. ///Required. Default
func joined() -> FlattenBidirectionalCollection<Self>
func joined(separator: String = default) -> String
mutating func popLast() -> Self.Element?
///Complexity: O(1). must be used only on a nonempty collection.You can use popLast() to remove the last element of a collection that might be empty.
mutating func removeLast() -> Self.Element //Complexity: O(1)
mutating func removeLast(_ n: Int) //Complexity: O(1) if the collection conforms to RandomAccessCollection; otherwise, O(n), where n is the length of the collection.
func reversed() -> ReversedCollection<Self>
func suffix(_ maxLength: Int) -> Self.SubSequence //Complexity: O(n), where n is equal to maxLength.

subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get }//Required.
subscript(position: Self.Index) -> Self.Element { get }//Required.
//drop
///Complexity: O(n), where n is the number of elements to drop.
///Return A subsequence that leaves off n elements from the end.
let numbers = [1, 2, 3, 4, 5]
print(numbers.dropLast(2))
/// Prints "[1, 2, 3]"
print(numbers.dropLast(10))
/// Prints "[]"

//suffix
///ReturnsA subsequence terminating at the end of the collection with at most maxLength elements.let numbers = [1, 2, 3, 4, 5]
print(numbers.suffix(2))
/// Prints "[4, 5]"
print(numbers.suffix(10))
/// Prints "[1, 2, 3, 4, 5]"

//joined
///Returns the elements of this collection of collections, concatenated.
let ranges = [0..<3, 8..<10, 15..<17]
/// A for-in loop over 'ranges' accesses each range:
for range in ranges {
    print(range)
}
/// Prints "0..<3"
/// Prints "8..<10"
/// Prints "15..<17"
/// Use 'joined()' to access each element of each range:
for index in ranges.joined() {
    print(index, terminator: " ")
}
/// Prints: "0 1 2 8 9 15 16"
///Returns a new string by concatenating the elements of the sequence, adding the given separator between each element:
let cast = ["Vivien", "Marlon", "Kim", "Karl"]
let list = cast.joined(separator: ", ")
print(list)
/// Prints "Vivien, Marlon, Kim, Karl"
