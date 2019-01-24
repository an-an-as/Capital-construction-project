//搜索插入位置
/// 不断缩小范围直到CursorL和CursorR重合
/// 1. 如果目标值大于重合值CursorL右移后 CursorL > cursorR 返回CursorL CursorL在重合位置右侧
/// 2. 如果目标值小于重合值CursorR左移后 CursorL > cursorR 返回CursorL CursorL在重合位置
extension RandomAccessCollection where Element: Comparable {
    func binarySearch(_ value: Element) -> Index {
        var cursorL = startIndex
        var cursorR = endIndex
        while cursorL < cursorR {
            let steps = distance(from: cursorL, to: cursorR)
            let midIndex = index(cursorL, offsetBy: steps / 2)
            if value > self[midIndex] {
                cursorL = index(after: midIndex)
            } else {
                cursorR = midIndex
            }
        }
        return cursorL
    }
}
