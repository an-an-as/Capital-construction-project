
/*
 *               Half-open       | Closed range
 * +------------+----------------+----------------------+
 * | Comparable | Range          | ClosedRange          |
 * +------------+----------------+----------------------+
 * | Strideable | CountableRange | CountableClosedRange |
 * +------------+----------------+----------------------+
 *
 * 区间操作符在Swift中通过两个struct实现: CountableRange  CountableClosedRange
 * 它们都遵从Comparable和Strideable protocol
 */

/*Countable range*/
for i in 0..<10 {
    print("\(i)", terminator: " ")
}
// Uncountable range for _ in 0.1..<1.1 {}
// error: type 'Range<Double>' does not conform to protocol 'Sequence'
for i in stride(from: 1.0, to: 5.0, by: 0.5) {
    print("\(i)",terminator:" ")
}
// 1.0 2.0 3.0 4.0
for i in stride(from: 1.0, through: 5.0, by: 1.0) {
    print(i)
}
// 1.0 2.0 3.0 4.0 5.0



/* PartialRange */
let fromA: PartialRangeFrom<Character> = Character("a")...
fromA.contains("B") //false
fromA.contains("b") //true
let throughZ: PartialRangeThrough<Character> = ...Character("z")

let upto10: PartialRangeUpTo<Int> = ..<10
let fromFive: CountablePartialRangeFrom<Int> = 5...


let atLeastFive = 5.0...
atLeastFive.contains(4.0)     // false
atLeastFive.contains(5.0)     // true
atLeastFive.contains(6.0)     // true

let numbers = [10, 20, 30, 40, 50, 60, 70]
print(numbers[3...])
// Prints "[40, 50, 60, 70]"


//swift4.0
numbers[...]


///Other
let arr = [1,2,3]
let out = arr[0..<0]    //ArraySlice([])
Array(out)              //[]
