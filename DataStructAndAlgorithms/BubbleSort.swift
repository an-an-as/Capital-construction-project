//: 从数组的最后一个值开始两两比较 如果 左>右 就交换  让小的值排到最左 把最小的值隔开然后继续排
//: 把最小的数隔离出来 for min.index in array.count
//: 从最后一个值开始: array.count - 1
//: 两两比较(让最小的值排到最左)  while array.count - 1 > 已经隔离出的数的最小值      通过array.count - 1 -1 往左
//: 比较   左 array.count - 1 - 1 > 右 array.count - 1 ?
//: 交换:  temp = right  , right = left , left = temp
//: Average: O(N^2)
import Foundation
func sort(_ items: [Int]) -> [Int] {
    var list = items
    for index in 0..<list.count {
        var lastIndex = list.count - 1
        while lastIndex > index {
            if list[lastIndex - 1] > list[lastIndex] {
                let temp = list[lastIndex]
                list[lastIndex] = list[lastIndex - 1]
                list[lastIndex - 1] = temp
            }
            lastIndex -= 1
        }
    }
    return list
}
var array = [Int]()
(0...10).forEach { _ in
    let num = Int(arc4random() % 100)
    array.append(num)
}
print(sort(array))

/********************* version2 **********************/
func bubbleSort(_ nums: inout [Int]) {
    let count = nums.count
    for index in 0..<count {
        for prevIndex in 0..<(count - index - 1) where nums[prevIndex] > nums[prevIndex + 1] {
            nums.swapAt(prevIndex, prevIndex + 1)
        }
    }
}
/******************** version3 *******************/
extension Array {
    public mutating func bubbleSortInPlace(sort: (Element, Element) -> Bool) {
        let sum = count
        (0..<sum).forEach {
            for prevIndex in 0..<(sum - $0 - 1) where !sort(self[prevIndex], self[prevIndex + 1]) {
                swapAt(prevIndex, prevIndex + 1)
            }
        }
    }
}
