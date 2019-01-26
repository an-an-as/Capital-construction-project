/// 合并有序数组
func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
    var temp = [Int]()
    var cursorL = 0
    var cursorR = 0
    while cursorL < m && cursorR < n {
        if nums1[cursorL] < nums2[cursorR] {
            temp.append(nums1[cursorL])
            cursorL += 1
        } else {
            temp.append(nums2[cursorR])
            cursorR += 1
        }
    }
    temp.append(contentsOf: nums1[cursorL..<m])
    temp.append(contentsOf: nums2[cursorR..<n])
    nums1 = temp
}
var array1 = [1, 2, 3, 0, 0, 0]
var array2 = [2, 5, 6]
merge(&array1, 3, array2, 3)
print(array1)

/// - Version: 2
extension Array where Element: Comparable {
    mutating func mergeSortedArray(_ array: [Element]) {
        var temp = [Element]()
        var cursorL = startIndex
        var cursorR = array.startIndex
        while cursorL < endIndex && cursorR < array.endIndex {
            if self[cursorL] < array[cursorR] {
                temp.append(self[cursorL])
                formIndex(after: &cursorL)
            } else {
                temp.append(array[cursorR])
                formIndex(after: &cursorR)
            }
        }
        temp.append(contentsOf: self[cursorL..<endIndex])
        temp.append(contentsOf: array[cursorR..<array.endIndex])
        self = temp
    }
}
var intergers = (1...3).map { _ in Int.random(in: 1...10) }.sorted()
intergers.mergeSortedArray([1, 2, 3])
print(intergers)

