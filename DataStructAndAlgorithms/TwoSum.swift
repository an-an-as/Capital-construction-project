/// Given an array of integers, return indices of the two numbers such that they add up to a specific target.
extension Array where Element == Int {
    mutating func fetchTwoIndex(sum: Element) -> (Index, Index)? {
        var dict = [Element: Index]()
        for (index, element) in enumerated() {
            if let cursor = dict[sum - element] {
                return (cursor, index)
            } else {
                dict[element] = index
            }
        }
        return nil
    }
}
var integers = (1...10).map { _ in Int.random(in: 1...10) }
print(integers)
let result = integers.fetchTwoIndex(sum: 10)
print(result)
/**
 nums [1, 2, 3] target 5
 
 dict[5 - 1] = dict[4] nil
 dict[1] = dict[1] = 0
 
 dict[5 - 2] = dict[3] nil
 dict[2] = dict[2] = 1
 
 dict[5 - 3] = dict[2]
 return [1, 2]
 */
