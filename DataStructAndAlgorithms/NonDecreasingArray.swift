// Non-decreasing Array
// 是否可以改变一个元素成为没有递减元素数列
func checkPossibility(_ nums: [Int]) -> Bool {
    var input = nums
    var modify = false
    for i in 0..<input.count-1 {
        if input[i] > input[i+1] {
            if modify == true {
                return false
            }
            if i > 0 && input[i-1] > input[i+1] {
                input[i+1] = input[i]
            }
            modify = true
        }
    }
    return true
}
/// where出现递减进行修改
/// 3, 4, 2, 3    3 > 2  ->  3, 4, 4  改变使其成为非递减 modify - TRUE
///    ^
/// 3, 4, 4, 3    只能进行一次修改
///       ^
extension Array where Element: Comparable {
    var isNonDecreasing: Bool {
        var temp = self
        var isModified = false
        for index in 0..<temp.count - 1 where temp[index] > temp[index + 1] {
            if isModified == true { return false }
            if index > 0 && temp[index - 1] > temp[index + 1] {
                temp[index + 1] = temp[index]
            }
            isModified = true
        }
        return true
    }
}
var number = [3, 4, 2, 3]
let result = number.isNonDecreasing
print(result)
