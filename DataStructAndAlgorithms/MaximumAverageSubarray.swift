// 最大子数组
/// [1, 10, 10, 10, 5]  amounts3
/// 0..<amounts         0..<3    sum = 21
/// amounts..<endIndex  3..<5    index - amount,   array[0, 1]
/// 1. 范围3 去除 1  10 + 10 + 10  记录此时最大值
extension Array where Element == Int {
    func findMaxAverage(amounts: Int) -> Double {
        guard self.count >= amounts else { return 0.0 }
        var sum = 0
        for index in startIndex..<amounts {
            sum += self[index]
        }
        var temp = sum
        for index in amounts..<endIndex {
            sum -= self[index - amounts] /// 按范围去除
            sum += self[index]           /// 范围内最大值
            temp = Swift.max(temp, sum)  /// 记录最大值
        }
        print(temp)
        return Double(temp) / Double(amounts)
    }
}
let result = [1, 10, 10, 10, 5].findMaxAverage(amounts: 3)
print(result)
