//找到一个具有最大和的连续子数组
/// 1. 比较当前sum和之前sum
/// 2. sum出现负数则不连续
extension Array where Element == Int {
    var maxSubArray: Int {
        if isEmpty { return 0 }
        var maxSum = Int.min
        var sum = 0
        forEach {
            sum += $0
            maxSum = Swift.max(sum, maxSum)
            if sum < 0 { sum = 0 }
        }
        return maxSum
    }
}
print([-2, 1, -3, 4, -1, 2, 1, -5, 4].maxSubArray) //[4,-1,2,1] -> 6
/// [-2, 1, -3, 4, -1, 2, 1, -5, 4]
/// sum = -2, maxSum = max(-2, Int.min), sum = 0
/// sum = 1, maxSum = max(1, -2)
/// sum = -2, maxSum = max(-2, 1), sum = 0
/// sum = 4, maxSum = max(4, 1)
/// sum = 3, maxSum = max(3, 4)
/// sum = 5, maxSum = max(5, 4)
/// sum = 6, maxSum = max(6, 5)
/// sum = 1, maxSum = max(1, 6)
/// sum = 4, maxSum = max(4, 6) -->6
