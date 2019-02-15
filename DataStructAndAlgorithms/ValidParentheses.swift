/// 判断括号是否有效
/// 左括号必须用相同类型的右括号闭合
/// 左括号必须以正确的顺序闭合
/// Input: "()[]{}"
/// Output: true
extension String {
    var isValidParentheses: Bool {
        guard !isEmpty else { return true }
        var parentheses = ["(":1, "{":2, "[":3, ")":-1, "}":-2, "]":-3]
        var stack = [Int]()
        for element in self {
            guard let num = parentheses[String(element)] else { return false }
            if num > 0 {
                stack.append(num)
            } else { /// 转化为正负相匹配 先进后出
                guard let last = stack.popLast(), last + num == 0 else { return false}
            }
        }
        return stack.isEmpty
    }
}
let result = "([])".isValidParentheses
print(result)//true
