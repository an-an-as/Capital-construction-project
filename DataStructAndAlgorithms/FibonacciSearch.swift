/**
 
 0    1   2   3   4   5   6   7   8   9   10  11  12
 [10, 20, 36, 39, 58, 79, 82, 98, 99, 99, 99, 99, 99]
 L&                                           &H  >              mid = low + 13 -1   =12   H= mid -1 =11
 L&                       &H  >                                  mid = low + 8  -1   =7    H= mid -1 =6
                  <   L&  &H                                     mid = low + 5  -1   =4    L= mid +1 =5
                      L&  &H  >                                  mid = 5   + 3  -1   =7    H= mid -1 =6
                          =                                      mid = 5   + 2  -1   =6
 */
import Foundation

func convertToFibonacciItems(number: Int) -> (count:Int,lastNum:Int,array:[Int]) {
    var fibonacci = sequence(state: (0,1)) { (state:inout(Int,Int)) -> Int in
        let current = state.0
        state = (state.1,state.0 + state.1)
        return current
    }
    var fibo = 0
    var temp:[Int] = []
    while number >=  fibo{
        if let num = fibonacci.next(){
            fibo = num
            temp.append(num)
        }
    }
    return (temp.count,fibo,temp)
}
func createFibonacciSearchTable(array:[Int],fiboNum:Int) -> [Int] {
    var temp:[Int] = array
    let difference = fiboNum - array.count
    (1 ... difference).forEach { _ in
        if let last = array.last{
            temp.append(last)
        }
    }
    return temp
}
func fibonacciSearch(_ array:[Int], _ element: Int) -> Int? {
    var fibo = convertToFibonacciItems(number: array.count)
    var fiboSearchTable = createFibonacciSearchTable(array: array, fiboNum: fibo.lastNum)
    var low = 0
    var high = array.count - 1
    while low <= high {
        let mid = low + fibo.array[fibo.count - 1] - 1
        if  fiboSearchTable[mid] > element{
            high = mid - 1
            fibo.count = fibo.count - 1
        }
        else if  fiboSearchTable[mid] < element  {
            low = mid + 1
            fibo.count = fibo.count - 2
        }
        else{
            let index =  mid < array.count ? mid : array.count - 1
            return index
        }
    }
    return nil
}

let array = [0,1,2,3,4]
fibonacciSearch(array, 2)
