/// Bitwise Operators
///位运算符可以操作数据结构中每个独立的比特位。它们通常被用在底层开发中，比如图形编程和创建设备驱动。位运算符在处理外部资源的原始数据时也十分有用，比如对自定义通信协议传输的数据进行编码和解码。
//Bitwise NOT Operator
///按位取反运算符（~）可以对一个数值的全部比特位进行取反
let initialBits: UInt8 = 0b00001111
let invertedBits = ~initialBits  /// equals 11110000

//Bitwise AND Operator
///按位与运算符（&）可以对两个数的比特位进行合并。它返回一个新的数，只有当两个数的对应位都为 1 的时候，新数的对应位才为 1
let firstSixBits: UInt8 = 0b11111100
let lastSixBits: UInt8  = 0b00111111
let middleFourBits = firstSixBits & lastSixBits  /// equals 00111100

//Bitwise OR Operato
///按位或运算符（|）可以对两个数的比特位进行比较。它返回一个新的数，只要两个数的对应位中有任意一个为 1 时，新数的对应位就为 1

//Bitwise XOR Operator
///按位异或运算符（^）可以对两个数的比特位进行比较。它返回一个新的数，当两个数的对应位不相同时，新数的对应位就为 1
let firstBits: UInt8 = 0b00010100
let otherBits: UInt8 = 0b00000101
let outputBits = firstBits ^ otherBits  // equals 00010001


//Bitwise Left and Right Shift Operators
///按位左移运算符（<<）和按位右移运算符（>>）可以对一个数的所有位进行指定位数的左移和右移
///对一个数进行按位左移或按位右移，相当于对这个数进行乘以 2 或除以 2 的运算。将一个整数左移一位，等价于将这个数乘以 2，同样地，将一个整数右移一位，等价于将这个数除以 2

///对无符号整数进行移位的规则如下：
///已经存在的位按指定的位数进行左移和右移。
///任何因移动而超出整型存储范围的位都会被丢弃。
///用 0 来填充移位后产生的空白位。 这种方法称为逻辑移位
let shiftBits: UInt8 = 4 /// 即二进制的 00000100
shiftBits << 1           /// 00001000
shiftBits << 2           /// 00010000
shiftBits << 5           /// 10000000
shiftBits << 6           /// 00000000
shiftBits >> 2           /// 00000001

let pink: UInt32 = 0xCC6699
let redComponent = (pink & 0xFF0000) >> 16  /// redComponent 是 0xCC，即 204
let greenComponent = (pink & 0x00FF00) >> 8 /// greenComponent 是 0x66， 即 102
let blueComponent = pink & 0x0000FF         /// blueComponent 是 0x99，即 153

//有符号整数的移位运算
//溢出运算符
///在默认情况下，当向一个整数赋予超过它容量的值时，Swift 默认会报错，而不是生成一个无效的数。这个行为为我们在运算过大或着过小的数的时候提供了额外的安全性。
var potentialOverflow = Int16.max
/// potentialOverflow 的值是 32767，这是 Int16 能容纳的最大整数
potentialOverflow += 1
/// 这里会报错
///溢出加法 &+
///溢出减法 &-
///溢出乘法 &*
var unsignedOverflow = UInt8.min
/// unsignedOverflow 等于 UInt8 所能容纳的最小整数 0
unsignedOverflow = unsignedOverflow &- 1
/// 此时 unsignedOverflow 等于 255


///Swift Standard Library Operators Reference
///https://developer.apple.com/reference/swift/swift_standard_library_operators#//apple_ref/doc/uid/TP40016054


//自定义运算符
///新的运算符要使用 operator 关键字在全局作用域内进行定义，同时还要指定 prefix、infix 或者 postfix 修饰符：
prefix operator +++ {}
extension Vector2D {
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}
var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
/// toBeDoubled 现在的值为 (2.0, 8.0)
/// afterDoubling 现在的值也为 (2.0, 8.0)


//确定优先级
infix operator +-: AdditionPrecedence
extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}
let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector
/// plusMinusVector 是一个 Vector2D 实例，并且它的值为 (4.0, -2.0)
