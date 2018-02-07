import Foundation
func mergeSort( _ arr:inout [Int]) -> [Int] {
    func merge (_ arr: inout[Int],  low: Int, mid: Int, high: Int, temp:inout [Int]) {
        var i = low
        var j = mid + 1
        let m = mid
        let n = high
        var k = 0
        while (i <= m && j <= n) {
            if (arr[i] <=  arr[j]) {
                temp[k] = arr[i]
                k += 1
                i += 1
            }
            else
            {
                temp[k] = arr[j]
                k += 1
                j += 1
            }
        }
        while i <= m {
            temp[k] = arr[i]
            k += 1
            i += 1
        }
        while j <=  n {
            temp[k] = arr[j]
            k += 1
            j += 1
        }
        for f in 0 ..< k {
            arr[low + f] = temp[f]
        }
    }
    func internalMergeSort(_ arr: inout[Int],  low: Int,  high: Int,   temp: inout[Int]) {
        if high <= low {
            return
        }
        let mid = low + (high - low) / 2
        internalMergeSort(&arr, low: low, high: mid, temp: &temp)
        internalMergeSort(&arr, low: mid + 1, high: high, temp: &temp)
        merge(&arr, low: low, mid: mid, high: high, temp: &temp)
    }
    var temp: [Int] = arr
    internalMergeSort(&arr, low: 0, high: arr.count - 1, temp: &temp)
    return arr
}
