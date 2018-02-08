import Foundation
extension Array where Element: Comparable {
    private mutating func merge(left: Int, middle: Int, right: Int) {
        var tempArray: [Element] = []
        var l = left, m = middle
        while l != middle && m != right {
            if self[m] < self[l] {
                tempArray.append(self[m])
                m += 1
            }
            else {
                tempArray.append(self[l])
                l += 1
            }
        }
        tempArray.append(contentsOf: self[l..<middle])
        tempArray.append(contentsOf: self[m..<right])
        replaceSubrange(left..<right, with: tempArray)
    }
    mutating func mergeSortInPlaceInefficient() {
        let arrayCount = count
        var size = 1
        while size < arrayCount {
            for strideLeft in stride(from: 0, to: arrayCount - size, by: size*2) {
                merge(left: strideLeft, middle: (strideLeft+size), right: Swift.min(strideLeft+size*2,arrayCount))
            }
            size *= 2
        }
    }
}
var array = [3,1,2,5,6]
array.mergeSortInPlaceInefficient()

Swift.min(10, 100)
/**
 [0][1][2][3][4]
 3  1  2  5  6
 
 *size1
 lo:0 mi:1 hi:2   [0][1][2]
 l = lo:0          3  1  2
 m = mi:1
 l != m && m != hi
 self[m]<self[l] r+=1
 l:0 m:2 h:2     temp:[1]
 self[l..<mi]= 3 temp:[1,3]
 self[m..<hi]= 2 temp:[1,3]
 replaceSubrange:lo..<hi
 [0][1] [2][3][4]
 1  3   2  5  6
 
 lo:2 mi:3 hi:4   [2][3][4]
 l = lo:2          2  5  6
 m = mi:3
 l != m && m != hi
 self[m]<self[l] m+=1
 else l+=1       temp[2]
 l:3 m:3 r:4
 self[l..<mi]= 3 temp:[2,5]
 self[m..<hi]= 2 temp:[2,5]
 replaceSubrange: lo..<hi
 [0][1] [2][3] [4]
 1  3   2  5   6
 
 *size2
 lo:0 mi:2 hi:4   [0][1] [2] [3][4]
 l = lo:0          1  3   2   5  6
 m = mi:2
 l != m && m != hi
 self[m]<self[l] m+=1       self[2]<self[1]  temp[1,2]   m+=1  m3 != 4
 else l+=1  1!=2  temp[1]
 l+1 = mid2
 l:2 m:3 r:4
 self[l..<mi]= 3 temp:[]
 self[m..<hi]= 2 temp:[1,2,3,5]
 replaceSubrange: lo..<hi
 [0][1] [2][3] [4]
 1  2   3  5   6
 
 lo:2 mi:4 hi:5   [0][1][2][3] [4]
 l = lo:0          1  2  3  5   6
 m = mi:4
 l != m && m != hi
 self[m]<self[l] m+=1
 else l+=1  1!=2  temp[1,2,3,5]
 
 l:4 m:4 r:4
 self[l..<mi]= 3 temp:[]
 self[m..<hi]= 2 temp:[1,2,3,5,6]
 replaceSubrange: lo..<hi
 [0][1] [2][3] [4]
 1  2   3  5   6
 
 *size4
 lo:0 mi:4 hi:5   [0][1] [2] [3][4]
 l = lo:0          1  2   3   5  6
 m = mi:2
 l != m && m != hi
 self[m]<self[l] m+=1
 else l+=1  1!=2  temp[1]
 l+1 = mid2
 l:2 m:3 r:4
 self[l..<mi]= 3 temp:[]
 self[m..<hi]= 2 temp:[1,2,3,5]
 replaceSubrange: lo..<hi
 [0][1] [2][3] [4]
 1  2   3  5   6
 
 */
