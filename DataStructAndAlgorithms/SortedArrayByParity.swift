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
