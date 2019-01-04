/// % 10 未达到10的返回本身
/// / 10 未达到10的返回0
extension Array where Element == Int {
    mutating func plusOne() {
        if isEmpty { return }
        var plusOne = 1
        for index in indices.reversed(){
            let sum = self[index] + plusOne
            self[index] = sum % 10
            plusOne = sum / 10
            if plusOne == 0 { return }
        }
        insert(1, at: startIndex)
    }
}
var num = [1, 2, 9]
num.plusOne()
print(num)
/**
 digits = [1, 2, 9]
 
 0..<3.reversed --> 2, 1, 0
 sum = digits[2] + 1 = 10
 digits[2] = sum % 10 = 0 --> [1, 2, 0]
 one = sum / 10 = 1
 
 sum = digits[1] + 1 = 3
 digits[1] = sum % 10 = 3 --> [1, 3, 0]
 one = sum / 10 = 0
 one == 0  return
 */
