/**
 func allSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool
 func last(where predicate: (Element) throws -> Bool) rethrows -> Element?
 func lastIndex(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Index?
 func lastIndex(of element: Element) -> Int?
 mutating func removeAll(where predicate: (Element) throws -> Bool) rethrows
 */
let digits = 0...9
let areAllSmallerThanTen = digits.allSatisfy { $0 < 10 }
print(areAllSmallerThanTen)

let names = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
let allHaveAtLeastFive = names.allSatisfy({ $0.count >= 5 })
// allHaveAtLeastFive == true

let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
if let lastNegative = numbers.last(where: { $0 < 0 }) {
    print("The last negative number is \(lastNegative).")
    // Prints "The last negative number is -6."
}

let text = "Vamos a la playa"
let lastWordBreak = text.lastIndex(where: { $0 == " " })
let lastWord = lastWordBreak.map { text[text.index(after: $0)...] }
print(lastWord)
//Optional("playa")

let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
if let i = students.lastIndex(where: { $0.hasPrefix("A") }) {
    print("\(students[i]) starts with 'A'!")
    // Prints "Akosua starts with 'A'!"
}

var students2 = ["Ben", "Ivy", "Jordell", "Ben", "Maxime"]
if let i = students2.lastIndex(of: "Ben") {
    students2[i] = "Benjamin"
}
print(students)
// Prints "["Ben", "Ivy", "Jordell", "Benjamin", "Max"]"

var nums = Array(1...10)
nums.removeAll(where: { $0 % 2 != 0 })
print(numbers)
