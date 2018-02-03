import Foundation

func insertSort(_ items:Array<Int>)->Array<Int>{
    var list = items
    for r in 1..<list.count{
        var l = r
        while l > 0 {
            if list[l - 1] > list[l]{
                let temp = list[l]
                list[l] = list[l - 1]
                list[l - 1] = temp
                l =  l - 1
            }
            else{
                break
            }
        }
    }
    return list
}
