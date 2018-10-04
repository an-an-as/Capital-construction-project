/**
 把乱序的数字放入对应的Index进行标记 到处标记的Index 得到有序数组
 
 ```
 
 排序方法                 最好情况                最坏情况             平均情况              稳定性       空间复杂度
 插入排序                 O(n)                   O(n2)              O(n2)                 稳定        O(1)
 选择排序                 O(n2)                  O(n2)              O(n2)                不稳定       O(1)
 希尔排序                 O(n)                   O(n2)              O(n1.3)              不稳定       O(1)
 
 快速排序                 O(nlogn)               O(n2)              O(nlogn)             不稳定       O(1)
 归并排序                 O(nlogn)               O(nlogn)           O(nlogn)               稳定       O(1)
 堆排序                   O(nlogn)               O(nlogn)           O(nlogn)             不稳定       O(1)
 
 冒泡排序                 O(n)                   O(n2)              O(n2)                  稳定       O(1)
 
 基数排序                O(n*k)                 O(n*k)              O(n*k)                 稳定          O(n+k)
 计数排序                O(n+k)                 O(n+k)              O(n+k)                 稳定          O(n+k)
 桶排序                  O(n)                   O(n2)               O(n+k)                 稳定          O(n+k)
 
 空间复杂度
 + 简单排序和堆排序都是0(1)
 + 快速排序为0(logn)，要为递归程序执行过程栈所需的辅助空间
 + 归并排序和基数排序所需辅助空间最多，为O(n)
 
 稳定：如果a原本在b前面，而a=b，排序之后a仍然在b的前面。
 不稳定：如果a原本在b的前面，而a=b，排序之后 a 可能会出现在 b 的后面。
 时间复杂度：对排序数据的总的操作次数。反映当n变化时，操作次数呈现什么规律。
 空间复杂度：是指算法在计算机内执行时所需存储空间的度量，它也是数据规模n的函数。
 
 */
func bucketSort(list: [Int]) -> [Int] {                       /// [1, 5, 2, 3]
    let maxNum = list.max()                                   /// maxNum: 5
    var bucket = [Int](repeatElement(0, count: maxNum! + 1))  /// [0, 0, 0, 0, 0, 0]
    var newNum = [Int]()
    for element in list {         /// 1 5 2 3                                  0  1  2  3  4  5
        let numId = element       /// bucket[1] = bucket[1] + 1 = 1   ---->   [0, 1, 1, 1, 0, 1, 0]
        bucket[numId] += 1        /// bucket[5] = bucker[5] + 1 = 1
    }                             /// ...
    for index in bucket.indices {  /// 0 1 2 3 4 5
        while bucket[index] > 0 {  /// bucket[0]
            newNum.append(index)   /// bucket[1] > 0  nuNum = [1]   bucket[1] = bucket[1] - 1 = 0
            bucket[index] -= 1
        }
    }
    return newNum
}
var temp = [1, 5, 2, 3]
print(bucketSort(list: temp))
