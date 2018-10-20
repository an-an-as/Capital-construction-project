/***********************************************    collection  traversal  ********************************************
 * A collection that supports efficient random-access index traversal.
 * Random-access collections can move indices any distance and measure the distance between indices in O(1) time.
 * Conforming: must implement the index(_:offsetBy:) and distance(from:to:) methods with O(1) efficiency
 * Inherits From BidirectionalCollection
 ************************************************************************************************************************/
associatedtype Element //Required.
associatedtype Index   //Required.
associatedtype Indices // A type that represents the indices that are valid for subscripting the collection, in ascending order. Required.
associatedtype SubSequence //A collection that represents a contiguous subrange of the collection’s elements. Required.

var startIndex: Self.Index { get }  //Required.
var endIndex: Self.Index { get }    //Required.
var indices: Self.Indices { get }   //Required.
var lazy: Self { get } ///Identical to self.

func distance(from start: Self.Index, to end: Self.Index) -> Self.Index.Stride //Complexity: O(1)  If end is equal to start, the result is zero.
func index(_ i: Self.Index, offsetBy n: Self.Index.Stride) -> Self.Index
func index(_ i: Self.Index, offsetBy n: Int, limitedBy limit: Self.Index) -> Self.Index?
func index(after i: Self.Index) -> Self.Index

subscript(Self.Index) //Required.
subscript(position: Self.Index) -> Self.Element { get } //Required.


//index
let numbers = [10, 20, 30, 40, 50]
let i = numbers.index(numbers.startIndex, offsetBy: 4)
print(numbers[i])
/// Prints "50"
/// unless that distance is beyond a given limiting index.
let j = numbers.index(numbers.startIndex,
                      offsetBy: 10,
                      limitedBy: numbers.endIndex)
print(j)
/// Prints "nil"
