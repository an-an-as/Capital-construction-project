import Foundation

func simpleSelectionSort(items: [Int]) -> [Int] {
    var list = items
    for i in 0..<list.count {
        var r = i + 1
        var minValue = list[i]
        var minIndex = i
        while r < list.count{
            if list[r] < minValue {
                minValue = list[r]
                minIndex = r
            }
            r += 1
        }
        if minIndex != i {
            let temp = list[i]
            list[i] = list[minIndex]
            list[minIndex] = temp
        }
    }
    return list
}
