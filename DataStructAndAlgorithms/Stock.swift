//最佳买卖时机
/// 每日买入第二日卖出的最大利润
extension Array where Element == Int {
    mutating func maxProfit() -> Element {
        var max = 0
        guard count > 1 else { return max }
        for index in 1..<endIndex where self[index] > self[index - 1] {
            max += self[index] - self[index - 1]
        }
        return max
    }
 }
 var prices = (1...10).map { _ in Int.random(in: 1...10) }
 print(prices)
 print( prices.maxProfit() )

/// 一次买入一次卖出
/// 最大子数组和
/// [1, 3, 6, 7]
/// [2, 3, 1]
extension Array where Element == Int {
var maxDifference: Int? {
    guard count >= 1 else { return nil }
    var temp = [Int]()
    for cursor in index(after: startIndex)..<endIndex {
        let difference = self[cursor] - self[index(before: cursor)]
        temp.append(difference)
    }
    var maxNum = 0
    var tempNum = 0
    temp.forEach {
        if tempNum + $0 > 0 {
            tempNum += $0
        } else {
            tempNum = 0
        }
        maxNum = Swift.max(tempNum, maxNum)
    }
    return maxNum
}
}
print([1, 2, 3, 4].maxDifference)
