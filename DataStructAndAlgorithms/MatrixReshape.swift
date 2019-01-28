// 重置矩阵
// 两行三列
[1, 2]
[4, 5]
[7, 8]

[1, 2, 4]
[5, 7, 8]
func matrixReshape(_ nums: [[Int]], newRow: Int, newColumn: Int) -> [[Int]] {
    let sourceRow = nums.count
    let sourceColumn = nums[0].count
    if (sourceRow == newRow && sourceColumn == newColumn) || sourceRow * sourceColumn != newRow * newColumn { return nums }
    var result = [[Int]]()
    var index = 0
    for _ in 0..<newRow {
        var newRow = [Int]()
        for _ in 0..<newColumn {                                            /// sourceColumn 2
            newRow.append(nums[index / sourceColumn][index % sourceColumn]) /// nums[ 0 / 2 ][0 % 2] = nums[0][0]
            index += 1                                                      /// nums[ 1 / 2 ][1 % 2] = nums[0][1]
        }                                                                   /// nums[ 2 / 2 ][2 % 2] = nums[1][0]
        result.append(newRow)
    }                                                                       /// nums[ 3 / 2 ][3 % 2] = nums[1][1]
    return result                                                           /// nums[ 4 / 2 ][4 % 2] = nums[2][0]
}                                                                           /// nums[ 5 / 2 ][5 % 2] = nums[2][1]
var matrix = [[1, 2], [4, 5], [7, 8]]
let result = matrixReshape(matrix, newRow: 2, newColumn: 3)
print(result)
