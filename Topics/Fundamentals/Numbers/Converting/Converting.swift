// 从一个整数创建一个新实例
let x = 100
let y = Int8(x)
/// y == 100
let z = Int8(x * 10)
/// Error: Not enough bits to represent the given value
/// Int8类型最多可以表示127

// 溢出和范围检查1 nil
// 如果整数不能准确表示类型则返回nil
let x1 = Int8(exactly: 100)
/// x1 == Optional(100)
let y1 = Int8(exactly: 1_000)
/// y1 == nil

// 溢出和范围检查2 max&min
// 如果作为source的值大于此类型中的最大可表示值, 则结果是类型的max值。
// 如果source小于此类型中的最小可表示值, 则结果为类型的min值。
let x2 = Int8(clamping: 500)
/// x2 == 127
/// x2 == Int8.max
let y2 = UInt(clamping: -500)
/// y == 0 无符号整数

// 不同位宽间的转换
// 当T的位宽度 ( source类型) 等于或大于此类型的位宽度时, 结果是source最小值位。
// 将16位值转换为8位类型时, 只使用较低的source
let p: Int16 = -500
/// 'p' has a binary representation of 11111110_00001100
let q = Int8(truncatingIfNeeded: p)
/// q == 12
/// 'q' has a binary representation of 00001100

let u: Int8 = 21
/// 'u' has a binary representation of 00010101
let v = Int16(truncatingIfNeeded: u)
/// v == 21
/// 'v' has a binary representation of 00000000_00010101

let w: Int8 = -21
/// 'w' has a binary representation of 11101011
let x3 = Int16(truncatingIfNeeded: w)
/// x3 == -21
/// 'x3' has a binary representation of 11111111_11101011
let y3 = UInt16(truncatingIfNeeded: w)
/// y3 == 65515
/// 'y3' has a binary representation of 11111111_11101011

// 从给定值创建一个具有相同内存表示的值
let number = 12345
let uintNum = UInt(bitPattern: number)
let v2 =  Int(bitPattern: uintNum)
/// v2 == 12345


//Double
Double(exactly: 22.02)
