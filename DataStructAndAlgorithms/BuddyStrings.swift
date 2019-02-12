// 是否存在 字符串A中交换2个字母就和B相等
func buddyStrings(_ A: String, _ B: String) -> Bool {
    let lenA = A.count
    let lenB = B.count
    if lenA != lenB {
        return false
    }
    if A == B  { /// "aa", "aa"
        if Set(A).count < lenA {
            return true
        }
        return false
    }
    var arrA = Array(A)
    var arrB = Array(B)
    var temp = [Int]()
    for index in 0..<lenA {
        if arrA[index] != arrB[index] {
            if temp.count == 2 {
                return false
            }
            temp.append(index)
        }
    }
    return temp.count == 2 && arrA[temp[0]] == arrB[temp[1]] && arrA[temp[1]] == arrB[temp[0]]
}
