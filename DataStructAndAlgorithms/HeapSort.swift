/**heapsort**
 [0]
 [1]          [2]
 [3]   [4]    [5]     [6]
 [7][8][9][10][11][12][13][14]
 [0] [1][2] [3][4][5][6] [7][8][9][10][11][12][13][14]
 4   5  8   6  9  2  66  9  3  7  22  77  55  11  33
 *buildHeap:
 count:15
 nonLeaf = count/2-1 = 6
 nonLeaf -= 1
 
 *heapfy:
 smalest = [6]
 left = 2 * 6 + 1 = [13]
 left = 2 * 6 + 2 = [14]
 if array[nonleaf] > array[left]  -> smalest = left  (left  < count)  smalest = [13]
 if array[smalest] > array[right] -> smalest = right (right < count)
 if smalest != nonLeaf
 swap: temp = array[nonLeaf] array[nonLeaf] = array[smalest] array[smlest] = arrat[nonLeaf]
 *recursion heapfy
 
 *internalHeapSort
 bulidHeap
 (0..<array.count)forEach
 swap and heapify
 */
import Foundation
func heapSort(_ arr: inout[Int]) -> [Int] {
    func buildheap(_ arr: inout[Int]) {
        let length = arr.count
        let heapsize = length
        var nonleaf = length / 2 - 1
        while nonleaf >=  0 {
            heapify(&arr, i: nonleaf, heapsize: heapsize)
            nonleaf -= 1
        }
    }
    func heapify(_ arr:inout [Int], i : Int, heapsize: Int){
        var smallest = i
        let left = 2*i+1
        let right = 2*i+2
        if(left < heapsize){
            if(arr[i]>arr[left]){
                smallest = left
            }
            else {
                smallest = i
            }
        }
        if(right < heapsize){
            if(arr[smallest] > arr[right]){
                smallest = right
            }
        }
        if(smallest != i){
            var temp: Int
            temp = arr[i]
            arr[i] = arr[smallest]
            arr[smallest] = temp
            heapify(&arr,i: smallest,heapsize: heapsize)
        }
    }
    func internalHeapSort(_ arr: inout[Int]) {
        var heapsize = arr.count
        buildheap(&arr)
        (0 ..< arr.count).forEach { _ in
            var temp: Int
            temp = arr[0]
            arr[0] = arr[heapsize - 1]
            arr[heapsize - 1] = temp
            heapsize = heapsize - 1
            heapify(&arr, i: 0, heapsize: heapsize)
        }
    }
    internalHeapSort(&arr)
    return arr
}
var array = [4,5,8,6,9,2,66,9,3,7,22,77,55,11,33]
heapSort(&array)
