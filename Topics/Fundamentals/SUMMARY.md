#### **Swift Standard Library**
----
##### **Fundamentals**
|--- **Numbers**              <br/>
|                 |--- `Int`         <br/>
|                 |         |--- **Converting Integers** <br/>
|                 |         |           |--- `convenience init< T>(_ source: T) where T : BinaryInteger`<br/>
|                 |         |           |--- `convenience init?<T>(exactly source: T) where T : BinaryInteger` <br/>
|                 |         |           |--- `convenience init<Other>(clamping source: Other) where Other : BinaryInteger`<br/>
|                 |         |           |--- `convenience init<T>(truncatingIfNeeded source: T) where T : BinaryInteger`<br/>
|                 |         |           |--- `init(bitPattern x: UInt)`<br/>
|                 |         |<br/>        
|                 |         |--- **Converting Floating-Point Values**<br/>
|                 |         |           |--- `convenience init<T>(_ source: T) where T : BinaryFloatingPoint`<br/>
|                 |         |           |--- `convenience init?<T>(exactly source: T) where T : BinaryFloatingPoint`<br/>
|                 |         |           |--- `init(_ source: Double)`<br/>
|                 |         |           |--- `init(_ source: Float)`<br/>
|                 |         |           |--- `init(_ value: CGFloat)`<br/>
|                 |         |           ...<br/>
|                 |         |     
|                 |         |--- **Converting Strings**
|                 |         |           |--- `convenience init?(_ description: String)`
|                 |         |           |--- `convenience init?<S>(_ text: S, radix: Int = default) where S : StringProtocol`
|                 |         | <br/>   
|                 |         |--- **Creating a Random Integer**<br/>
|                 |         |           |--- `static func random(in range: Range<Int>) -> Int`<br/>
|                 |         |           |--- `static func random<T>(in range: Range<Int>, using generator: inout T) -> Int where T : RandomNumberGenerator`<br/>
|                 |         |           |--- `static func random(in range: ClosedRange<Int>) -> Int`<br/>
|                 |         |           |--- `static func random<T>(in range: ClosedRange<Int>, using generator: inout T) -> Int where T : RandomNumberGenerator`<br/>
|                 |         |<br/>
|                 |         |--- **Performing Calculations**
|                 |         |           |--- `mutating func negate()`
|                 |         |           |--- `func quotientAndRemainder(dividingBy rhs: Int) -> (quotient: Int, remainder: Int)`
|                 |         | 
|                 |         |--- **Performing Calculations with Overflow**
|                 |         |           |--- ...
|                 |         | 
|                 |         |--- **Performing Double-Width Calculations**
|                 |         |           |--- ...
|                 |         | 
|                 |         |--- **Finding the Sign and Magnitude**
|                 |         |           |--- `var magnitude: UInt { get }`
|                 |         |           |--- `func abs<T>(_ x: T) -> T where T : Comparable, T : SignedNumeric`
|                 |         |           |--- `func signum() -> Int`
|                 |         |       
|                 |         |--- **Accessing Numeric Constants**
|                 |         |           |--- `static var min: Int { get }`
|                 |         |           |--- `static var max: Int { get }`
|                 |         |           |--- `static var isSigned: Bool { get }`
|                 |         |
|                 |         |--- **Working with Byte Order**
|                 |         |           |--- ...
|                 |         |
|                 |         |--- **Working with Binary Representation**
|                 |         |           |--- `static var bitWidth: Int { get }`
|                 |         |           |--- `var bitWidth: Int { get }`
|                 |         |           |--- ...
|                 |         |
|                 |         |--- **Working with Memory Addresses**
|                 |         |           |--- ...
|                 |         |
|                 |         |--- **Encoding and Decoding Values**
|                 |         |           |--- `func encode(to encoder: Encoder) throws`
|                 |         |           |--- `init(from decoder: Decoder) throws`
|                 |         |
|                 |         |--- **Describing an Integer**
|                 |         |           |--- `var description: String { get }`
|                 |         |           |--- `func hash(into hasher: inout Hasher)`
|                 |         |           |--- `var customMirror: Mirror { get }`
|                 |         |
|                 |         |--- **Using an Integer as a Data Value**
|                 |         |           |--- ... ML
|                 |         |
|                 |         |--- **Infrequently Used Functionality**
|                 |                    |--- `convenience init()`
|                 |                    |--- `convenience init(integerLiteral value: Int)`
|                 |                    |--- `func distance(to other: Int) -> Int`
|                 |                    |--- `func advanced(by n: Int) -> Int`
|                 |         
|                 |--- **Double**
|                 |         |--- **Converting Integers**          
|                 |         |          |--- `convenience init<Source>(_ value: Source) where Source : BinaryInteger`
|                 |         |          |---...
|                 |         |          
|                 |         |--- **Converting Strings**          
|                 |         |          |--- `init?<S>(_ text: S) where S : StringProtocol`
|                 |         |            
|                 |         |--- **Converting Floating-Point Values**          
|                 |         |          |--- `convenience init<Source>(_ value: Source) where Source : BinaryFloatingPoint`
|                 |         |          |--- `init(_ other: Double)`
|                 |         |          |---`init(truncating number: NSNumber)`
|                 |         |          |---`init(sign: FloatingPointSign, exponent: Int, significand: Double)`
|                 |         |          |---`convenience init(signOf: Double, magnitudeOf: Double)`
|                 |         |          |--- ... 
|                 |         |            
|                 |         |--- **Converting with No Loss of Precision**          
|                 |         |          |---`convenience init?<Source>(exactly value: Source) where Source : BinaryInteger`
|                 |         |          |--- ... 
|                 |         |            
|                 |         |--- **Creating a Random Value**          
|                 |         |          |--- `static func random(in range: Range<Double>) -> Double`
|                 |         |          |--- `static func random<T>(in range: Range<Double>, using generator: inout T) -> Double where T : RandomNumberGenerator`
|                 |         |            
|                 |         |--- **Performing Calculations**          
|                 |         |          |--- `func addingProduct(_ lhs: Double, _ rhs: Double) -> Double`
|                 |         |          |--- `mutating func addProduct(_ lhs: Double, _ rhs: Double)`   
|                 |         |          |--- `func squareRoot() -> Double`
|                 |         |          |--- `func remainder(dividingBy other: Double) -> Double`
|                 |         |          |--- `mutating func formRemainder(dividingBy other: Double)`
|                 |         |          |--- `func truncatingRemainder(dividingBy other: Double) -> Double`
|                 |         |          |--- `mutating func formTruncatingRemainder(dividingBy other: Double)`
|                 |         |          |--- `mutating func negate()`
|                 |         |         
|                 |         |--- **Rounding Values**          
|                 |         |          |--- `func rounded() -> Double`
|                 |         |          |--- `mutating func round()`
|                 |         |          |--- `func rounded(_ rule: FloatingPointRoundingRule) -> Double`
|                 |         |          |--- `mutating func round(_ rule: FloatingPointRoundingRule)`
|                 |         |            
|                 |         |--- **Comparing Values**          
|                 |         |          |--- `func isEqual(to other: Double) -> Bool`
|                 |         |          |--- `func isLessThanOrEqualTo(_ other: Double) -> Bool`
|                 |         |          |--- `func isTotallyOrdered(belowOrEqualTo other: Double) -> Bool`
|                 |         |          |--- `static func minimum(_ x: Double, _ y: Double) -> Double`
|                 |         |          |--- `static func minimumMagnitude(_ x: Double, _ y: Double) -> Double`
|                 |         |            
|                 |         |--- **Finding the Sign and Magnitude**          
|                 |         |          |--- `var magnitude: Double { get }`
|                 |         |          |--- `var sign: FloatingPointSign { get }`
|                 |         |            
|                 |         |--- **Querying a Double**          
|                 |         |          |--- `var ulp: Double { get }`
|                 |         |          |--- `var significand: Double { get }`
|                 |         |          |--- `var exponent: Int { get }` 
|                 |         |          |--- `var nextUp: Double { get }`
|                 |         |          |--- `var nextDown: Double { get }`
|                 |         |            
|                 |         |--- **Accessing Numeric Constants**          
|                 |         |          |--- `static var pi: Double { get }`
|                 |         |          |--- `static var infinity: Double { get }`
|                 |         |          |--- `static var greatestFiniteMagnitude: Double { get }`
|                 |         |          |--- `static var nan: Double { get }`
|                 |         |          |--- `static var signalingNaN: Double { get }`
|                 |         |          |--- `static var leastNormalMagnitude: Double { get }`
|                 |         |            
|                 |         |--- **Working with Binary Representation**          
|                 |         |          |--- ...
|                 |         |            
|                 |         |--- **Querying a Double's State**          
|                 |         |          |--- `var isZero: Bool { get }`
|                 |         |          |--- `var isFinite: Bool { get }`
|                 |         |          |--- `var isNaN: Bool { get }`
|                 |         |          |--- `var isSignalingNaN: Bool { get }`
|                 |         |          |--- `var isNormal: Bool { get }`
|                 |         |          |--- ...
|                 |         |            
|                 |         |--- **Encoding and Decoding Values**          
|                 |         |          |--- `func encode(to encoder: Encoder) throws`
|                 |         |          |--- `init(from decoder: Decoder) throws`
|                 |         |            
|                 |         |--- **Creating a Range**          
|                 |         |          |--- `static func ..< (minimum: Double, maximum: Double) -> Range<Double>`
|                 |         |          |--- `static func ... (minimum: Double, maximum: Double) -> ClosedRange<Double>`
|                 |         |            
|                 |         |--- **Describing a Double**          
|                 |         |          |--- `var description: String { get }`
|                 |         |          |--- `var debugDescription: String { get }`
|                 |         |          |--- `var customMirror: Mirror { get }`
|                 |         |          |--- `func hash(into hasher: inout Hasher)`
|                 |         |            
|                 |         |--- **Using a Double as a Data Value**          
|                 |         |          |--- ... ML
|                 |         |            
|                 |         |--- **Infrequently Used Functionality**          
|                 |         |          |--- `func advanced(by amount: Double) -> Double`
|                 |         |          |--- `func distance(to other: Double) -> Double`


> [Doctmentation](https://developer.apple.com/documentation/foundation)
