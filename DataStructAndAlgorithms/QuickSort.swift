/**
 Tony Hoare 1959
 
 + 通过一趟排序将要排序的数据分割成独立的两部分,其中一部分的所有数据都比另外一部分的所有数据都要小
 + 再按此方法对这两部分数据分别进行快速排序
 + 整个排序过程可以递归进行，以此达到整个数据变成有序序列
 
 排序方法                 最好情况                最坏情况             平均情况              稳定性       空间复杂度
 插入排序                 O(n)                   O(n2)              O(n2)                 稳定        O(1)
 选择排序                 O(n2)                  O(n2)              O(n2)                不稳定       O(1)
 希尔排序                 O(n)                   O(n2)              O(n1.3)              不稳定       O(1)
 
 快速排序                 O(nlogn)               O(n2)              O(nlogn)             不稳定       O(1)
 归并排序                 O(nlogn)               O(nlogn)           O(nlogn)               稳定       O(1)
 堆排序                   O(nlogn)               O(nlogn)           O(nlogn)             不稳定       O(1)
 
 冒泡排序                 O(n)                   O(n2)              O(n2)                  稳定       O(1)

 基数排序                O(n*k)                 O(n*k)              O(n*k)                 稳定          O(n+k)
 计数排序                O(n+k)                 O(n+k)               O(n+k)                稳定          O(n+k)
 桶排序                  O(n)                   O(n2)                O(n+k)                稳定          O(n+k)
 
 空间复杂度
 + 简单排序和堆排序都是0(1)
 + 快速排序为0(logn)，要为递归程序执行过程栈所需的辅助空间
 + 归并排序和基数排序所需辅助空间最多，为O(n)
 
 稳定：如果a原本在b前面，而a=b，排序之后a仍然在b的前面。
 不稳定：如果a原本在b的前面，而a=b，排序之后 a 可能会出现在 b 的后面。
 时间复杂度：对排序数据的总的操作次数。反映当n变化时，操作次数呈现什么规律。
 空间复杂度：是指算法在计算机内执行时所需存储空间的度量，它也是数据规模n的函数。
 ---------------------------------------------------------
 */
func quicksort<T: Comparable>(_ array: [T]) -> [T] {    ///                           [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
    guard array.count > 1 else { return array }         ///                 [ 0, 3, 2, 1, 5, -1 ]          [ 8, 8 ]            [ 10, 9, 14, 27, 26 ]
    let pivot = array[array.count/2]                    ///           [ 0, -1 ]    [ 1 ]     [ 3, 2, 5 ]                     [10, 9]   [14]    [27, 26]
    let less = array.filter { $0 < pivot }              ///         [ ]  [-1]  [0]         []   [2]   [3, 5]              []  [9]  [10]      []  [26]  [27]
    let equal = array.filter { $0 == pivot }            ///                                          [3] [5] []
    let greater = array.filter { $0 > pivot }           ///
    return quicksort(less) + equal + quicksort(greater) ///
}
//  [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
/// less:    [ 0, 3, 2, 1, 5, -1 ]
/// equal:   [ 8, 8 ]
/// greater: [ 10, 9, 14, 27, 26 ]
///
/// less recursion                 pivot -1
/// less:    [ 0, -1 ]    -->      []                   []              [3]
/// equal:   [ 1 ]                 [-1]                 [2]             [5]
/// greater: [ 3, 2, 5 ]           [0]                  [3, 5]  ---->   []
///                     `----------------------------->
/// [] + [-1] + [0]

/************** version2 *************/
func partitionHoare<T: Comparable>(_ array: inout [T], low: Int, high: Int) -> Int {
    let pivot = array[low]                                  ///  8          双向扫描 右边的值应大于枢纽值 左边的小于枢纽值
    var indexL = low - 1                                    ///  -1         右边: 遍历到小于pivot
    var indexR = high + 1                                   ///  count      左边: 遍历到大于pivot  此时交换满足条件
    while true {
        repeat { indexR -= 1 } while array[indexR] > pivot  /// indexR = count - 1  array[indexR] = 26 > 8 repeat indexR = count - 2 = -1  NO REPEAT
        repeat { indexL += 1 } while array[indexL] < pivot  /// indexL = 0 array[0] = 8 < pivot NO REPEAT
        if indexL < indexR {                                /// indexL < indexR  swap L:-1 R:8 --> [-1, .......... 8, 26]
            array.swapAt(indexL, indexR)                    /// while true
        } else {                                            /// indexR = count - 3 NO REPEAT
            return indexR                                   /// indexL = 1  array[indexL] = 0 < 8 repeat indexL = 2 indexL = 3 NO REPEAT
        }                                                   /// indexL < indexR swap L:9 R:8 ---> [-1, 0, 3, 8 ............. 9, -1 , 26]
    }                                                       /// ....
}
func quicksortHoare<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
    if low < high {
        let partion = partitionHoare(&array, low: low, high: high)
        quicksortHoare(&array, low: low, high: partion)
        quicksortHoare(&array, low: partion + 1, high: high)
    }
}
var list = [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]
let result = partitionHoare(&list, low: 0, high: list.count - 1)
print(list) // [-1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26]
quicksortHoare(&list, low: 0, high: list.count - 1)
print(list) // [-1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27]
/// condition L < 8 , R > 8
/// [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]  --->   [ -1, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, 8, 26 ]
//    L                                    R        swap      ^                                   ^

/// [ -1, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, 8, 26 ]  --->   [ -1, 0, 3, 8, 2, 14, 10, 27, 1, 5, 9, 8, 26 ]
//              L                       R                              ^                       ^

/// [ -1, 0, 3, 8, 2, 14, 10, 27, 1, 5, 9, 8, 26 ]  --->   [ -1, 0, 3, 8, 2, 5, 10, 27, 1, 14, 9, 8, 26 ]
//                    L              R                                       ^             ^

/// [ -1, 0, 3, 8, 2, 5, 10, 27, 1, 14, 9, 8, 26 ]  --->   [ -1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26 ]
//                       L       R                                              ^      ^

/// [ -1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26 ]
//                       R  L
//                                                                                  quicksortHoare(&array, low: low, high: partion)
///                                                      [ -1, 0, 3, 8, 2, 5, 1]    partion = 0
//                                                         LR                       quicksortHoare(&array, low: 0, high: 0) low == high stop recursion
///                                                           [0, 3, 8, 2, 5, 1]    quicksortHoare(&array, low: partion + 1, high: high)
//                                                             LR
///                                                             [ 3, 8, 2, 5, 1] -> [1, 8, 2, 5, 3] -> [1, 2, 8, 5, 3]
//                                                                L           R         L  R               R  L

///                                                                  [8, 5, 3] -> [3, 5, 8]
//                                                                    L     R         LR

///                                                                     [5,8]
//                                                                       LR

/// 5 == 5 stop recursion
// result [-1, 0, 1, 2, 3, 5, 8]
/******** version3 ******/
extension Array where Element: Comparable {
    public mutating func quickSortInPlace(sort: @escaping (Element, Element) -> Bool) {
        func partionHoare(low: Index, high: Index) -> Index {
            let pivot = self[low]
            var indexL = low - 1
            var indexR = high + 1
            while true {
                repeat { indexL += 1 } while sort(self[indexL], pivot)
                repeat { indexR -= 1 } while sort(pivot, self[indexR])
                if indexL < indexR {
                    swapAt(indexL, indexR)
                } else {
                    return indexR
                }
            }
        }
        func quickSortHoare(low: Index, high: Index) {
            if low < high {
                let partion = partionHoare(low: low, high: high)
                quickSortHoare(low: low, high: partion)
                quickSortHoare(low: partion + 1, high: high)
            }
        }
        quickSortHoare(low: startIndex, high: count - 1)
    }
}
