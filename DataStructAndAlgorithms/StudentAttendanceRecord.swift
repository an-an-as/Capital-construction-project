/**
 缺勤不超过1次 不能连续迟到2次
 'A' : Absent， 缺勤
 'L' : Late，   迟到
 'P' : Present，到场
 */
func checkRecord(_ s: String) -> Bool {
    var absentCount = 0
    var continueLateCount = 0
    var lastIndex = -1
    for (index, element) in s.enumerated() {
        if element == "A" { absentCount += 1 }
        if element == "L" {
            if index - 1 != lastIndex { continueLateCount = 0 } ///不连续重新计数
            continueLateCount += 1
            lastIndex = index
        }
        
        if absentCount > 1 || continueLateCount > 2 { return false }
    }
    
    return true
}
/**
 P P A L L P
 index3  index - 1 != lastIndex   cursor = 0  cursor = 1   lastIndex = 3
 index4  index - 1 == lastIndex   cursor = 2  lastIndex = 4
 index5  index - 1
 
 */
print(checkRecord("PPALLP"))
