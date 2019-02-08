// 山脉数组 长度大于3 先递增后递减的数组
/// [0, 3, 2, 1]
/// l  0..<2  array[index] < array[index + 1] index = 1
/// r  2...   array[index] < array[index - 1] index = 1
extension Array where Element: Comparable {
    var isMountainArray: Bool {
        guard count > 3 else { return false }
        var flag = true
        var cursorL = startIndex
        var cursorR = index(before: endIndex)
        /// 最后一元素前递增
        while cursorL < index(before: index(before: endIndex)) && self[cursorL] < self[index(after: cursorL)] {
            formIndex(after: &cursorL)
        }
        /// 递减
        while cursorR > index(after: startIndex) && self[index(before: cursorR)] > self[cursorR] {
            formIndex(before: &cursorR)
        }
        if cursorL != cursorR { flag = false }
        return flag
    }
}
let result =  [1, 2, 3, 2, 1].isMountainArray
print(result)
