/**
 压缩字符串
 输入：["a","a","b","b","c","c","c"]
 输出：返回6，输入数组的前6个字符应该是：["a","2","b","2","c","3"]
 
 ["a","b","b","b","b","b","b","b","b","b","b","b","b"]
 ["a","b","1","2"]
 
 说明："aa"被"a2"替代。"bb"被"b2"替代。"ccc"被"c3"替代
 在完成原地修改输入数组后，返回数组的新长度
 */
extension Array where Element == Character {
    mutating func compress() -> [Character] {
        var temp = self
        var cursorL = startIndex
        var cursorR = startIndex
        var writeIndex = startIndex  /// cursorL 和 cursorR 用于统计数量 currentIndex用于修改
        func write(_ character: Character, characterCount: Int) {
            temp[writeIndex] = character
            writeIndex += 1
            if characterCount > 9 {
                let result = characterCount.quotientAndRemainder(dividingBy: 10)
                temp[writeIndex] = Character(String(result.quotient))
                temp[writeIndex + 1] = Character(String(result.remainder))
                writeIndex += 2                                      ///              a a a c
            } else if characterCount > 1 {                             /// cursorL      ^
                temp[writeIndex] = Character(String(characterCount)) /// cursorR            ^   sum3
                writeIndex += 1                                      /// currentIndex   ^
            }
        }
        for index in startIndex...endIndex {
            if index == endIndex {
                let sum = cursorR - cursorL
                write(temp[cursorL], characterCount: sum)
            } else {
                if temp[cursorL] != temp[cursorR] {
                    let sum = cursorR - cursorL
                    write(temp[cursorL], characterCount: sum)
                    cursorL = cursorR
                }
            }
            cursorR += 1
        }
        return Array(temp[startIndex..<writeIndex])
    }
    
}
var str: [Character] = ["a", "a", "a", "c", "c", "a"]
print(str.compress())
