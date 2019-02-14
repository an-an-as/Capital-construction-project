/**
 日志数组排序 使得所有字母日志都排在数字日志之前 字母日志按字母顺序排序忽略标识符 数字日志应该按原来的顺序排列
 每条日志第一个字为字母数字标识符
 标识符后面的每个字将仅由小写字母组成
 或者标识符后面的每个字将仅由数字组成
 ["a1 9 2 3 1", "g1 act car", "zo4 4 7", "ab1 off key dog", "a8 act zoo"]
 ["g1 act car", "a8 act zoo", "ab1 off key dog", "a1 9 2 3 1", "zo4 4 7"]
 */
func reorderLogFiles(_ logs: [String]) -> [String] {
    var letterArray = [String]()
    var numberArray = [String]()
    let sclar0 = "0".unicodeScalars["0".startIndex].value
    let sclar9 = "9".unicodeScalars["9".startIndex].value
    for log in logs {
        var srr = log.split(separator: " ")
        let sclarFirst = srr[1].unicodeScalars[srr[1].startIndex].value ///srr[1]忽略标识符
        if sclarFirst >= sclar0 && sclarFirst <= sclar9 {
            numberArray.append(log)
        }else {
            letterArray.append(log)
        }
    }
    letterArray.sort { (a, b) -> Bool in
        let a1 = a[a.index(of: " ")!..<a.endIndex] ///"a1 9 2 3 1" 从第一个空格开始往后排序
        let b1 = b[b.index(of: " ")!..<b.endIndex]
        return a1 < b1
    }
    return letterArray + numberArray
}

let letter = ["a1 9 2 3 1", "g1 act car", "zo4 4 7", "ab1 off key dog", "a8 act zoo"]
let result = reorderLogFiles(letter)
print(result)

let index = "ex".index(of: "e")!
print("ex".unicodeScalars[index].value)

let a = "a1 9 2 3 1"
let a1 = a[a.index(of: " ")!..<a.endIndex]
print(a1) //9231
