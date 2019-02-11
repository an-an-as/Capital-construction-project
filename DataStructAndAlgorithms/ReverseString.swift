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
