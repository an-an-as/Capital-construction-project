// 数组中第三大的数
func thirdMax(_ nums: [Int]) -> Int {
    let sorted = Set(nums).sorted(by: {$0 > $1})
    return sorted.count >= 3 ? sorted[2] : sorted[0]
}
/// - Version: 2
class Solution {
    func thirdMax(_ nums: [Int]) -> Int {
        var max = nums[0]
        var second: Int?
        var third: Int?
        for i in 1..<nums.count {
            if nums[i] < max {
                if second == nil {
                    second = nums[i]
                } else {
                    if second! < nums[i] {
                        third = second!
                        second = nums[i]
                    } else if second! > nums[i] {
                        if third == nil {
                            third = nums[i]
                        } else {
                            if nums[i] > third! {
                                third = nums[i]
                            }
                        }
                    }
                }
            } else if nums[i] > max {
                third = second
                second = max
                max = nums[i]
            }
        }
        if third != nil {
            return third!
        }
        return max
    }
}

