// 枢纽索引 左侧元素和等于右侧元素和
///  [1, 2, 3, 4, 3, 2, 1]
///      ^ index - 1 >= 0
///  sumR = 16
///  index0 sumR = 16 - 1 = 15
///  index1 sumL = 1 sumR = 13
///  index2 sumL = 3 sumR = 10
///  index3 sumL = 6 sumR = 6
extension Array where Element == Int {
    var pivotIndex: Int? {
        guard count > 3 else { return nil }
        var sumL = 0
        var sumR = 0
        sumR = reduce(0) { $0 + $1 }
        for index in indices {
            if index - 1 >= 0 {
                sumL += self[index - 1]
            }
            sumR -= self[index]
            if sumL == sumR {
                return index
            }
        }
        return nil
    }
}
var intergers = [1, 2, 3, 4, 3, 2, 1]
let result = intergers.pivotIndex
print(result)
