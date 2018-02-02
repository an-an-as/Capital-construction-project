import Foundation

func bubbleSort(_ items: Array<Int>) -> Array<Int> {
    var list = items
    for l in 0..<list.count {
        var r = list.count - 1
        while r > l {
            if list[r - 1] > list[r]  {
                let temp = list[r]
                list[r] = list[r - 1]
                list[r - 1] = temp
            }
            r = r - 1
        }
    }
    return list
}
