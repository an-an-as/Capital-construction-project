// 最后单词长度
func lengthOfLastWord(_ s: String) -> Int {
    var count = 0
    for c in s.reversed() {
        if count == 0, c == " " { continue }
        if c == " " {
            return count
        } else {
            count += 1
        }
    }
    return count
}
_ = "hello world".split(separator: " ").last?.count ?? 0
