/// 1. module之前的数限制在本身
/// 2. module之后的数会逐渐递增
/// 3. 前后的数都限制在module内
extension Array {
    mutating func ratate(step: Index) {
        let remainder = step.quotientAndRemainder(dividingBy: count).remainder
        if isEmpty || remainder == 0 { return }
        for (index, element) in enumerated() {
            self[(index + remainder) % count] = element
        }
    }
}
var integers = (1...5).map { _ in Int.random(in: 1...10) }
print(integers)
integers.ratate(step: 2)
print(integers)
/**
 [1, 2, 3, 4, 5]
 
 remainder 2 % 5 = 2
 rotated [ (0 + 2) % 5 ] --> rotated[2] = 1
 
 remainder 2 % 5 = 2
 rotated [ (1 + 2) % 5 ] --> rotated[3] = 2
 
 remainder 2 % 5 = 2
 rotated [ (2 + 2) % 5 ] --> rotated[4] = 3
 
 remainder 2 % 5 = 2
 rotated [ (3 + 2) % 5 ] --> rotated[0] = 4
 
 remainder 2 % 5 = 2
 rotated [ (4 + 2) % 5 ] --> rotated[1] = 5
 */
