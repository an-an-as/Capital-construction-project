// 找出最大数 为其他元素的2倍
extension Array where Element == Int {
    var dominantIndex: Int? {
        guard let maxNumber = self.max() else { return nil }
        let dominateNums = filter { $0 != maxNumber &&  $0 * 2 > maxNumber }
        return dominateNums.isEmpty ? index(of: maxNumber) : nil
    }
}
var integers = [1, 2, 3, 6]
let result = integers.dominantIndex
print(result)
