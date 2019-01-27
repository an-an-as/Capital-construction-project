/// 杨辉三角
///
/// numRows 0 1 2... == row.lastIndex
func generate(_ numRows: Int) -> [[Int]] {
    var temp = [[Int]]()
    (0..<numRows).forEach {
        var newRow = [Int]()
        for index in 0...$0 {
            if index == 0 {
                newRow.append(1)
            } else if index == $0 {
                newRow.append(1)
            } else {
                let upperRow = temp[$0 - 1]
                let value =  upperRow[index] + upperRow[index - 1]
                newRow.append(value)
            }
        }
        temp.append(newRow)
        print(newRow)
    }
    return temp
}
generate(5)
[1]
[1, 1]
[1, 2, 1]
[1, 3, 3, 1]
[1, 4, 6, 4, 1]
