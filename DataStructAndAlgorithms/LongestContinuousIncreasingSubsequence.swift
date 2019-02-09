// 最长连续递增序列个数
extension Array where Element == Int {
    var increasingCount: Int {
        if count == 0 { return 0 }
        if count == 1 { return 1 }
        var maximum = 1
        var sum = 1
        /// 连续计数 非连续后计归1
        for index in 1..<endIndex {
            if self[index] > self[index - 1] {
                sum += 1
            } else {
                sum = 1
            }
            maximum = Swift.max(maximum, sum)
        }
        return maximum
    }
}
let integers = [1, 3, 5, 4, 7]
print(integers.increasingCount)
