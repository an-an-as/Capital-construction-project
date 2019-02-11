// 重复叠加字符串A 使其B成为其子串 即主串中找子串 KMP 算法
// A = "abcd"，B = "cdabcdab"。 重复叠加A三次 ab cdabcdab cd
func repeatedStringMatch(_ A: String, _ B: String) -> Int {
    guard A.count > 0 && B.count > 0 else {
        if A.count == 0 && B.count == 0 {
            return 0
        }
        return -1
    }
    let arrayA = Array(A)
    let arrayB = Array(B)
    for index in 0..<arrayA.count {
        var cursor = 0
        while cursor < arrayB.count && arrayA[( index + cursor) % arrayA.count] == arrayB[cursor] {
            cursor += 1
        }
        if cursor == arrayB.count {
            return ( index + cursor) % arrayA.count == 0 ? ( index + cursor) / arrayA.count : ( index + cursor) / arrayA.count + 1
        }
    }
    return -1
}

let result = repeatedStringMatch("abcd", "cdabcdab")
print(result)

/// abcd    cd abcd ab      abcd abcd abcd
/// index0  arrayA[ 0 + 0 % 4 ] = a  !=   arrayB[0] = c                 寻找c
/// index1  arrayA[ 1 + 0 % 4 ] = b  !=   arrayB[0] = c
/// index2  arrayA[ 2 + 0 % 4 ] = c  ==   arrayB[0] = c  cursor = 1     匹配判断
///         arrayA[ 2 + 1 % 4 ] = d  ==   arrayB[1] = d  cursor = 2
///         arrayA[ 2 + 2 % 4 ] = a  ==   arrayB[2] = a  cursor = 3
///         arrayA[ 2 + 3 % 4 ] = b  ==   arrayB[3] = b  cursor = 4
///         arrayA[ 2 + 4 % 4 ] = c  ==   arrayB[4] = c  cursor = 5
///         arrayA[ 2 + 5 % 4 ] = d  ==   arrayB[5] = d  cursor = 6
///         arrayA[ 2 + 6 % 4 ] = a  ==   arrayB[6] = a  cursor = 7
///         arrayA[ 2 + 7 % 4 ] = b  ==   arrayB[7] = b  cursor = 8
/// cursor == arrayB.count8
///         2+8 % 4 == 0  ?  2+8 / 4   2+8 / 4 + 1  =  3             abcd  abcdabcd  0+8%4 若存在余数则需要在叠加1层使其包含
let str = "abc"
let arr = Array(str) // ["a", "b", "c"]
