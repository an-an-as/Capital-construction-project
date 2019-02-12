// 给定一个正整数 n（1 ≤ n ≤ 30），输出报数序列的第 n 项
/**报数
 1.     1
 2.     11
 3.     21
 4.     1211
 5.     111221
 后面的报前面的
 1  被读作  "one 1"  ("一个一") , 即 11。
 11 被读作 "two 1s" ("两个一"）, 即 21。
 21 被读作 "one 2",  "one 1" （"一个二" ,  "一个一") , 即 1211。
 */
var array = Array(repeating: "", count: 31)
array[0] = "0"
array[1] = "1"
for index in 2..<array.endIndex {
    var result = ""
    var previous = array[index - 1].map{ $0 }
    var temp = Character("*")
    var count = 0
    while previous.count > 0 {
        let first = previous.removeFirst()
        if temp == Character("*") {  ///对第一个计数
            temp = first
            count += 1
        } else {
            if temp == first {      ///相同就累加计数直到不同
                count += 1
            } else {                ///出现不同 重新开始统计
                result.append(contentsOf: "\(count)\(temp)")
                temp = first
                count = 1
            }
        }
    }
    result.append(contentsOf: "\(count)\(temp)")
    array[index] = result
}
print(array)
/**
 1.     1
 2.     11      prev = 1  removeFirst-> 1  temp = 1       count = 1  result.append(count1 temp1) array[result]
 3.     21      prev = 11 removeFirst-> 1  temp = 1       count = 1
 removeFirst-> 1  first = temp   count = 2  result.append(21) array[11, 21]
 4.     1211    prev = 21 removeFirst-> 2  temp = 2       count = 1
 removeFirst-> 1  first != temp  result = "12"
 temp = 1 count = 1  result = 1211 array[11, 21, 1211]
 5.     111221  prev = 1211
 removeFirst-> 1  temp = 1       count = 1
 removeFirst-> 2  != temp1       result = "11"    temp = 2 count = 1
 removeFirst-> 1  != temp2       result = "11 12" temp = 1 coint = 1
 removeFirst-> 1  == temp1       count = 2
 result = [11 12 21]
 */
var str = ""
str.append(contentsOf: "a")
print(str)
