func findMaxConsecutiveOnes(_ nums: [Int]) -> Int {
    var count = 0
    var max = 0
    nums.indices.forEach {
        if nums[$0] == 1 { count += 1 }
        max = max > count ? max : count
        count = nums[$0] == 0 ? 0 : count
    }
    return max
}
/// -Version: 2
extension Array where Element: Equatable {
    func maxConsecutive(_ element: Element) -> Int {
        var count = 0
        var max = 0
        forEach {
            if $0 == element { count += 1 }
            max = max > count ? max : count
            count = $0 != element ? 0 : count
        }
        return max
    }
}
print([1, 1, 1, 0, 1].maxConsecutive(1))
