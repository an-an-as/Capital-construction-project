/**判断第一个字符串能不能由第二个字符串里面的字符构成
 canConstruct("a", "b") -> false
 canConstruct("aa", "ab") -> false
 canConstruct("aa", "aab") -> true
 */
func canConstruct(_ ransomNote: String, _ magazine: String) -> Bool {
    guard magazine.count >= ransomNote.count else { return false }
    var temp = magazine
    for element in ransomNote {
        if let index = temp.index(of: element) {
            temp.remove(at: index)
        } else {
            return false
        }
    }
    return true
}
