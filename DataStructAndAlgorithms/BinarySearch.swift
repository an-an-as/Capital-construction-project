/**
 # 随机存储协议
 **作用**: 能够在常数时间内跳转到任意索引
 
 **注意**: 满足协议的类型必须确保满足文档所要求的 O(1) 复杂度.
 + 可以通过(index(_:offsetBy:)方法,以任意距离移动一个索引;
 + 通过distance(from:to:)方法,测量任意两个索引间的距离;
 + 或者是通过使用一个满足 Strideable 的 Index 类型 (像是 Int)来实现.
 
 **区别**: 非线性操作
 + 对于 Collection 和 BidirectionalCollection，index(after:) 操作通过渐进的方式访问下一个索引，直到到达目标索引为止。
 这是一个线性复杂度的操作，随着距离的增加，完成操作需要消耗的时间也线性增长。
 + 而随机存取索引则完全不同，它可以直接在两个索引间进行移动。
 
 /// [限制在随机存取协议中的泛型二分搜索算法]
 ///
 /// **性能**: O(1)
 ///
 /// 随机存取的集合类型可以在常数时间内计算 startIndex 和 endIndex 之间的距离,遵守该协议可以避免从头到尾遍历集合的线性消耗
 ///
 /// **泛型**: 并不是所有集合都是以整数为索引的,通过泛型满足非整数索引要求
 ///
 /// **特点**: 通过距离的一般再加到左索引的上,可以搜索那些非基于零的索引的切片类型(ContiguousArray 或者 ArraySlice)
 ///
 ///     let arr = ["a","b","c","d","e","f","g"]
 ///     let rev = arr.reversed()
 ///     rev.binarySearch(value: "c", precondition: >) == arr.startIndex //true
 ///
 ///     let slice = arr[2..<5]
 ///     slice.startIndex // 2
 ///     slice.binarySearch(for: "d") // Optional(3)
 ///
 /// - Parameters:
 ///   - value: 需要查询的值
 ///   - precondition: 判断中间值和需要查询值的关系
 /// - Returns: 查询结果为可选值
 */
extension RandomAccessCollection {
    public func binarySearching(value: Element, precondition: (Element,Element) -> Bool) -> Index? {
        guard !isEmpty else { return nil }
        var cursorL = startIndex
        var cursorR = index(before: endIndex)
        while cursorL <= cursorR {
            let steps = distance(from: cursorL, to: cursorR)
            let mid = index(cursorL, offsetBy: steps / 2)
            let candicate = self[mid]
            if precondition(candicate, value) {
                cursorL = index(after: mid)
            } else if precondition(value, candicate) {
                cursorR = index(before: mid)
            } else {
                return mid
            }
        }
        return nil
    }
}
extension RandomAccessCollection where Element: Comparable {
    func binarySearched(value: Element) -> Index? {
        return binarySearching(value: value, precondition: <)
    }
}
var arr = ["a","b","c","d","e","f"]
arr.binarySearched(value: "a").map { print($0) }
arr.reversed().binarySearching(value: "a", precondition: >).map{ print($0) } ///ReversedIndex<Array<Int>>(base: 1)
debugPrint(arr.reversed().binarySearching(value: "f", precondition: >) == arr.reversed().startIndex) ///true
debugPrint (arr[2...5].startIndex ) ///2
arr[2...5].binarySearched(value: "f").map{ print("sliceIndex:\($0)") }///sliceIndex:5

///- Version: 2
extension RandomAccessCollection where Element: Comparable {
    /// 不断缩小范围直到CursorL和CursorR重合
    /// 1. 如果目标值大于重合值CursorL右移后 CursorL > cursorR
    /// 2. 如果目标值小于重合值CursorR左移后 CursorL > cursorR
    func binarySearching(_ value: Element, precondition: @escaping(Element, Element) -> Bool) -> Index? {
        var cursorL = startIndex
        var cursorR = endIndex
        while cursorL < cursorR {
            let steps = distance(from: cursorL, to: cursorR)
            let midIndex = index(cursorL, offsetBy: steps / 2)
            let candidate = self[midIndex]
            if precondition(candidate, value) {
                cursorL = index(after: midIndex)
            } else if precondition(value, candidate) {
                cursorR = midIndex
            } else {
                return midIndex
            }
        }
        return nil
    }
    /// 不断缩小范围直到CursorL和CursorR重合
    /// 1. 如果目标值大于重合值CursorL右移后 CursorL > cursorR 返回CursorL 在目标值的左侧
    /// 2. 如果目标值小于重合值CursorR左移后 CursorL > cursorR 返回CursorL 在目标值的右侧
    func binarySearching(_ value: Element) -> Index {
        var cursorL = startIndex
        var cursorR = endIndex
        while cursorL < cursorR {
            let steps = distance(from: cursorL, to: cursorR)
            let midIndex = index(cursorL, offsetBy: steps / 2)
            let candidate = self[midIndex]
            if value > candidate {
                cursorL = index(after: midIndex)
            } else {
                cursorR = midIndex
            }
        }
        return cursorL
    }
}
