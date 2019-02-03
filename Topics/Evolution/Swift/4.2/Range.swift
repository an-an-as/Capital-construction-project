/**
 移除CountableRange和CountableClosedRange
 Swift 4.1中条件协议一致性(SE-0143)的引入使得标准库可以消除大量以前需要的类型，但其功能现在可以在基础类型上表示为受约束的扩展。
 例如，MutableSlice<Base>的功能现在由一个<Base>的“普通”切片片和一个扩展切片(其中Base: MutableCollection)来划分。
 
 Swift 4.2为范围引入了类似的整合。以前的具体类型CountableRange和CountableClosedRange已被删除，以适应范围和近距离的条件一致性。
 可数范围类型的目的是，如果一个范围的基础元素类型是可数的(即，它符合可跨越的协议)。例如，整数的范围可以是集合，但是浮点数的范围不能
 */
let integerRange: Range = 0..<5
// We can map over a range of integers because it's a Collection
let integerStrings = integerRange.map { String($0) }
integerStrings

let floatRange: Range = 0.0..<5.0
// But this is an error because a range of Doubles is not a Collection
//floatRange.map { String($0) } // error!
