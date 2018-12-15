//Int
//可带符号+-
let x = Int("+123")
/// x == 123

//八进制转换为十进制整数
let y = Int("-123", radix: 8)
/// y == -83

let y2 = Int("+123", radix: 8)
/// y == +83

let z = Int("07b", radix: 16)
/// z == 123

let d = Int("-1010", radix: 2)
/// d == -10

//Double
let c = Double("-1.0")
// c == -1.0

let d = Double("28.375")
// d == 28.375

let e = Double("2837.5e-2")
// e == 28.375

let f = Double("0x1c.6")
// f == 28.375

let g = Double("0x1.c6p4")
// g == 28.375

let i = Double("inf")
// i == Double.infinity

let j = Double("-Infinity")
// j == -Double.infinity

let n = Double("-nan")
// n?.isNaN == true
// n?.sign == .minus

let p = Double("nan(0x10)")
// p?.isNaN == true
// String(p!) == "nan(0x10)"
