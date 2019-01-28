// 托普利茨矩阵
/// 如果一个矩阵的每一方向由左上到右下的对角线上具有相同元素，那么这个矩阵是托普利茨矩阵
[1,2,3,4]
[5,1,2,3]
[9,5,1,2]
func isToeplitzMatrix(_ matrix: [[Int]]) -> Bool {
    if matrix.count == 1 || matrix[0].count == 1 { return true }
    for index in 0..<matrix.count - 1 {
        for cursor in 0..<matrix[index].count - 1 where matrix[index][cursor] != matrix[index + 1][cursor + 1] {
            return false
        }
    }
    return true
}
