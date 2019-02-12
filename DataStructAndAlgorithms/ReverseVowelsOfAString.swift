// 反转原音字母
extension String {
    var reverseVowels: String {
        var literals = Array(self)
        var cursorL = literals.startIndex
        var cursorR = literals.count - 1
        func isVowel(_ char: Character) -> Bool {
            switch char {
            case "a","e","i","o","u","A","E","I","O","U":
                return true
            default:
                return false
            }
        }
        while cursorL < cursorR {
            if !isVowel(literals[cursorL]) {
                cursorL += 1
            } else if !isVowel(literals[cursorR]) {
                cursorR -= 1
            } else { /// 两索引均为元音
                (literals[cursorL], literals[cursorR]) = (literals[cursorR], literals[cursorL])
                cursorL += 1
                cursorR -= 1
            }
        }
        return String(literals)
    }
}
let result = "helo".reverseVowels
print(result)
var integers = [1, 2, 3]
(integers[0], integers[1]) = (integers[2], integers[2])
//3, 3, 3]
