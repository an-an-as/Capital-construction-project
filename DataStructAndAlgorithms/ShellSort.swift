/**
 希尔排序是插入排序的升级版,希尔排序根据其排序的特点又叫做缩小增量排序
 希尔排序的大体步骤就是先将无序序列按照一定的步长（增量）分为几组，分别将这几组中的数据通过插入排序的方式将其进行排序
 然后缩小步长（增量）分组，然后将组内的数据再次进行排序。知道增量为1位置。经过上述这些步骤，我们的序列就是有序的了
 其实插入排序就是增量为1的希尔排序,在增量为1之前进行部分的排序
 O(n^3/2)  原来在无序数列中遍历 O(n) 的操作 在有序数列中遍历也是O(n)的操作  现在把遍历无序的操作折半非线性操作
 不从最左开始 而是由数组.count/2 决定开始 先排序  排好后最后 step = 1 的时候可以 更多的跳过 while进行交换操作*/
import Foundation
func shellsort(_ items: [Int]) -> [Int] {
    var list = items
    var step: Int = list.count / 2
    while step > 0 {
        for index in 0..<list.count {
            var cursor = index + step
            while cursor >= step && cursor < list.count {
                if list[cursor - step] > list[cursor] {
                    let temp = list[cursor]
                    list[cursor] = list[cursor - step]
                    list[cursor - step] = temp
                    cursor -= step
                } else {
                    break
                }
            }
        }
        step /= 2
    }
    return list
}
print(shellsort([5, 1, 3, 2]))
/// [5, 1, 3, 2]  step = 2   ---->  [3, 1, 5, 2]
//   i     c                         ic

/// [3, 1, 5, 2]  step = 2   ---->  [3, 1, 5, 2]
//      i     c                         ic

/// [3, 1, 5, 2]  step = 2   ---->  [3, 1, 5, 2]
//         i


/// [3, 1, 5, 2]  step = 1   ---->  [1, 3, 5, 2]
//   i                               i
//      c                            c

/// [1, 3, 5, 2]  step = 1   ---->  [1, 3, 5, 2]   ---->  [1, 3, 5, 2]
//      i                               i                     i
//         c                            c                  c


/// [1, 3, 5, 2]  step = 1   ---->  [1, 3, 2, 5]   ---->  [1, 3, 2, 5]   ---->  [1, 2, 3, 5]
//         i                               i                     i                     i
//            c                            c                  c                  c

extension Array {
    public mutating func shellSortInPlace(sort: (Element, Element) -> Bool) {
        var step = count / 2
        while step > 0 {
            for index in 0..<count {
                var cursor = index + step
                while cursor >= step && cursor < count {
                    if sort(self[cursor], self[cursor - step]) {
                        swapAt(cursor, cursor - step)
                    }
                    cursor -= step
                }
            }
            step /= 2
        }
    }
}
var temp = [Int]()
(1...10).forEach { _ in
    let num = Int(arc4random() % 100)
    temp.append(num)
}
temp.shellSortInPlace(sort: <)
print(temp)
