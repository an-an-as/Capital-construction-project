/*******************   collection mutablity *********************/
//   MutableCollection: Inherits From Collection
//   To add conformance to the MutableCollection protocol to your own custom collection, upgrade your type’s subscript to support both read and write access.
///  A collection that supports subscript assignment.
///  Collections that conform to MutableCollection gain the ability to change the value of their elements
///  Associated Types: Element Index  Subsequence
///  Instance Methods:
mutating func partition(by belongsInSecondPartition: (Self.Element) throws -> Bool) rethrows -> Self.Index//Required. Default
func reverse()      /// Reverses the elements of the collection in place.  O(n)
func sort()         /// Sorts the collection in place.
func sorted() -> [Self.Element]       /// Returns the elements of the collection, sorted.
func sorted(by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool) rethrows -> [Self.Element]
func swapAt(Self.Index, Self.Index)                                 //Required. Default
subscript(position: Self.Index) -> Self.Element { get set }         //Required. Default
subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get set }//Required.


//partition Complexity: O(n)
///The second partition, numbers[p...], is made up of the elements that are greater than 30.
mutating func partition(by belongsInSecondPartition: (Self.Element) throws -> Bool) rethrows -> Self.Index
var numbers = [30, 40, 20, 30, 30, 60, 10]
let p = numbers.partition(by: { $0 > 30 }) ///Array.Index
/// p == 5
/// numbers == [30, 10, 20, 30, 30, 60, 40]
let first = numbers[..<p]
/// first == [30, 10, 20, 30, 30]
let second = numbers[p...]
/// second == [60, 40]


//reverse  Complexity: O(n)
var characters: [Character] = ["C", "a", "f", "é"]
characters.reverse()
print(characters)
/// Prints "["é", "f", "a", "C"]


//sort
///You can sort any collection of elements that conform to the Comparable protocol by calling this method
var students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
students.sort()
print(students)
/// Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
students.sort(by: >)
print(students)
/// Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"


//sorted
let students: Set = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
let sortedStudents = students.sorted()
print(sortedStudents)
/// Prints "["Abena", "Akosua", "Kofi", "Kweku", "Peter"]"
let descendingStudents = students.sorted(by: >)
print(descendingStudents)
/// Prints "["Peter", "Kweku", "Kofi", "Akosua", "Abena"]"


//sort by
///When you want to sort a collection of elements that don’t conform to the Comparable protocol, pass a predicate
func sorted(by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool) rethrows -> [Self.Element]
enum HTTPResponse {
    case ok
    case error(Int)
}

var responses: [HTTPResponse] = [.error(500), .ok, .ok, .error(404), .error(403)]
responses.sort {
    switch ($0, $1) {
    /// Order errors by code
    case let (.error(aCode), .error(bCode)):
        return aCode < bCode
    /// All successes are equivalent, so none is before any other
    case (.ok, .ok): return false
    /// Order errors before successes
    case (.error, .ok): return true
    case (.ok, .error): return false
    }
}
print(responses)
/// Prints "[.error(403), .error(404), .error(500), .ok, .ok]"
