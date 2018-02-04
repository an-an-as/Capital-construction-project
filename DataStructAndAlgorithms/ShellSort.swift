import Foundation

func shellsort(items: [Int]) -> [Int] {
    var list = items
    var step: Int = list.count / 2
    while  step > 0 {
        for r in 0..<list.count {
            var rs = r + step
            while rs >= step && rs < list.count {
                if list[rs - step] > list[rs] {
                    let temp = list[rs]
                    list[rs] = list[rs - step]
                    list[rs - step] = temp
                    rs -= step
                }
                else {
                    break
                }
            }
        }
        step /= 2
    }
    return list
}
shellsort(items:[5,3,2,1,6,7])

/// O(n^3/2)
///
/// step = 3    count =  5
/// r           = [0]  1   2   3   4   <5
/// rs          = [3]  4   5   6   rs  =  r + step
/// while rs      [3]  4  <5
/// compare       [0]  -  [3]
/// rs             0   >=  3?      rs  = rs - step
///
/// r           =  0  [1]  2   3   4   <5
/// rs          =  3  [4] <5
/// compare       [1]  -  [4]
/// rs             1   >=  3?      rs  = rs - step
/// step = 2
/// r    = 0  1  2  3   4   5   6
/// rs   = 2  3  4
///
/// step = 1    insertSort
