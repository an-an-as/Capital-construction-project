import Foundation
func sort(items: Array<Int>) -> Array<Int> {
    var list = items
    if list.count > 0 {
        radixSort(list: &list)
    }
    return list
}
private func radixSort(list: inout Array<Int>) {
    var bucket = createBucket()
    let maxNumber = listMaxItem(list: list)
    let maxLength = numberLength(number: maxNumber)
    for digit in 1...maxLength {
        for item in list {
            let baseNumber = fetchBaseNumber(number: item, digit: digit)
            bucket[baseNumber].append(item)
        }
        var index = 0
        for i in 0..<bucket.count {
            while !bucket[i].isEmpty {
                list[index] = bucket[i].remove(at: 0)
                index += 1
            }
        }
    }
}
private func createBucket() -> [[Int]] {
    let bucket: [[Int]] = Array(repeatElement([], count: 10))
    return bucket
}
private func listMaxItem(list: Array<Int>) -> Int {
    var maxNumber = list[0]
    for item in list {
        if maxNumber < item {
            maxNumber = item
        }
    }
    return maxNumber
}
func numberLength(number: Int) -> Int {
    return "\(number)".count
}
func fetchBaseNumber(number: Int, digit: Int) -> Int{
    if digit > 0 && digit <= numberLength(number: number) {
        var numbersArray: Array<Int> = []
        for char in "\(number)".unicodeScalars {
            
            numbersArray.append(Int("\(char)")!)
        }
        return numbersArray[numbersArray.count - digit]
    }
    return 0
}
var array = [2,10,45,23,1,22]
sort(items: array)
