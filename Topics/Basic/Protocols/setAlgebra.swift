/*************************************************************************************************************
 * A type that provides mathematical set operations.
 *
 *
 *
 *************************************************************************************************************/

associatedtype Element //Required

init() //Required. Default
init<S>(_ sequence: S) where S : Sequence, Self.Element == S.Element//Required. Default
func contains(_ member: Self.Element) -> Bool//Required. Default
mutating func insert(_ newMember: Self.Element) -> (inserted: Bool, memberAfterInsert: Self.Element)//Required. Default
mutating func update(with newMember: Self.Element) -> Self.Element?//Required. Default
mutating func remove(_ member: Self.Element) -> Self.Element?//Required. Default

func union(_ other: Self) -> Self//Required. Default
mutating func formUnion(_ other: Self)//Required. Default
func intersection(_ other: Self) -> Self//Required. Default
mutating func formIntersection(_ other: Self)//Required. Default
func symmetricDifference(_ other: Self) -> Self//Required. Default
mutating func formSymmetricDifference(_ other: Self)//Required. Default
func subtracting(_ other: Self) -> Self//Required. Default
mutating func subtract(_ other: Self)//Required. Default

func isSubset(of other: Self) -> Bool//Required. Default
func isStrictSubset(of other: Self) -> Bool//Required. Default
func isDisjoint(with other: Self) -> Bool//Required. Default

func isSuperset(of other: Self) -> Bool//Required. Default
func isStrictSuperset(of other: Self) -> Bool//Required. Default
func isDisjoint(with other: Self) -> Bool//Required. Default
var isEmpty: Bool { get }




//insert
enum DayOfTheWeek: Int {
    case sunday, monday, tuesday, wednesday, thursday,
    friday, saturday
}

var classDays: Set<DayOfTheWeek> = [.wednesday, .friday]
print(classDays.insert(.monday))
/// Prints "(true, .monday)"
print(classDays)
/// Prints "[.friday, .wednesday, .monday]"

print(classDays.insert(.friday))
/// Prints "(false, .friday)"
print(classDays)
/// Prints "[.friday, .wednesday, .monday]"

//union
let attendees: Set = ["Alicia", "Bethany", "Diana"]
let visitors = ["Marcia", "Nathaniel"]
let attendeesAndVisitors = attendees.union(visitors)
print(attendeesAndVisitors)
/// Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"

let initialIndices = Set(0..<5)
let expandedIndices = initialIndices.union([2, 3, 6, 7])
print(expandedIndices)
/// Prints "[2, 4, 6, 7, 0, 1, 3]"

var attendees: Set = ["Alicia", "Bethany", "Diana"]
let visitors: Set = ["Diana", "Marcia", "Nathaniel"]
attendees.formUnion(visitors)
print(attendees)
/// Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"

var initialIndices = Set(0..<5)
initialIndices.formUnion([2, 3, 6, 7])
print(initialIndices)
///Prints "[2, 4, 6, 7, 0, 1, 3]"
