extension String {
    ///反转字符串
    func reverseString() -> String {
        var characters = Array(self)
        var startIndex = 0
        var lastIndex = count - 1
        while startIndex < lastIndex {
            let char = characters[startIndex]
            characters[startIndex] = characters[lastIndex]
            characters[lastIndex] = char
            startIndex += 1
            lastIndex -= 1
        }
        return String(characters)
    }
    ///反转每个单词
    func reverseWords() -> String {
        let stringArray = split(separator: " ")
        var result = [String]()
        stringArray.forEach {
            let reversed = String($0).reverseString()
            result.append(reversed)
        }
        return result.joined(separator: " ")
    }
}
let result = "Let's take LeetCode contest".reverseWords()
print(result)

//字符串划分区间进行翻转
func reverseStr(_ s: String, _ k: Int) -> String {
    var characters = Array(s)
    var index = 0
    while index < characters.count {
        reverse(&characters, index, min(index + k - 1, characters.count - 1))
        index += 2 * k
    }
    return String(characters)
}
func reverse(_ arr: inout [Character], _ startIndex: Int, _ endIndex: Int) {
    var start = startIndex
    var end = endIndex
    while start <= (startIndex + endIndex) / 2 {
        (arr[start], arr[end]) = (arr[end], arr[start])
        start += 1
        end -= 1
    }
}
var str = "abcdefg"
let result = reverseStr(str, 3)
print(result)
// ba cd fe g   k=2
// cba defg

/**
 abcdefg k = 2
 index0  startIndex 0  endIndex:  min 0 + 2 - 1  7 - 1  ->  1
 startIndex <= ( startIndex + endIndex ) / 2 = 0
 arr[0] = arr[1]
 arr[1] = arr[0]  "ba cdefg"
 startIndex = 1  endIndex = 0
 startIndex >= ( 1 + 0 ) / 2 = 0
 index += 2 * K = 4
 index4  startIndex 4 endIndex:  min 4 + 2 - 1  7 - 1  -> 5
 startIndex <= (4 + 5) /2 = 4
 arr[4] = arr[5]
 arr[5] = arr[4]  "ba cd fe g"
 startIndex = 5 endIndex = 4
 startIndex >= (5 + 4) /2 = 4
 index += 2 * k = 8
 */
/// version: 2
/// 从字符串开头算起的每个 2k 个字符的前k个字符进行反转。
/// 如果有小于 2k 但大于或等于 k 个字符，则反转前 k 个字符，并将剩余的字符保持原样。

/// k..<2k
/// 2..<4 反转前2个 保留2..<4
func reverseStr2(_ s: String, _ k: Int) -> String {
    var characters = Array(s)
    var result = [Character]()
    for index in stride(from: 0, to: characters.count, by: 2 * k) {
        if characters.count - index < k {
            result += characters[index..<characters.count].reversed()
            break
        }
        result += characters[index..<index + k].reversed()  //每2k个字符的前k个字符反转
        if characters.count < index + 2 * k {
            result += characters[index + k..<characters.count]
            break
        }
        result += characters[index + k..<index + 2 * k]
    }
    return String(result)
}
/**
 ab cd ef g k = 2
 ba cd fe g
 index  stride 0  4
 7 - 0 > k2
 result += character[0...0 + 2] reversed   ba
 7 > 0 + k2 * 2
 result += character[0 + 2..<0 + 2 * 2]    ba cd
 
 7 - 4 > 2
 result += character[4..<4 + 2]
 */
print(reverseStr2(str, 2))
