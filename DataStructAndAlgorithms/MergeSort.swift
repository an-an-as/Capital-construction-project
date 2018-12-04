/********************************************************************************************************************************************
 归并排序主要用了分治法的思想,将需要排序的数组进行拆分，将其拆分的足够小。当拆分的数组中只有一个元素时，则这个拆分的数组是有序的。
 然后将这些有序的数组进行两两合并，在合并过程中进行比较，合并生成的新的数组仍然是有序的。
 然后再次将合并的有序数组进行合并，重复这个过程，直到整个数组是有序的。
 
 1945 John von Neumann 首次提出 效率:O(n log n)
 
 ********************************************************************************************************************************************
 [1,3,2,4,5,9,7,10,6,8]
 0 1 2 3 4 5 6 7  8 9
 siza < count      排序好的元素数不能越界
 size *= 2         排序好的元素数量
 size * 2          排序好的元素 * 2  进行合并确定比较范围 *2表示需要比较两个已经排序好的
 count - size      确定在count内所能达到的最大比较范围次数  如果排序好的size为2 需要比较的每组范围是4  能生成比较组的数  4   8   12  16
 stride            每次遍历出的基准范围
 stride + size     确定下一个比较单元
 stride + size * 2 下一组需要比较的 当前比较单元和下一组的关系 如果size4 范围8 count5 越界 此时取count5 结束比较
 
 stride != stride + size &&  stride + size !=stride + size * 2 确定两组比较单元独立  eg: 36 27
 self[stride] > self[stride + size]  左右均为有序 如果左第一个数 > 右第一个数 自然右剩下的就比左第一个数小  stride + size  += 1 加入tempArray
 else stride += 1
 tempArray加入剩余的 stride..< stride + size  ; stride + seize ..< stride + size * 2
 替换原数组stride..<stride + size * 2
 
 
 ********************************************************************************************************************************************
 1.拆分为单个两两比较后
 Split:         [1,3,   2,4    5,9   7,10   6,8]
 ArrayIndex:     01     23     45     67     89
 Compare:
 Merge:
 Result:        [1,3,   2,4    5,9   7,10   6,8]
 
 2.将两个已经排序好的单元两两比较
 Split:       [1,2,3,4,   5,7,9,10    6,8]
 ArrayIndex:    0123        4567      8 9
 
 3. 重复
 [1,2,3,4,5,7,9,10   6,8]          size4
 
 4. 结果
 [1,2,3,4,5,6,7,8,9,10]            size8
 
 size 1
 stride = size * 2       0   2   4   6   8  to count(10)-size = 9
 left:stride             mid:stride + size                      end: stride + size * 2  |  count(10)
 0                       1                                      2    if   left != mid   mid != end   self[left] > self[mid]   tempArray.append(self[mid])   mid + 1
 2                       3                                      4    else tempArray.append(self[left])  left + 1
 4                       5                                      7    temp [1]
 6                       7                                      9    tempArray.append(contentsOf: self[l..<middle])    left  += 1  返回空
 8                       9                                      10   tempArray.append(contentsOf: self[m..<endIndex])  right += 1  返回空   temp[1,3]
 replaceSubrange(left..<endIndex, with: tempArray) 替换原有数组
 [1,  3,   2,   4    5,    9   7,  10   6,  8]
 >0   1   -2-   3<   4    5    6   7<   8   9
 size 2
 stride = size * 2       0   4              to count(10)-size = 8
 left:stride             mid:stride + size                      end: stride + size * 2  |  count(10)
 0                       2                                      4   if  left != mid   mid != end   self[left] > self[mid]   tempArray.append(self[mid])   mid + 1 temp:[1,2]
 4                       6                                      8   else tempArray.append(self[left])  left + 1  temp: [1]  temp: [1,2,3]
 _                                                                  tempArray.append(contentsOf: self[l..<middle])    left  += 1  返回空
 8                       10                                     12  tempArray.append(contentsOf: self[m..<endIndex])    mid != end  temp[1,3] temp: [1,2,3,4]
 temp [1,2,3,4,  5,7,9,10]
 replaceSubrange(left..<endIndex, with: tempArray) 替换原有数组
 [1,  2,  3,  4,   5,  7,  9,  10    6,  8]
 >0   1   2   3   -4-  5   6    7    8<  9
 size 4
 stride = size * 2       0   8              to count(10)-size = 6
 left:stride             mid:stride + size                      end: stride + size * 2  |  count(10)
 0                       4                                      8    temp[1,2,3,4,5]
 [1,  2,  3,  4,   5,  7,  9,  10    6,   8]
 >0   1   2   3    4   5   6    7   -8-   9
 
 
 size 8
 stride = size * 2       0   8              to count(10)-size = 2
 left:stride             mid:stride + size                      end: stride + size * 2  |  count(10)
 0                       8                                      count = 10
 [1,2,3,4,5,6]
 [1,2,3,4,5,6,7,8]
 [1,2,3,4,5,6,7,8,9,10]
 
 ************************************************************************************************************************************************************************/
import Foundation
extension Array where Element:Comparable {
    mutating func mergeSortInPlace() {
        var tempArr = [Element]()
        tempArr.reserveCapacity(count)
        func merge(currentStride: Index, nextNeedComparied: Index, endIndex: Index) {
            tempArr.removeAll(keepingCapacity: true)
            var cursorL = currentStride
            var cursorR = nextNeedComparied
            while cursorL < nextNeedComparied && cursorR < endIndex {
                if self[cursorL] > self[cursorR] {
                    tempArr.append(self[cursorR])
                    cursorR += 1
                } else {
                    tempArr.append(self[cursorL])
                    cursorL += 1
                }
            }
            tempArr.append(contentsOf: self[cursorL..<nextNeedComparied])
            tempArr.append(contentsOf: self[cursorR..<endIndex])
            replaceSubrange(currentStride..<endIndex, with: tempArr)
        }
        var size = 1
        let arrCount = count
        while size < arrCount {
            for stride in stride(from: 0, to: arrCount - size, by: size * 2) {
                merge(currentStride: stride, nextNeedComparied: stride + size, endIndex: Swift.min(stride + size * 2, arrCount))
            }
            size *= 2
        }
    }
    func mergeSort() -> [Element] {
        var clone = Array.init()
        clone.append(contentsOf: self)
        clone.mergeSortInPlace()
        return clone
    }
}
var arr = [Int]()
(0...20).forEach{ _ in
    arr.append(Int(arc4random() % 1_00))
}
arr.mergeSortInPlace()
print(arr)
///[59, 155, 194, 230, 270, 289, 295, 324, 329, 374, 386, 391, 495, 513, 528, 575, 583, 641, 672, 680, 823]

//version swift4.2
extension Array {
    mutating func mergeSortInPlace(_ sort: @escaping (Element, Element) -> Bool) {
        var temp = [Element]()
        temp.reserveCapacity(count)
        func mergeSort(currentIndex: Index, nextNeedComparied: Index, endIndex: Index) {
            temp.removeAll(keepingCapacity: true)
            var cursorL = currentIndex
            var cursorR = nextNeedComparied
            while cursorL < nextNeedComparied && cursorR < endIndex {
                if sort(self[cursorL], self[cursorR]) {
                    temp.append(self[cursorL])
                    cursorL += 1
                } else {
                    temp.append(self[cursorR])
                    cursorR += 1
                }
            }
            temp.append(contentsOf: self[cursorL..<nextNeedComparied])
            temp.append(contentsOf: self[cursorR..<endIndex])
            replaceSubrange(currentIndex..<endIndex, with: temp)
        }
        var size = 1
        let arrayCount = count
        while size < count {
            for strideIndex in stride(from: 0, to: arrayCount - size, by: size * 2) {
                mergeSort(currentIndex: strideIndex, nextNeedComparied: strideIndex + size, endIndex: Swift.min(strideIndex + size * 2, count))
            }
            size *= 2
        }
    }
}
