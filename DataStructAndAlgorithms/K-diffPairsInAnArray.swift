// 相同差分组
/// [3, 1, 4, 1, 5] diff: 2
/// [3: 0, 4: 2, 1: 3, 5: 4]
/// keys.contain 3 + 2
extension Array where Element == Int {
    func findParis(diff: Int) -> Int {
        guard diff > 0 else { return  0}
        var count = 0
        var dict = [Int: Int]()
        enumerated().forEach {
            dict[$0.element] = $0.offset
        }
        enumerated().forEach {
            if dict.keys.contains($0.element + diff) && dict[$0.element + diff] != $0.offset {
                count += 1
                dict.removeValue(forKey: $0.element + diff)
            }
        }
        return count
    }
}
var integers = [3, 1, 4, 1, 5]
let result = integers.findParis(diff: 2)
print(result)
//(1, 3), (3, 5)
