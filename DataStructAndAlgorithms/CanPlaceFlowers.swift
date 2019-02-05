// Can Place Flowers
///
/// 相邻不能种花 1表示已种植 0表示没有种植 n表示需要种植的数量
///
/// 0, 0, 0 --> 2   4/2 >= 2
///
extension Array where Element == Int {
    mutating func canPalceFlowers(_ amounts: Int) -> Bool {
        var adjacent = 0
        var count = 1
        forEach {
            if $0 == 0 {                     /// 没有出现1的情况下 count = 1
                count += 1
            } else {
                adjacent += (count - 1) / 2  /// 0 0 1  count3  (3-1)/2 = 1 可种植  count = 0 重新计数
                count = 0
            }
        }
        adjacent += count / 2
        return adjacent >= amounts
    }
}
var flowerbed = [0, 0, 1, 0, 0, 0]
let result = flowerbed.canPalceFlowers(1)
print(result)
