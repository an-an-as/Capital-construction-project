/**
 
 在选择排序过程中，数组仍然被分作有序和无序两部分。
 而选择排序中的“选择”是指不断从无序序列中选择最小的值放入到有序序列的最后的位置，
 换句话说就是从现有的无序序列中找出那个最小的值，然后与无序序列的第一个值进行交换，然后缩小无序序列的范围即可。
 
 
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
 ---------------------------------------------------------*/
import Foundation
func selectionSort(items: [Int]) -> [Int] {
    var list = items
    for index in 0..<list.count {
        var nextIndex = index + 1
        var min = list[index]
        var cursor = index
        while nextIndex < list.count {
            if list[nextIndex] < min {
                min = list[nextIndex]
                cursor = nextIndex
            }
            nextIndex += 1
        }
        if cursor != index {
            let temp = list[index]
            list[index] = list[cursor]
            list[cursor] = temp
        }
    }
    return list
}

var temp = [2, 5, 1]
print(selectionSort(items: temp))

/********************************************* version2 ******************************************************/
//  traversal 1
/// [2, 5, 1]  --->    [2, 5, 1]        swap --->  [1, 5, 2]
//      nI                    nI        探测最小值
//   sE                       sE = 1    记录当前最小值用于后续比较、如果比该值小就交换刚才的index值
//   sI                       sI = nI   记录当前最小值用于和index交换
//   I                  I               index存储无序数组中的最小的值

//  traversal 2
/// [1, 5, 2] swap --->  [1, 2, 5]      隔离出1 开始后续无序数组的选择
//         nI                   nI
//      sE                   sE
//      sI                   sI
//       I                    I
extension Array {
    /// 多重遍历(通过局部Tuple存储当前最小值及其Index)
    ///- complexity: O(n2)
    mutating func selectionSort(_ sort: @escaping(Element, Element) -> Bool) {
        indices.forEach {
            var nextIndex = index(after: $0)
            var min = ($0, self[$0])
            while nextIndex < endIndex {
                if sort(self[nextIndex], min.1)  {
                    min.0 = nextIndex
                    min.1 = self[nextIndex]
                }
                formIndex(after: &nextIndex)
            }
            swapAt(min.0, $0)
        }
    }
}
var integers = (1...10).map { _ in Int.random(in: 1...1_000) }
integers.selectionSort(<)
print(integers)
