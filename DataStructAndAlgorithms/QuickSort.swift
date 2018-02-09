import Foundation
func sort(items: Array<Int>) -> Array<Int> {
    var list = items
    quickSort(list: &list, low: 0, high: list.count-1)
    return list
}
private func quickSort(list: inout Array<Int>, low: Int, high: Int) {
    if low < high {
        let mid = partition(list: &list, low: low, high: high)
        quickSort(list: &list, low: low, high: mid - 1)
        quickSort(list: &list, low: mid + 1, high: high)
    }
}
private func partition(list: inout Array<Int>, low: Int, high: Int) -> Int {
    var low = low
    var high = high
    let temp = list[low]
    while low < high {
        while low < high && list[high] >= temp {
            high -= 1
        }
        list[low] = list[high]
        while low < high && list[low] <= temp {
            low += 1
        }
        list[high] = list[low]
    }
    list[low] = temp
    return low
}
var array = [5,3,1,2,4]
sort(items:array)
/**
 temp = 5
 [ ][3][1][2][4]
 [4][3][1][2][temp]
 tempIndex = 4
 
 [4][3][1][2] [5]
 recursion low:0  high:tempIndex - 1 = 3 左递归
 [ ][3][1][2] temp 4
 [2][3][1][temp]
 tempIndex = 3    <<recursion low: tempIndex + 1 high: high 4 < 3>>
 
 [2][3][1] [4][5]
 recursion low:0  high:tempIndex - 1 = 2
 [ ][3][1] temp = 2
 [1][temp][3]
 tempIndex = 1    <<recursion low: tempIndex + 1 high: high 2 < 2>>
 
 [1][2] [3][4][5]
 recursion low:0  high:tempIndex - 1 = 1
 [ ][2] temp = 1  low < high
 [1][2]
 tempIndex = 0    <<recursion low: tempIndex + 1 high: high 1 < 1>>
 */
