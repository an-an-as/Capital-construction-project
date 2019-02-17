/**
 火车票有三种不同的销售方式：
 
 一张为期一天的通行证售价为 costs[0]  美元；
 一张为期七天的通行证售价为 costs[1]  美元；
 一张为期三十天的通行证售价为 costs[2] 美元。
 
 最低支出
 输入：days = [1,4,6,7,8,20], costs = [2,7,15]
 输出：11
 解释：
 例如，这里有一种购买通行证的方法，可以让你完成你的旅行计划：
 在第 1 天， 你花了 costs[0] = $2 买了一张为期 1 天的通行证，它将在第 1 天生效。
 在第 3 天， 你花了 costs[1] = $7 买了一张为期 7 天的通行证，它将在第 3, 4, ..., 9 天生效。
 在第 20 天，你花了 costs[0] = $2 买了一张为期 1 天的通行证，它将在第 20 天生效。
 你总共花了 $11，并完成了你计划的每一天旅行。
 */
func mincostTickets(_ days: [Int], _ costs: [Int]) -> Int {
    var temp = Array(repeating: Int.max, count: days.count + 1)   ///最后位统计最小花费 max和days日期对应
    temp[0] = 0                                     /// 初始化最小花费
    var valid = [1, 7, 30]                          /// index0 仅仅考虑日期1    那么7天有效期的才能包含所有的天数
    for index in 0..<days.count {                   /// index1 同时考虑日期1和2  加上日期1的花费 4 < 7   最优结果是分开买
        if temp[index + 1] == Int.max { temp[index + 1] = temp[index] + costs[0] }
        for cursor in 0...2 {
            for k in index..<days.count {                   /// 计算日期是否在有效期内
                if days[k] < days[index] + valid[cursor] {  /// 例如1号 + 5天有效  那么遍历的日期应 < 6号  1 2 3 4 5 都是有效的
                    temp[k + 1] = min(temp[index] + costs[cursor], temp[k + 1])/// 对这12345分别记录5天有效期的票价 最后为准
                }  else { break }                  /// break 不在有效期内
            }
        }
    }
    return temp[temp.count - 1]
}
//  把多阶段过程转化为一系列单阶段问题，利用各阶段之间的关系，逐个求解
/// cost    [2元, 7元, 15元]
/// valid   [1天, 7天, 30天]


/// index0 cursor0
///       k     index  cursor      k+1           index   cursor    k
///0 days 1号  < 1号 +  1天有效  temp[1] = 最小花费 temp0 + 2元 & temp 0 + 1 = 2元   [0, 2, max]   一天有效的情况
///1      2号  < 1号 +  1天有效  第二天不在有效期内  [1号  3号] 有效期 5天 那么就记录5天的票价 即第二天(目前是3号)要在范围内  < 6号

/// index0 cursor1
///       k     index  cursor     k+1            index   cursor    k
///0 days 1号  < 1号 +  7天有效  temp[1] = 最小花费 temp0 + 7元 & temp 0 + 1 = 2元   [0, 2, max]
///1      2号  < 1号 +  7天有效  temp[2] = 最小花费 temp0 + 7元 & temp 1 + 1 = max   [0, 2, 7]    temp[2]考虑7天范围内花费

/// index0 cursor2
///       k     index  cursor     k+1            index   cursor    k
///0 days 1号  < 1号 +  30天有效  temp[1] = 最小花费 temp0 + 15元 & temp 0 + 1 = 2元   [0, 2, max]
///1      2号  < 1号 +  30天有效  temp[2] = 最小花费 temp0 + 15元 & temp 1 + 1 = 7元   [0, 2, 7]  temp[2]和月票30天比较


/// index1 cursor0
///       k     index  cursor      k+1           index   cursor    k
///1 days 2号  < 2号 +  1天有效  temp[2] = 最小花费 temp1 + 2元 & temp 1 + 1 -> 4元   [0, 2, 4]

/// index1 cursor1
///       k     index  cursor      k+1           index   cursor    k
///1 days 2号  < 2号 +  7天有效  temp[2] = 最小花费 temp1 + 15元 & temp 1 + 1 -> 4元   [0, 2, 4]

/// index1 cursor0
///       k     index  cursor      k+1           index   cursor    k
///1 days 2号  < 2号 +  30天有效  temp[2] = 最小花费 temp1 + 30元 & temp 1 + 1 -> 4元   [0, 2, 4]

let cost = [2, 7, 15]
let days = [1, 2]
let result = mincostTickets(days, cost)
print(result)


/// 三级循环
/// cursor 同时遍历cost和valid使其匹配
/// index  限定日期范围 k在该范围内游动
