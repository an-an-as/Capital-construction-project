/*********************************     Creating an Empty Dictionary    **********************************/
///存储无序的相同类型数据的集合,键值唯一
var namesOfIntegers = [Int: String]()


/**************************   Creating a Dictionary with a Dictionary Literal   **************************/
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]


/**************************   Accessing and Modifying a Dictionary   **************************/
print("The airports dictionary contains \(airports.count) items.")
/// Prints "The airports dictionary contains 2 items."
if airports.isEmpty {
    print("The airports dictionary is empty.")
} else {
    print("The airports dictionary is not empty.")
}
airports["LHR"] = "London"
airports["LHR"] = "London Heathrow"
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}
/// Prints "The old value for DUB was Dublin."
if let airportName = airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport is not in the airports dictionary.")
}
/// Prints "The name of the airport is Dublin Airport."
airports["APL"] = "Apple Internation"
airports["APL"] = nil
if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary does not contain a value for DUB.")
}


/**************************   Iterating Over a Dictionary   **************************/
for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}
for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}
/// Airport code: YYZ
/// Airport code: LHR
for airportName in airports.values {
    print("Airport name: \(airportName)")
}
/// Airport name: Toronto Pearson
/// Airport name: London Heathrow
let airportCodes = [String](airports.keys)
/// airportCodes is ["YYZ", "LHR"]
let airportNames = [String](airports.values)
/// airportNames is ["Toronto Pearson", "London Heathrow"]


/**************************  Action  **************************/
enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}
let defaultSettings: [String:Setting] = [
    "Airplane Mode": .bool(false),
    "Name": .text("My iPhone"),
]
defaultSettings["Name"] /// Optional(Setting.text("My iPhone"))”
//可变性
var userSettings = defaultSettings
userSettings["Name"] = .text("Jared's iPhone")
userSettings["Do Not Disturb"] = .bool(true)
//字典方法
var number = [ "num1":1111, "num2":2222 ]
var number2 = ["num1":333]
var number3 = [("num3",555)]
let newNumber = number.mapValues { (num) -> Int in num * 2 }
number.merge(number2) { (current, _) -> Int in return current }
///["num1": 1111, "num2": 2222]
number.merge(number2, uniquingKeysWith: {$1})
///["num1": 333, "num2": 2222]
number.merge(number3, uniquingKeysWith: {$1}
/// ["num1": 333, "num2": 2222, "num3": 555]

/// 从一个 (Key,Value) 键值对的序列中构建新的字典。如果我们能能保证键是唯一的，那么就可以使用 Dictionary(uniqueKeysWithValues:)
let pairsWithDuplicateKeys = [("a", 1), ("b", 2), ("a", 3), ("b", 4)]
let firstValues = Dictionary(pairsWithDuplicateKeys,uniquingKeysWith: { (first, _) in first })/// ["b": 2, "a": 1]
let lastValues = Dictionary(pairsWithDuplicateKeys,uniquingKeysWith: { (_, last) in last })   /// ["b": 4, "a": 3]
extension Dictionary {
    mutating func merge<S:Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        sequence.forEach { self[$0] = $1 }
    }
    init<S:Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        self = [:]
        self.merge(sequence)
    }
    func mapValue<T>(_ transform: (Value) -> T) -> [Key: T] {
        return Dictionary<Key, T>(map { (k, v) in
            return (k, transform(v))
        })
    }
}
/// map一个Sequence 构成(valuse,1)元祖 通过Dictionary的uniquingKeys first + last 计算出现次数
extension Sequence where Element: Hashable {
    var frequencies: [Element:Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
        
    }
}
let frequencies = "hello".frequencies // ["e": 1, "o": 1, "l": 2, "h": 1]
let result = frequencies.filter { $0.value > 1 }   // ["l": 2]”
result



/**************************   Hashable   **************************/
struct Person {
    var name: String
    var age: Int
    let INT_BIT = (Int)(CHAR_BIT) * MemoryLayout<Int>.size
    func bitwiseRotate(value: Int, bits: Int) -> Int {
        return (((value) << bits) | ((value) >> (INT_BIT - bits)))
    }
}
extension Person: Equatable {
    static func == (lhs:Person,rhs:Person) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
}
extension Person: Hashable {
    var hashValue:Int {
        return bitwiseRotate(value: name.hashValue, bits: 10) ^ age.hashValue
    }
}
let student1 = Person(name: "Jack", age: 15)
let student2 = Person(name: "Tom", age: 20)
let dict:[Person:Any] =
[
        student1 : 1,
        student2 : 2
]
print (dict.keys.map { $0.age * 10 })







