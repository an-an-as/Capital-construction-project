/// 反转字符串
extension String {
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
}
print( "hello world".reverseString() )
