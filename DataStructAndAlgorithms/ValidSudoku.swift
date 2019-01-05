/**
 判断是否有效
 数字 1-9 在每一行只能出现一次。
 数字 1-9 在每一列只能出现一次。
 数字 1-9 在每一个以粗实线分隔的 3x3 宫内只能出现一次。
 */
extension Array where Element == [String] {
    mutating func isValidSudoku() -> Bool {
        //check row
        for row in self {
            var nums = Set<String>()
            for element in row where element != "." {
                if !nums.insert(element).inserted { return false }
            }
        }
        //check column
        for rowIndex in indices {
            var nums = Set<String>()
            for index in self[rowIndex].indices where self[index][rowIndex] != "." {
                if !nums.insert(self[index][rowIndex]).inserted { return false }
            }
        }
        //check sub board  elementIndex -> rowIndex -> horizeonalStride -> verticalStride
        for verticalStride in stride(from: startIndex, to: endIndex, by: 3) {
            for horizonalStride in stride(from: startIndex, to: endIndex, by: 3) {
                var nums = Set<String>()
                for rowIndex in 0..<3 {
                    for elementIndex in 0..<3 where self[verticalStride + rowIndex][horizonalStride + elementIndex] != "." {
                        if !nums.insert(self[verticalStride + rowIndex][horizonalStride + elementIndex]).inserted { return false }
                    }
                }
            }
        }
        return true
    }
}
var suduku =
    [
        ["5","3",".",".","7",".",".",".","."],
        ["6",".",".","1","9","5",".",".","."],
        [".","9","8",".",".",".",".","6","."],
        ["8",".",".",".","6",".",".",".","3"],
        ["4",".",".","8",".","3",".",".","1"],
        ["7",".",".",".","2",".",".",".","6"],
        [".","6",".",".",".",".","2","8","."],
        [".",".",".","4","1","9",".",".","5"],
        [".",".",".",".","8",".",".","7","9"]
]
print(suduku.isValidSudoku())
/**
 
 strideH
 strideV
 rowIndex
 columnIndex
 self[verticalStride + rowIndex][horizonal + elementIndex]
 self[0 + >0<][0 + >1...3<]
 
 x x x
 
 self[0 + >1<][0 + 1...3]
 x x x
 x x x
 
 self[0 + >2<][0 + 1...3]
 x x x
 x x x
 x x x
 
 
 self[0 + 0][>3< + 1...3]
 x x x  x x x
 x x x
 x x x
 
 self[0 + 1][>3< + 1...3]
 x x x  x x x
 x x x  x x x
 x x x
 
 self[0 + 2][>3< + 1...3]
 x x x  x x x
 x x x  x x x
 x x x  x x x
 
 .....
 
 x x x  x x x  x x x  x x x
 x x x  x x x  x x x  x x x
 x x x  x x x  x x x  x x x
 
 
 self[3 + 0][0 + 1...3]
 self[3 + 1][0 + 1...3]
 self[3 + 2][0 + 1...3]
 x x x  x x x  x x x  x x x
 x x x  x x x  x x x  x x x
 x x x  x x x  x x x  x x x
 
 x x x
 x x x
 x x x
 
 
 self[3 + 0][3 + 1...3]
 self[3 + 1][3 + 1...3]
 self[3 + 2][3 + 1...3]
 x x x  x x x  x x x  x x x
 x x x  x x x  x x x  x x x
 x x x  x x x  x x x  x x x
 
 x x x  x x x
 x x x  x x x
 x x x  x x x
 */
