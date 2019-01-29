/// 可组成三角形的最大周长
/// 构成三角形的条件: A[i] < A[i-1] + A[i-2]
extension Array where Element == Int {
    var largestPerimeter: Int {
        var temp = 0
        for currentIndex in 0..<sorted(by: >).count - 2 {
            let cursorB = index(after: currentIndex)
            let cursorC = index(after: cursorB)
            if self[currentIndex] + self[cursorB] > self[cursorC]
                && self[currentIndex] + self[cursorC] > self[cursorB]
                && self[cursorC] + self[cursorB] > self[currentIndex] {
                temp = Swift.max(temp, self[currentIndex] + self[cursorB] + self[cursorC])
            }
        }
        return temp
    }
}
var interges = (1...10).map { _ in Int.random(in: 1...10) }
print(interges)
print(interges.largestPerimeter)
