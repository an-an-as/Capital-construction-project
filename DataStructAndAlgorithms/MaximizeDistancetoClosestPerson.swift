// 座位最大距离 1有人0空位
///    [1, 0, 0, 0]
/// -1  0  1  2  3
///     ^
/// index0  i - left - 1 = 0   dis = max(0, 0) = 0  left = 0
/// index...
/// index3  dis = max(0, 4 - 1 - 0) = 3
///
/// [1, 0, 0, 0, 1, 0, 1]
/// index0  dis = 0   left = 0
/// index...
/// index4  (4 - left) / 2  dis = max(0, 2)  left = 4
/// index6  (6 - left) / 2  dis = max(2, 1)  left = 6
/// count - 1 - left = 0
extension Array where Element == Int {
    var maxDistToClosest: Int {
        var cursorL = -1
        var distance = 0
        for index in indices where self[index] == 1 {
            if cursorL == -1 {
                distance = Swift.max(distance, index - cursorL - 1)
            } else {
                /// 取两座中间数为最大距离
                distance = Swift.max(distance, (index - cursorL) / 2)
            }
            cursorL = index
        }
        /// 是否存在尾部最大距离
        distance = Swift.max(distance, count - 1 - cursorL)
        return distance
    }
}
var seats = [1, 0, 0, 0, 1, 0, 1]
print(seats.maxDistToClosest)
