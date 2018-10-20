/**************************************************************************
 * A sequence is a list of values that you can step through one at a time
 * As a consequence, don’t assume that multiple for-in loops on a sequence will either resume iteration or restart from the beginning
 * To establish that a type you’ve created supports nondestructive iteration, add conformance to the Collection protocol.
 * Conforming : declaring conformance to both Sequence and IteratorProtocol
 ************************************************************************/
for element in sequence {
    if ... some condition { break }
}
for element in sequence {
    // No defined behavior
}
struct Countdown: Sequence, IteratorProtocol {
    var count: Int
    mutating func next() -> Int? {
        if count == 0 {
            return nil
        } else {
            defer { count -= 1 }
            return count
        }
    }
}
let threeToGo = Countdown(count: 3)
for i in threeToGo {
    print(i)
}
/// Prints "3"
/// Prints "2"
/// Prints "1"


associatedtype Iterator : IteratorProtocol ///Returns an iterator over the elements of this sequence. Required. Default implementation provided.
associatedtype Element /// A type representing the sequence’s elements. Required.
associatedtype SubSequence ///A type that represents a subsequence of some of the sequence’s elements. Required.

func makeIterator() -> Self.Iterator
func contains(_ element: Self.Element) -> Bool
func contains(where predicate: (Self.Element) throws -> Bool) rethrows -> Bool
func first(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Element?
func min() -> Self.Element?
func min(by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool) rethrows -> Self.Element?
func max() -> Self.Element?
func max(by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool) rethrows -> Self.Element?
func filter(_ isIncluded: (Self.Element) throws -> Bool) rethrows -> [Self.Element]
func prefix(_ maxLength: Int) -> Self.SubSequence
func prefix(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence
func suffix(_ maxLength: Int) -> Self.SubSequence
func dropFirst() -> Self.SubSequence //Complexity: O(1)
func dropFirst(_ n: Int) -> Self.SubSequence //Complexity: O(n), where n is the number of elements to drop from the beginning of the sequence.
func dropLast() -> Self.SubSequence
func dropLast(_ n: Int) -> Self.SubSequence
func drop(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence
func map<T>(_ transform: (Self.Element) throws -> T) rethrows -> [T]
func flatMap<SegmentOfResult>(_ transform: (Self.Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence
func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Self.Element) throws -> Result) rethrows -> Result
var lazy: LazySequence<Self> { get }
func forEach(_ body: (Self.Element) throws -> Void) rethrows
func enumerated() -> EnumeratedSequence<Self>
func sorted() -> [Self.Element]
func reversed() -> [Self.Element]
func split(separator: Self.Element, maxSplits: Int = default, omittingEmptySubsequences: Bool = default) -> [Self.SubSequence]
func split(maxSplits: Int, omittingEmptySubsequences: Bool, whereSeparator isSeparator: (Self.Element) throws -> Bool) rethrows -> [Self.SubSequence]
func joined() -> FlattenSequence<Self>
func joined(separator: String = default) -> String
func joined<Separator>(separator: Separator) -> JoinedSequence<Self> where Separator : Sequence, Separator.Element == Self.Element.Element
func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, Base.Element.Element == OtherSequence.Element
func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence, by areInIncreasingOrder: (Base.Element.Element, Base.Element.Element) throws -> Bool)
    rethrows -> Bool where OtherSequence : Sequence, Base.Element.Element == OtherSequence.Element
func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, Base.Element.Element == PossiblePrefix.Element
func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix, by areEquivalent: (Base.Element.Element, Base.Element.Element) throws -> Bool) rethrows -> Bool where PossiblePrefix : Sequence, Base.Element.Element == PossiblePrefix.Element

//contains
enum HTTPResponse {
    case ok
    case error(Int)
}
let lastThreeResponses: [HTTPResponse] = [.ok, .ok, .error(404)]
let hadError = lastThreeResponses.contains { element in
    if case .error = element {
        return true
    } else {
        return false
    }
}
/// 'hadError' == true
let expenses = [21.37, 55.21, 9.32, 10.18, 388.77, 11.41]
let hasBigPurchase = expenses.contains { $0 > 100 }
/// 'hasBigPurchase' == true




//first
///Returns the first element of the sequence that satisfies the given predicate.
let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
if let firstNegative = numbers.first(where: { $0 < 0 }) {
    print("The first negative number is \(firstNegative).")
}
/// Prints "The first negative number is -2."



//min by
let hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
let leastHue = hues.min { a, b in a.value < b.value }
print(leastHue)
/// Prints "Optional(("Coral", 16))"



//prefix
let numbers = [1, 2, 3, 4, 5]
print(numbers.prefix(2))
/// Prints "[1, 2]"
print(numbers.prefix(10))
/// Prints "[1, 2, 3, 4, 5]"
let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
let positivePrefix = numbers.prefix(while: { $0 > 0 })
/// positivePrefix == [3, 7, 4]



//flatMap
let numbers = [1, 2, 3, 4]
let mapped = numbers.map { Array(count: $0, repeatedValue: $0) }
/// [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
let flatMapped = numbers.flatMap { Array(count: $0, repeatedValue: $0) }
/// [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]



//splite
///separator:The element that should be split upon.
let line = "BLANCHE:   I don't want realism. I want magic!"
print(line.split(separator: " ").map(String.init))
/// Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
/// The maximum number of times to split the sequence, or one less than the number of subsequences to return.
print(line.split(separator: " ", maxSplits: 1).map(String.init))
/// Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
///If false, an empty subsequence is returned in the result for each consecutive pair of separator elements
print(line.split(separator: " ", omittingEmptySubsequences: false).map(String.init))
/// Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
print(line.split(whereSeparator: { $0 == " " }) .map(String.init))
/// Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
print(line.split(maxSplits: 1, whereSeparator: { $0 == " " }).map(String.init))
/// Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"
print(line.split(omittingEmptySubsequences: false,whereSeparator: { $0 == " " })).map(String.init))
/// Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"



//joined
let nestedNumbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
let joined = nestedNumbers.joined(separator: [-1, -2])
print(Array(joined))
/// Prints "[1, 2, 3, -1, -2, 4, 5, 6, -1, -2, 7, 8, 9]"


//lexicographicallyPrecedes
///Returns a Boolean value indicating whether the sequence precedes another sequence
///in a lexicographical (dictionary) ordering, using the less-than operator (<) to compare elements.
let a = [1, 2, 2, 2]
let b = [1, 2, 3, 4]
print(a.lexicographicallyPrecedes(b))
/// Prints "true"
print(b.lexicographicallyPrecedes(b))
/// Prints "false"

//start
let a = 1...3
let b = 1...10
print(b.starts(with: a))
print(b.starts(with: []))
/// Prints "true"
/// Prints "true"


