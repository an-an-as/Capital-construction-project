/// 均匀分布数列,每组元素相同
/// 1, 2, 3, 1, 2, 3
/// [1: 1, 2: 1, 3: 1] -> [1: 2, 2: 2, 3: 2]
extension Array where Element == Int {
    var hasEvenlyDistribution: Bool {
        func greatestCommonDivisor(_ lhs: Int, _ rhs: Int) -> Int {
            if rhs == 0 {
                return lhs
            } else {
                return greatestCommonDivisor(rhs, lhs % rhs)
            }
        }
        var dict = [Int: Int]()
        forEach {
            dict[$0] = (dict[$0] ?? 0) + 1
        }
        guard !dict.values.contains(1) else { return false }
        let result = Array(dict.values)
        for index in 0..<result.count - 1 where greatestCommonDivisor(result[index], result [index + 1]) == 1 {
            return false
        }
        return true
    }
}
var result = [1, 1, 1, 2, 2, 2, 2, 2, 2].hasEvenlyDistribution
print(result)
//[1, 1, 1]  [2, 2, 2]   [2, 2, 2]
