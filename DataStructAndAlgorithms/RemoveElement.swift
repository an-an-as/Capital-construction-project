//RemoveElement
extension Array where Element: Comparable {
    mutating func removeAllDuplicates(where predicate: (Element) -> Bool ) {
        var cursor = index(before: startIndex)
        for index in indices where !predicate(self[index]) {
            formIndex(after: &cursor)
            self[cursor] = self[index]
        }
        self = Array(self[startIndex...cursor])
    }
}
var nums = [1, 2, 3, 2, 1]
//nums.removeAll { $0 == 1 }
print(nums)
nums.removeAllDuplicates { $0 == 3 }
print(nums)

