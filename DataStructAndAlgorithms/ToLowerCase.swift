// 大小写转换
/// ASCII
func toLowerCase(_ str: String) -> String {
    return String(str.unicodeScalars.map { (s) -> Character in
        if s.value >= 65 && s.value <= 90 {
            return Character(UnicodeScalar(s.value + 32)!)
        }
        return Character(UnicodeScalar(s))
    })
}
"abc".lowercased()
