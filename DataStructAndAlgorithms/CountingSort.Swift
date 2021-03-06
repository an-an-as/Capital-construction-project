/**
 Harold H. Seward 1954
 计数排序是一种非常快捷的稳定性强的排序方法，时间复杂度O(n+k),其中n为要排序的数的个数，k为要排序的数的组大值。
 计数排序对一定量的整数排序时候的速度非常快，一般快于其他排序算法。
 但计数排序局限性比较大，只限于对整数进行排序。
 计数排序是消耗空间发杂度来获取快捷的排序方法，其空间发展度为O（K）同理K为要排序的最大值。
 
 计数排序的基本思想为一组数在排序之前先统计这组数中其他数小于这个数的个数，则可以确定这个数的位置。
 例如要排序的数为 7 4 2 1 5 3 1 5；则比7小的有7个数，所有7应该在排序好的数列的第八位，同理3在第四位，
 对于重复的数字，1在1位和2位（暂且认为第一个1比第二个1小），5和1一样位于6位和7位。
 
 需要三个数组，第一个数组记录A要排序的数列大小为n，
 第二个数组B要记录比某个数小的其他数字的个数所以第二个数组的大小应当为K（数列中最大数的大小）
 第三个数组C为记录排序好了的数列的数组，大小应当为n
 
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
func countingSort(_ array: [Int]) -> [Int] {
    guard array.count > 0 else {return []}  /// [3, 2, 5, 1]
    let maxElement = array.max() ?? 0       /// maxElement: 5
    var countArray = [Int](repeating: 0, count: Int(maxElement + 1))
    for element in array {                  /// countArray [0, 0, 0, 0, 0, 0]  1..< countArray.count 总标记可为5
        countArray[element] += 1            ///             0  1  2  3  4  5   index 即为array数字 所有需要有足够的空间 max + 1
    }                                       // countArray [0, 1, 1, 1, 0, 1]   开始计数标记array数字出现的个数
    for index in 1 ..< countArray.count {                     ///  1  2  3  4  5   统计比各个数小的数量 例如array中比3小的数字就有2个,则3应该出现在第三位
        let sum = countArray[index] + countArray[index - 1]   ///  countArray[1] + countArray[0] = 1
        countArray[index] = sum                               ///  countArray[2] + countArray[1] = 2
    }                                                         ///  countArray[3] + countArray[2] = 3
    print(countArray)                                         ///  countArray[4] + countArray[3] = 3
    var sortedArray = [Int](repeating: 0, count: array.count) ///  countArray[5] + countArray[4] = 4
    for element in array {                                    //   0   1  2  3  4  5
        countArray[element] -= 1                              //   [0, 1, 2, 3, 3, 4]
        sortedArray[countArray[element]] = element            //   sortedArray [0, 0, 0, 0]
    }                                                         ///  3,  2,  5,  1
    return sortedArray                                        ///  countArray[3] -= 1  -->  2   除去自身
}                                                             ///                               sortedArray[2] = 3   比3小的数字有2个 放在数组第三位
var temp = [3, 2, 5, 1]                                       ///  countArray[2] -= 1  -->  1
print(countingSort(temp))                                     ///                               sortedArray[1] = 2
                                                              ///  countArray[5] -= 1  -->  3
                                                              ///                               sortedArray[3] = 5
                                                              ///  countArray[1] -= 1  -->  0
                                                              ///                               sortedArray[0] = 1
                                                               //   0   1   2   3
                                                               //  [1   2   3   5]
/******************************* version2 **********************************/
extension Array where Element == Int {
    ///将无序的值作为数组的Index,并标记数量,统计小于当前值的个数即为数组中的位置
    ///1. 建立默认值为0的数组Bucket,其个数为无序数组中的最大值
    ///2. 遍历无序数组其值为Bucket的Index,在其Index下记录该值出现的次数
    ///3. 遍历Bucket(从1开始)统计小于当前值的个数
    ///- complexity: O(n + k)
    mutating func countSort() {
        guard let maxNumber = self.max() else { return }
        var bucket = [Element](repeating: 0, count: maxNumber.advanced(by: 1))
        forEach { bucket[$0] += 1 }
        (1..<bucket.endIndex).forEach {
            let sum = bucket[$0] + bucket[$0 - 1]
            bucket[$0] = sum
        }
        forEach {
            bucket[$0] -= 1
            self[bucket[$0]] = $0
        }
    }
}
var interges = (1...10).map { _ in Int.random(in: 1...1_000) }
print(interges)
interges.countSort()
print(interges)
