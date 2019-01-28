/// 奇偶排序
func sortArrayByParity(_ A: [Int]) -> [Int] {
    var a = [Int]()
    var b = [Int]()
    for number in A {
        if number % 2 == 0 {
            a.append(number)
        } else {
            b.append(number)
        }
    }
    return a + b
}
var integers = (1...5).map { _ in Int.random(in: 1...10) }
print(integers)
_ = integers.partition { $0 % 2 == 0 }
print(integers)

// 数组的拆分
// 拆分数组 两两成对 两两比较取小 求和
func arrayPairSum(_ nums: [Int]) -> Int {
    var array = nums
    array.sort{$0 < $1}
    var sum = 0
    for i in 0..<array.count / 2 {
        sum = sum + array[i * 2]
    }
    return sum
}

func arrayPairSum2(_ nums: [Int]) -> Int {
    var array = nums
    array.sort{ $0 < $1 }
    var sum = 0
    for index in stride(from: 0, to: nums.count, by: 2) {
        sum = sum + array[index]
    }
    return sum
}
let result = arrayPairSum2([1, 2, 3, 4])
print(result)
