// 最短连续无序子数组
/// [1, 4, 2, 3, 7]
///     ^     ^
/// max = 4 cursorR = 3 max = 7
/// min = 2 cursorL = 1 min = 1
/// 1. cursorR < max  通过max确定右边界
/// 2. cursorL > min  通过min确定左边界
extension Array where Element == Int {
    var unsortedSubArray: Int {
        guard !isEmpty else { return 0 }
        var cursorL = startIndex
        var cursorR = startIndex
        var min = last!
        var max = first!
        for index in 1..<endIndex {
            if self[index] > max {
                max = self[index]
            } else {
                cursorR = index
            }
        }
        for index in (0..<count - 1).reversed() {
            if self[index] <= min {
                min = self[index]
            } else {
                cursorL = index
            }
        }
        return cursorR != cursorL ? cursorR - cursorL + 1 : 0
    }
}
var integers = [1, 4, 2, 3, 7]
let result = integers.unsortedSubArray
print(result)
