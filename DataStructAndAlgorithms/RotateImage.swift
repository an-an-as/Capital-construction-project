/** 旋转90度
 1  2  3         7  4  1    把 1 2 3 换到左侧然后反转到右侧
 4  5  6   --->  8  5  2
 7  8  9         9  6  3
 
 
 1  2  3         1  4  3                      1  4  7
 4  5  6   --->  2  5  6        --->          2                        ---reverse-->    7   4   1
 7  8  9         7  8  9                      3                                         2   5   6
 temp = self[0][1] = 2        temp = self[0][2] = 3                                     3   8   9
 self[0][1] = self[1][0]      self[0][2] = self[2][0]
 self[1][0] = temp            self[2][0] = temp
 
 
 1  4  7         1  4  7
 2  5  6   --->  2  5  8                      ---reverse--->   7  4  1
 3  8  9         3  6  9                                       8  5  2
 temp = self[1][2] = 6                                         3  6  9
 self[1][2] = self[2][1]
 self[1][0] = temp
 
 
 ---reverse--->
 7  4  1
 8  5  2
 9  6  3
 
 Time  Complexity: O(n^2)
 Space Complexity: O(1)
 */
extension Array where Element == [Int] {
    mutating func rotateMatrix() {
        indices.forEach {
            for cursor in $0.advanced(by: 1)..<endIndex {
                let temp = self[$0][cursor]
                self[$0][cursor] = self[cursor][$0]
                self[cursor][$0] = temp
            }
            self[$0].reverse()
        }
    }
}
var matrix = [[1,2,3],[4,5,6],[7,8,9]]
matrix.rotateMatrix()
print(matrix)

// Flipping an image
/// 1. 翻转每一行: [0,1,1], [1,0,1], [0,0,0]
/// 2. 反转:      [1,0,0], [0,1,0], [1,1,1]
[1,1,0]
[1,0,1]
[0,0,0]

[1,0,0]
[0,1,0]
[1,1,1]
func flipAndInvertImage(_ A: [[Int]]) -> [[Int]] {
    var nums = A
    for (i, array) in nums.enumerated(){
        for (j, item) in array.reversed().enumerated(){
            nums[i][j] = item ^ 1
        }
    }
    return nums
}
///version 2
func flipAndInvertImage2(_ A: [[Int]]) -> [[Int]] {
    return A.map {
        $0.reversed().map { 1 - $0 }
    }
}

//转置矩阵
//矩阵的转置是指将矩阵的主对角线翻转，交换矩阵的行索引与列索引
///向左下角翻转
[1,2,3]
[4,5,6]
[7,8,9]

[1,4,7]
[2,5,8]
[3,6,9]
func transpose(_ A: [[Int]]) -> [[Int]] {
    var matrix = [[Int]](repeating: [], count: A[0].count) // [ [],[],[],[]  ]
    for index in A[0].indices {
        for cursor in A.indices {
            matrix[index].append(A[cursor][index])
        }
    }
    return matrix
}
let result = transpose2([[1,2,3],[4,5,6],[7,8,9]])
print(result)
