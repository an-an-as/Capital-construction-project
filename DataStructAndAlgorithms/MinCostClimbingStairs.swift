//  最小体力爬楼梯    可以爬一个阶梯或者爬两个阶梯
//  攀爬需要对应元素值 找到到达楼顶的最小体力累计值
//  起始从0或1开始
/// [1, 100, 1, 1, 1, 100]
/// index1  [1 + 100, 0 + 100]     costs[1, 100]
/// index2  cost[1 + 1, 100 + 1]   costs[1, 100, 2]
/// index3  cost[100 + 1, 2 + 1]   costs[1, 100, 2, 3]
/// index4  cost[2 + 1, 3 + 1]     costs[1, 100, 2, 3, 3]
/// index5  cost[3 + 100, 3 + 100] costs[1, 100, 2, 3, 3, 103]
/// index6  cost[3 + 0, 103 + 0]   costs[1, 100, 2, 3, 3, 103, 3]

extension Array where Element == Int {
    var minCostClimbingStairs: Int {
        guard !isEmpty else { return 0 }
        var costs = [Int]()
        costs.append(first!)
        for index in 1...count {
            let one = costs[index - 1]
            var two = 0
            var currentNum = 0
            if index - 2 < 0 {   /// 第一次
                two = 0
            } else {
                two = costs[index - 2]
            }
            if index >= count { /// 到达终点
                currentNum = 0
            } else {
                currentNum = self[index]
            }
            costs.append(Swift.min(one + currentNum, two + currentNum))
        }
        return costs.last!
    }
}

/// version: 2
extension Array where Element == Int {
    var minCost: Int {
        var costs = Array(prefix(2))
        for index in 2...endIndex {
            var currentElement = 0
            let prevElementOne = costs[index - 1]
            let preveElementTwo = costs[index - 2]
            currentElement = (index == endIndex) ? 0 : self[index]
            costs.append(Swift.min(prevElementOne + currentElement , preveElementTwo + currentElement))
        }
        return costs.last!
    }
}
var steps = [1, 100, 1, 1, 1, 100]
let result = steps.minCost
print(result)

