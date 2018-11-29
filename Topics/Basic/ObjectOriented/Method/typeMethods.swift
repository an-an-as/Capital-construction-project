// 通过在方法的func字之前编写static关键字来指示类型方法
// 类还可以使用class关键字来允许子类重写该方法的超类实现
class SomeClass {
    class func someTypeMethod() {
    }
}
SomeClass.someTypeMethod()

struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    /// 完成一关解锁 并更新最高等级
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    /// 判断一关是否解锁了
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    /// 是否可以换一关
    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")

// 通过静态的全局方法使得所有创建的新实例都有相同的功能状态
player = Player(name: "Beto")
if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}
