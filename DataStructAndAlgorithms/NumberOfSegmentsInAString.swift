// 单词个数
func countSegments(_ s: String) -> Int {
    if s == nil || s.count == 0 {return 0}
    var word:Int = 0
    var count:Int = 0
    for i in s.indices {
        if s[i] == " " {
            if word > 0 {
                count += 1
                word = 0
            }
        } else {
            word += 1
        }
    }
    if word > 0 {
        count += 1
    }
    return count
}

let literals = "Hello, my name is John".split(separator: " ")
var temp = [String]()
for element in Array(literals) {
    if element.last == "," {
        let new = element.dropLast()
        temp.append(String(new))
        continue
    }
    temp.append(String(element))
}
print(temp)
//["Hello", "my", "name", "is", "John"]
