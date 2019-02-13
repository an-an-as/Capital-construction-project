/**二进制求和
 1101
 1111
 carry
 1 + 1 + 0 & 1 -> 0    2 >> 1 = 1
 0 + 1 + 1 & 1 -> 0    2 >> 1 = 1
 1 + 1 + 1 & 1 -> 1    3 >> 1 = 1
 1 + 1 + 1 & 1 -> 1    3 >> 1 = 1
 
 11100
 
 位运算就是直接对整数在内存中的二进制位进行操作
 sum 0
 0 & 1   0
 1 & 1   1
 2 & 1   0
 3 $ 1   1
 
 0 >> 1  0
 1 >> 1  0
 2 >> 1  1   2 进 1
 3 >> 1  1   3 进 1
 
 11
 110       0110   空位0补
 1011  ->  1011
 0010
 */
func addBinary(_ a: String, _ b: String) -> String {
    var carry: UInt32 = 0
    let scalarZero = Unicode.Scalar("0")!.value
    let charactersA = Array(a)
    let charactersB = Array(b)
    var indexA = charactersA.endIndex.advanced(by: -1)
    var indexB = charactersB.endIndex.advanced(by: -1)
    var result = [Character]()
    while indexA >= 0 || indexB >= 0 {
        var bitA: UInt32
        if indexA >= 0 {
            bitA = charactersA[indexA].unicodeScalars.first!.value - scalarZero
        } else {                                /// 1 - 0 -> 49 - 48
            bitA = 0
        }
        let bitB: UInt32
        if indexB >= 0 {
            bitB = charactersB[indexB].unicodeScalars.first!.value - scalarZero
        } else {
            bitB = 0
        }
        let tempSum = bitA + bitB + carry       /// 1 + 1 + 0
        let sum = tempSum & 1                   /// 2 &  1 = 0   a + b = 1 & 1 保留1  a + b = 0 & 1 保留0  a + b = 2 & 1 -> 0 2进1
        carry = tempSum >> 1                    /// 2 >> 1 = 1   2进1
        result.insert(Character(String(sum)), at: 0)
        indexA = indexA.advanced(by: -1)
        indexB = indexB.advanced(by: -1)
    }
    if carry == 1 {
        result.insert(Character(String(carry)), at: 0)
    }
    return String(result)
}
print(addBinary("1101", "1111"))
