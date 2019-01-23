///- Version: 1
func removeDuplicates(_ nums: inout [Int]) -> Int {
    nums = Array(Set<Int>(nums)).sorted()
    return nums.count
}
/// - Version: 2
/// 1. cursor:0 index: 0 两个值相同 cursor不动
/// 2. cursor:0 index: 1 两个值不同 步进cursor array[cursor] == array[index]
/// 3. cursor:1 index: 2...5 相同cursor不动、直到 index: 6 不同 步进cursor array[cursor2] == array[index6] 把重复的值用后续的值替换
/// startIndex...cursor 结果原来重复的值替换后的结果
func removeDuplicates2<Element: Comparable>(_ nums: inout [Element]) -> Int {
    guard !nums.isEmpty || nums.count != 1 else { return nums.count }
    var cursor = nums.startIndex
    for index in nums.indices where nums[cursor] != nums[index] {
        nums.formIndex(after: &cursor)
        nums[cursor] = nums[index]
    }
    nums = Array(nums[nums.startIndex...cursor])
    return nums.count
}
var integers = (1...10).map { _ in Int.random(in: 1...10) }.sorted()
print(integers)
print(removeDuplicates(&integers))
print(integers)
/**
 [1, 2, 2, 3]
 cursor 0  index 0   nums[0]=1  nums[0]=1
 cursor 0  index 1   nums[0]=1  nums[1]=2 --> cursor 1  nums[1]= nums[1] = 2
 cursor 1  index 2   nums[1]=2  nums[2]=2
 cursor 1  index 3   nums[1]=2  nums[3]=3 --> cursor 2  nums[2]= nums[3] = 3
 */

/// - Version: 3
extension Array where Element: Hashable {
    mutating func removeDuplicates() {
        guard !isEmpty || count == 1 else { return }
        var cursor = startIndex
        for index in indices where self[cursor] != self[index] {
            formIndex(after: &cursor)
            self[cursor] = self[index]
        }
        self = Array(self[startIndex...cursor])
    }
}
