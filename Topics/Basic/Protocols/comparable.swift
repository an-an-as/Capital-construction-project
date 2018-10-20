/// protocol Comparable : Equatable
/// A type that can be compared using the relational operators <, <=, >=, and >.
struct Date {
    let year: Int
    let month: Int
    let day: Int
}
extension Date: Comparable {
    static func < (lhs: Date, rhs: Date) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
    static func == (lhs: Date, rhs: Date) -> Bool {
        return
            lhs.year == rhs.year &&
                lhs.month == rhs.month &&
                lhs.day == rhs.day
    }
}
let spaceOddity = Date(year: 1969, month: 7, day: 11)   /// July 11, 1969
let moonLanding = Date(year: 1969, month: 7, day: 20)   /// July 20, 1969
if moonLanding > spaceOddity {
    print("Major Tom stepped through the door first.")
} else {
    print("David Bowie was following in Neil Armstrong's footsteps.")
}
/// Prints "Major Tom stepped through the door first."


//***************************** Swift4.1  ****************************
struct Date:Equatable {
    let year: Int
    let month: Int
    let day: Int
}
extension Date: Comparable {
    static func < (lhs: Date, rhs: Date) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
}
let spaceOddity = Date(year: 1969, month: 7, day: 11)   /// July 11, 1969
let moonLanding = Date(year: 1969, month: 7, day: 20)   /// July 20, 1969
if moonLanding > spaceOddity {
    print("Major Tom stepped through the door first.")
} else {
    print("David Bowie was following in Neil Armstrong's footsteps.")
}
/// Prints "Major Tom stepped through the door first."
