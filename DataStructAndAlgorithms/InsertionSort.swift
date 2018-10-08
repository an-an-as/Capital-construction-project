/**
 从无序中取出一个数放入有序数列中 在有序队列中两两比较 直到 左边的值小于该值 由于有序剩余均小于 完成插入
 
 排序方法                 最好情况                最坏情况             平均情况              稳定性
 冒泡排序                 O(n)                   O(n2)              O(n2)                  稳定
 快速排序                 O(nlogn)               O(n2)              O(nlogn)             不稳定
 简单选择排序                                                        O(n2)                不稳定
 堆排序                                          O(nlogn)                                不稳定
 直接插入排序              O(n)                   O(n2)              O(n2)                  稳定
 希尔排序                                                           O(n1.3)               不稳定
 归并排序                 O(nlogn)               O(nlogn)           O(nlogn)               稳定
 基数排序                                                           O(d(r+n))              稳定
 
 空间复杂度
 + 简单排序和堆排序都是0(1)
 + 快速排序为0(logn)，要为递归程序执行过程栈所需的辅助空间
 + 归并排序和基数排序所需辅助空间最多，为O(n)
 ---------------------------------------------------------
 */
import Foundation
func insertionSort(_ items: [Int]) -> [Int] {
    var list = items
    for index in 1..<list.count {
        var cursor = index
        while cursor > 0 && list[cursor - 1] > list[cursor] {
            let temp = list[cursor]
            list[cursor] = list[cursor - 1]
            list[cursor - 1] = temp
            cursor -= 1
        }
    }
    return list
}
var array = [Int]()
(0...10).forEach { _ in
    let num = Int(arc4random() % 100)
    array.append(num)
}
print(insertionSort(array))
//    [1, 5, 7, 2]
///   [1, 5, 7, 2]     [1, 5, 7, 2]
///       i                   i
///       c                   c  同时步进

///   [1, 5, 7, 2]     [1, 5, 2, 7]     [1, 2, 5, 7]
///             i                i                i
///             c             c             c        探测到异象 启动cursor

/**************  version2 *************/
extension Array {
    public mutating func insertionSortInPlace(sort: (Element, Element) -> Bool) {
        for index in 1..<count {
            var cursor = index
            while cursor > 0 && !sort(self[cursor - 1], self[cursor]) {
                swapAt(cursor - 1, cursor)
                cursor -= 1
            }
        }
    }
}
array.insertionSortInPlace(sort: <)
print(array)
