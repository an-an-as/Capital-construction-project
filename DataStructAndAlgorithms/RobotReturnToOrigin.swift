/**
 在二维平面上，有一个机器人从原点 (0, 0) 开始。
 给出它的移动顺序，判断这个机器人在完成移动后是否在 (0, 0) 处结束。
 移动顺序由字符串表示。字符 move[i] 表示其第 i 次移动。机器人的有效动作有 R（右），L（左），U（上）和 D（下）。
 如果机器人在完成所有动作后返回原点，则返回 true。否则，返回 false。
 */
extension String {
    var isCircle: Bool {
        if count == 0 { return true }
        var vertical = 0
        var horizon = 0
        forEach {
            switch $0 {
            case "U":
                vertical += 1
            case "D":
                vertical -= 1
            case "L":
                horizon += 1
            case "R":
                horizon -= 1
            default:
                break
            }
        }
        if vertical == 0 && horizon == 0 {
            return true
        }
        return false
    }
}
