/************* Integers And Folating-Point************/
//Integer Bounds
///在32位平台上，Int 和 Int32 长度相同。
///在64位平台上，Int 和 Int64 长度相同。
let minValue = UInt8.min /// minValue is equal to 0, and is of type UInt8
let maxValue = UInt8.max /// maxValue is equal to 255, and is of type UInt8
let int32Min = Int32.min ///-2147483648
let int32Max = Int32.max ///2147483647 (10位)
let int64Min = Int64.min ///-9223372036854775808
let int64Max = Int64.max ///9223372036854775807(19位 身分证信用卡取值)


// Floating-Point Numbers
Float  ///表示32位浮点数   Float只有6位数字
Double ///表示64位浮点数   Double精确度很高，至少有15位数字


// Integer Conversion
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)


// Integer and Floating-Point Conversion
let three = 3
let pointOneFourOneFiveNine = 0.14159
let pi = Double(three) + pointOneFourOneFiveNine
let integerPi = Int(pi)


/*********** Boolean ************/
let orangesAreOrange = true
let turnipsAreDelicious = false
if turnipsAreDelicious {
    print("Mmm, tasty turnips!")
} else {
    print("Eww, turnips are horrible.")
}
/// 输出 "Eww, turnips are horrible."
let i = 1
if i {
    /// error
}
if i == 1 {
    /// 这个例子会编译成功
}

/************** Tuples ***********/
//打包
var str = "Hello, playground"
let tuple =  (404,"notFound")
tuple.0
tuple.1
//解包
var (num,_) = tuple
num = 500
print(tuple)
//比较
let tuple1 = (1,2) ///最多6个元素比较
let tuple2 = (1,3)
tuple1 < tuple2




//typealias
///类型别名

//Type Safety and Type Inference
///编译代码时进行类型检查（type checks）
///编译器可以在编译代码的时候自动推断出表达式的类型。原理很简单，只要检查你赋的值即可。
let anotherPi = 3 + 0.14159
/// anotherPi 会被推测为 Double 类型
