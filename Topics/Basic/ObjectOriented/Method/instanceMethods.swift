/**
 In Objective-C, classes are the only types that can define methods,在swift中, 可以选择是定义类、结构体还是枚举,
 */

class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}
let counter = Counter()
counter.increment()
counter.increment(by: 5)
counter.reset()

/*******************  The self Property *******************/

struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOfX(x: Double) -> Bool {
        return self.x > x
    }
}
let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOfX(1.0) {
    print("This point is to the right of the line where x == 1.0")
}

/********   Modifying Value Types from Within Instance Methods  ***********/
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var somePoint = Point(x: 1.0, y: 1.0)
somePoint.moveByX(2.0, y: 3.0)
print("The point is now at (\(somePoint.x), \(somePoint.y))")

// ⚠️ cannot call a mutating method on a constant of structure type
let fixedPoint = Point(x: 3.0, y: 3.0)
fixedPoint.moveByX(2.0, y: 3.0)
// because its properties cannot be changed, even if they are variable properties


/*********  Assigning to self Within a Mutating Method  **********/
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point(x: x + deltaX, y: y + deltaY)
    }
}

enum State {
    case on, off
    mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
    init() {
        self = .off
    }
}
var state = State()
state.toggle()
switch state {
case .on:
    print("STATE ON")
case .off:
    print("OFF")
}
