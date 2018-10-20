let stringOnes: [String] = ["1", "One"]
let intOnes = stringOnes.map { Int($0) }
intOnes.forEach { print($0) } /// Optional(1)  nil
var i = intOnes.makeIterator()
while let i = i.next() {
    print(i)
} /// Optional(1)  nil

//for case
for case let one? in intOnes {
    print(one) /// 1
}
for case nil in intOnes {
    print("got a nil value")
}
for case let .some(i) in intOnes { print("\(i)") } ///1

//compactMap
let out = stringOnes.compactMap { Int($0) }
print(out) // [1]

//if case
let j = 5
if case 0..<10 = j {
    print("\(j) 在范围内")
} /// 5 在范围内”


