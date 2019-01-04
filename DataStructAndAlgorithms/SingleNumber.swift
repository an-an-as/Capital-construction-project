/// XOR
/// 1. 交换律：a ^ b = b ^ a
/// 2. 结合律：a ^ b ^ c = a ^ （b ^ c） = （a ^ b） ^ c
/// 3. 自反性：a ^ b ^ a = b
extension Array where Element == Int {
    func singleNumber() -> Int {
        var single = 0
        forEach {
            single = single ^ $0
        }
        return single
    }
}
extension Array where Element == Int {
    mutating func getSingleNumber() -> [Element] {
        func previous(_ element: Element, endIndex: Int) {
            for prevIndex in startIndex..<endIndex where self[prevIndex] == element {
                self[prevIndex] -= element
                for nextIndex in endIndex + 1 ..< self.endIndex where self[nextIndex] == element {
                    self[nextIndex] -= element
                }
                self[endIndex] -= element
            }
        }
        for (index, element) in enumerated() {
            previous(element, endIndex: index)
        }
        return self.filter { $0 != 0 }
    }
}
var nums = [3, 100, 3]
//print(integers.singleNumber())
//print( 6 ^ 6)      // 0
//print( 6 ^ 1 ^ 6)  // 1
//print(integers.single())
/**
 * 异或逻辑的关系是：当AB不同时，输出P=1；当AB相同时，输出P=0, 0和任何数异或返回任何数
 * 除了某个元素只出现一次以外，其余每个元素均出现两次,找出只出现了一次的元素
 * 该运算还可以应用在加密，数据传输，校验等等许多领域
 */
func singleNumber2(_ nums: [Int]) -> Int {
    var single = 0
    func isDifferenceL(_ element: Int, endIndex: Int) -> Bool {
        for prevIndex in 0..<endIndex where nums[prevIndex] == element  {
            return false
        }
        return true
    }
    func isDifferenceR(_ element: Int, currentIndex: Int) -> Bool {
        for nextIndex in currentIndex.advanced(by: 1) ..< nums.endIndex where nums[nextIndex] == element {
            return false
        }
        return true
    }
    for (index, element) in nums.enumerated() {
        if isDifferenceL(element, endIndex: index) && isDifferenceR(element, currentIndex: index) {
            single = element
        }
    }
    return single
}
print(singleNumber2([2, 2, 100, 3, 3]))
