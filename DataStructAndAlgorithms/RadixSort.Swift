/**
 利用数组Index为基础排序,从个位数开始最后形成有序数组
 
 + 创建10个桶，然后按照基数入桶，基数的取值是从数字的低位到高位以此取值
 + 以无序序列数值的个数为基数，将无序序列中的值进入到基数对应的桶中。以51为例，如果取个位数为基数的话，51的基数就为1，那么51就进入如编号为1的桶中。以此类推，62在本轮入桶过程中就进入编号为2的桶中。
 + 个位数为基数入桶完毕后，在按装编号从小到大将桶中的数据以此取出，在存入之前的数组中
 + 在个位数生成的数组的基础上再以十位数为基数入桶。入桶完毕后，再次按照桶的编号顺序将数值取出
 
 ```
 0    1   2   3   4   5   6   7   8   9   10    ----> 0    1   2   3   4   5   6   7   8   9   10
 [62, 88, 58, 47, 62, 35, 73, 51, 99, 37, 93]         [   51  62  73      35      47  88  99    ]
  62  93              37  58
 
    0    1   2   3   4   5   6   7   8   9   10    ----> 0    1   2   3   4   5   6   7   8   9   10
 [ 51   62  62  73  93  35  47  37  88  58   99 ]         [           35  47  51  62  73  88  93     ]
 37      58  62
 [ 35, 37, 47, 51, 58, 62, 62, 73, 88, 93 ]
 
 
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

private func radixSort(list: inout [Int]) {           /// list [21, 1, 5, 15]
    var bucket = createBucket()                       /// [ [], [], [], [], []... ]
    let maxNumber = listMaxItem(list: list)           /// max 21
    let maxLength = numberLength(number: maxNumber)   /// maxLength 2
    for digit in 1...maxLength {                      /// forEach list 2
        for item in list {
            let baseNumber = fetchBaseNumber(number: item, digit: digit)
            bucket[baseNumber].append(item)
        }
        var index = 0
        for iii in 0..<bucket.count {
            while !bucket[iii].isEmpty {
                list[index] = bucket[iii].remove(at: 0)
                index += 1
            }
        }
    }
}
private func createBucket() -> [[Int]] {
    let bucket = [[Int]](repeating: [], count: 10)
    return bucket
}
///取基数入桶出桶的次数以此最大数值的位数为准
private func listMaxItem(list: [Int]) -> Int {
    var maxNumber = list[0]
    for item in list where maxNumber < item {
        maxNumber = item
    }
    return maxNumber
}
func numberLength(number: Int) -> Int {
    return "\(number)".count
}
func fetchBaseNumber(number: Int, digit: Int) -> Int {
    if digit > 0 && digit <= numberLength(number: number) {
        var numbersArray = [Int]()
        for char in "\(number)".unicodeScalars {        /// 21  -> [2, 1]
            numbersArray.append(Int("\(char)")!)        /// 基础位置 个位 array.count - 1 百位 array.count - 2
        }
        return numbersArray[numbersArray.count - digit]
    }
    return 0
}
var array = [2, 1, 5, 12]
radixSort(list: &array)
print(array)
