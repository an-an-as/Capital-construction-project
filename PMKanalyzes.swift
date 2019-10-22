//
//          |- init(value)
//          |- override inspect -> Sealant       |-fulfilled(value)
//    |- SealedBox                               |-reject(error)
//   Box<Result> --------------------- EmptyBox<Result>
//    |-inspect -> Sealant       |- sealant = Sealant.pending(.init())
//    |-inspect((Sealant)->Void) |- override inspect -> Sealant
//    |-seal      |              |- override inspect((Sealant)->Void)
//                |-resolved     |- override seal(Result): sealant.resolved(Result)  handler.forEach{ $0(Result) }
//                |-pending(Handlers)
//                             |- [(R)->Void]()]
//                             |- append( (R)->Void )
//
//
// Resolver
//    |-Box<Result>
//    |-fulfill: box.seal(.fulfilled(value))
//    |-reject:  box.seal(.reject(error))
//
//
//               |-fulfilled(value)
//               |-reject(value)
//   |-result: Result?
//   |-pipe((Result<T>) -> Void)
// Thenable ---------------------- Promise
//                                  |-Box<Result>
//                                  |-init((Resolver) throws -> Void): body(Resolver(emptyBox)) resolver.fulfill("A")
//                                  |-pipe( Result->Void ):  switch emptyBox.inspect
//                                                           case pending: emptyBox.inspect {
//                                                                            sealant.switch pending append(.)
//                                                                         }
//
//
// extensino Thenable
// then<U: Thenable>( (T) throws -> U ) -> Promise
// |- self.pipe {  Result.switch   }
// case.fulfilled(value): body("A")
//
//
//
//
//
/// Example
/// let promise = Promise { $0.fuill("A") }
/// assembling(String) -> Promise  print String  return Promise { $0.fulfill("B") }
/// promise.then(assembling).done { print($0) }
///
//                                           |- [(R)->Void]
// |-Thenable           |- sealant.pending(.init)                       |-fulfilled(value)
//Promise -> Reslover(emptyBox) -> reslover.fulfill(value) -> emptyBox<Result>.seal(.fulfilled("A"))
//  case .pending(handlers) = sealant -> resloverd(.fullfilled("A")) -> handlers.bodies.forEach { $0(value) }
//
//then(body: (U)->Promise) -> Promise(.pending).box = emptyBox -> self.pipe { switch Result   }
//case.fulfilled(value): body(value).pipe(to: Promise(.pending).box.seal)
//
//

//func body(String) -> Promise
//Promise.then(body) 通过一个枚举(状态)存储另一个枚举(结果)
//Sealant(Result.fulfilled(value)) -> body(value).pipe(to: Promise(.pending).box.seal)
//
//
/**
 
 ##### class `Promise<T>` :  Thenable
 |                                       |
 |                                       |- `associatedtype T`
 |                                       |- func `pipe(to: @escaping(Result<T>) -> Void)`
 |                                       |- var` result: Result<T>? { get }`
 |                                                                      |- public `enum Result<T>`
 |                                                                                     |- case  `fulfilled(T)`
 |- let `box: Box<Result<T>>`                                     |- case  `rejected(Error)`
 |                       |
 |                       |
 |                       |- enum `Sealant<R>`
 |                       |       |-   case    `pending(Handlers<R>)`------------> class `Handlers<R>`
 |                       |       |-   case    `resolved(R)`                                                  |-  var    `bodies: [(R) -> Void] = []`
 |                       |                                                                                                  |-  func  `append(_ item: @escaping(R) -> Void)` { bodies.append(item) }
 |                       |
 |                       |-  func `inspect() -> Sealant<T> { fatalError() }`
 |                       |-  func `func inspect(_: (Sealant<T>) -> Void) { fatalError() }`
 |                       |-  func `seal(_: T) {}`
 |                       |
 |                       |
 |                       **class**  `SealedBox<T>: Box<T>`
 |                       |                   |
 |                       |                   |-  let `value: T`
 |                       |                   |-  init`(value: T)` {  self.value = value  }
 |                       |                   |-  override `func inspect() -> Sealant<T>` {  return `.resolved(value)` }
 |                       |
 |                       |
 |                       **class**  `EmptyBox<T>: Box<T>`
 |                                           |
 |                                           |-  private var `sealant` = `Sealant<T>.pending(.init())`
 |                                           |-  private let  `barrier` = `DispatchQueue(label: "org.promisekit.barrier", attributes: .concurrent)`
 |                                           |-  override  func `seal(_ value: T)`
 |                                           |-  override  func `inspect() -> Sealant<T>`
 |                                           |-  override  func `inspect(_ body: (Sealant<T>) -> Void)`
 |                                           |
 |                                           ====================  `seal(_ value: T)`  =======================
 |                                            var `handlers: Handlers<T>!`
 |                                            `barrier`.`sync(flags: .barrier)` {
 |                                                    guard `case .pending(let _handlers)` = `self.sealant` else { `return` }
 |                                                    `handlers` =  `_handlers`
 |                                                    self.`sealant` = .`resolved(value) `
 |                                            }
 |                                            if let `handlers` = `handlers` { `handlers.bodies.forEach{ $0(value) }` }
 |                                            ===================  `inspect() -> Sealant<T>`  =================
 |                                            var  `rv: Sealant<T>!`
 |                                            `barrier.sync` { `rv` = self.`sealant` }
 |                                            return `rv`
 |                                            ===========  `inspect(_ body: (Sealant<T>) -> Void)` ============
 |                                           ` barrier.sync(flags: .barrier) `{
 |                                                    switch `sealant` {
 |                                                    case `.pending`:   `body(sealant)`
 |                                                    case `.resolved`:  `sealed = true`
 |                                                    }
 |                                              }
 |                                             if `sealed` { `body(sealant)` }
 |
 |
 |
 |
 |
 |
 |- public class func `value(_ value: T) -> Promise<T>` { return `Promise(box: SealedBox(value: .fulfilled(value))) `}
 |- public init`(error: Error) `{ `box = SealedBox(value: .rejected(error))` }
 |- public init<U: Thenable>(_ bridge: U) where U.T == T
 |- public init`(resolver body: (Resolver<T>) throws -> Void)`                  =============================
 |                                                           |                                                                       `box` = `EmptyBox()`
 |                                                           class `Resolver<T>`                                       let `resolver` = `Resolver(box)`
 |                                                           |                                                                        do try `body(resolver)`   cath  `resolver.reject(error)`
 |                                                           |- let  `box: Box<Result<T>>`
 |                                                           |- init `(_ box: Box<Result<T>>)` {  self.`box` = `box` }
 |                                                           |- deinit {  if case `.pending = box.inspect()` {  `conf.logHandler(.pendingPromiseDeallocated)` }  }
 |                                                           |- func `fulfill(_ value: T)` {  `box.seal(.fulfilled(value))`  }
 |                                                           |- func `reject(_ error: Error)` {  `box.seal(.rejected(error))`  }
 |                                                           |
 |
 |- public class func pending() -> (promise: Promise<T>, resolver: Resolver<T>)
 |- public func `pipe(to: @escaping(Result<T>) -> Void)`
 |- public var result: Result<T>?
 |- init`(_: PMKUnambiguousInitializer) `{  `box = EmptyBox()`}  ---> enum `PMKUnambiguousInitializer` { case  `pending` }
 |- unc wait() throws -> T
 |
 extension Promise where T == Void
 |               |- public convenience init()
 |
 ====================  public func `pipe(to: @escaping(Result<T>) -> Void)`  =======================
 switch `box.inspect() `{
 case `.pending`:   `box.inspect` {
 switch `$0`  {
 case`  .pending(let handlers)`:  `handlers.append(to)`
 case ` .resolved(let value)`:  `to(value) `
 }
 case `.resolved(let value)`:  `to(value`
 }
 ##### protocol `Thenable`
 + func `then<U: Thenable>(on: DispatchQueue? = conf.Q.map, flags: DispatchWorkItemFlags? = nil, _ body: @escaping(T) throws -> U) -> Promise<U.T> `
 + func `map<U>(on: DispatchQueue? = conf.Q.map, flags: DispatchWorkItemFlags? = nil, _ transform: @escaping(T) throws -> U) -> Promise<U>`
 + func `compactMap<U>(on: DispatchQueue? = conf.Q.map, flags: DispatchWorkItemFlags? = nil, _ transform: @escaping(T) throws -> U?) -> Promise<U>`
 + func `done(on: DispatchQueue? = conf.Q.return, flags: DispatchWorkItemFlags? = nil, _ body: @escaping(T) throws -> Void) -> Promise<Void>`
 + func `get(on: DispatchQueue? = conf.Q.return, flags: DispatchWorkItemFlags? = nil, _ body: @escaping (T) throws -> Void) -> Promise<T> `
 + func `tap(on: DispatchQueue? = conf.Q.map, flags: DispatchWorkItemFlags? = nil, _ body: @escaping(Result<T>) -> Void) -> Promise<T>`
 ====================  `then<U: Thenable>( _ body: @escaping(T) throws -> U) ) -> Promise<U.T>` =======================
 let `rp` = `Promise<U.T>(.pending)`
 `pipe` {
 switch `$0` {
 case `.fulfilled(let value)`:  on.`async(flags: flags)` {
 ` let rv = try body(value)`
 ` rv.pipe(to: rp.box.seal)`
 }
 case `.rejected(let error)`: {  `rp.box.seal(.rejected(error))` }
 }
 return `rp`
 }
 **/

//progress1().then(progress2).done { print("end---\($0)---end") }
//then传入表达式progress1将🐝传入执行 (表达内将获取的值🐝传入progress2表达式-主队列异步执行 推迟)
//创建emptyBox🈳️并返回 执行done 匹配到emptyBox🈳️的enum状态为pending 存入done的函数表达式📦
//开始运行延迟的 144 ⚠️mainAsyncresolved 函数表达式 print("---receive \(product)---")
//received.pipe(to: emptyPromise.box.seal)   reveive: promise fullfill 🌹
//将接收到的🌹传入emptyBox🈳️的seal表达式并运行 塑封后emptyBox🈳️的enum --> resloved(🌹)
//并用变量存储emptyBox🈳️之前pending状态存储的done函数表达式📦
//将🌹传入done的函数表达式📦并运行
//done的函数表达式📦内异步运行 将获取的🌹传入表达式 { print("end---\($0)---end") }并运行
//表达式内最终fullfill(())封存 Promise<Void>
func progress1() -> Promise<String> {
   return Promise<String> {
      print("---initial product---")
      $0.fulfill("🐝🐝🐝🐝🐝🐝")
   }
}
//---then---
func progress2(_ product: String) -> Promise<String> {
   print("---receive \(product)---")
   return Promise<String> {
      $0.fulfill("🌹🌹🌹🌹🌹🌹")
   }
}
//progress1().then(progress2)//.done { print($0) }

/**
 ---initial product---
 ⚠️selaValue: fulfilled("🐝🐝🐝🐝🐝🐝")
 ⚠️receive
 ⚠️return: pending(__lldb_expr_62.Handlers<__lldb_expr_62.Result<Swift.String>>)
 ---receive 🐝🐝🐝🐝🐝🐝---
 ⚠️selaValue: fulfilled("🌹🌹🌹🌹🌹🌹")
 ⚠️selaValue: fulfilled("🌹🌹🌹🌹🌹🌹")
 ⚠️mainAsyncresolved(__lldb_expr_62.Result<Swift.String>.fulfilled("🌹🌹🌹🌹🌹🌹"))
 */
progress1().then(progress2).done { print("end---\($0)---end") }

/// ---initial product ---
/// ⚠️selaValue: fulfilled("🐝🐝🐝🐝🐝🐝")
/// ⚠️receive
//then传入表达式progress1将🐝传入执行 (表达内将获取的值🐝传入progress2表达式-主队列异步执行 推迟)
/// ⚠️return: pending(__lldb_expr_72.Handlers<__lldb_expr_72.Result<Swift.String>>)
//创建emptyBox🈳️并返回 执行done 匹配到emptyBox🈳️的enum状态为pending 存入done的函数表达式📦
/// ⚠️done-->
/// ⚠️inspect pending
/// ⚠️appending
//开始运行延迟的 144 ⚠️mainAsyncresolved 函数表达式 print("---receive \(product)---")
///---receive 🐝🐝🐝🐝🐝🐝 ---
//received.pipe(to: emptyPromise.box.seal)   reveive: promise fullfill 🌹
///⚠️selaValue: fulfilled("🌹🌹🌹🌹🌹🌹")   🆕
//将接收到的🌹传入emptyBox🈳️的seal表达式并运行 塑封后emptyBox🈳️的enum --> resloved(🌹)
//并用变量存储emptyBox🈳️之前pending状态存储的done函数表达式📦
/// ⚠️selaValue: fulfilled("🌹🌹🌹🌹🌹🌹")   seal
//将🌹传入done的函数表达式📦并运行
/// ⚠️done-->Receive
/// ⚠️mainAsyncresolvedEnd(__lldb_expr_72.Result<Swift.String>.fulfilled("🌹🌹🌹🌹🌹🌹"))
//done的函数表达式📦内异步运行 将获取的🌹传入表达式 { print("end---\($0)---end") }并运行
/// ⚠️done-->MainAsyncStart
/// end---🌹🌹🌹🌹🌹🌹---end
//表达式内最终fullfill(())封存 Promise<Void>
/// ⚠️selaValue: fulfilled()



import Dispatch
public enum Result<T> {
   case fulfilled(T)
   case rejected(Error)
}
enum Sealant<R> {
   case pending(Handlers<R>)
   case resolved(R)
}
final class Handlers<R> {
   var bodies = [(R) -> Void]()
   func append(_ item: @escaping(R) -> Void) { bodies.append(item) }
}
class Box<T> {
   func inspect() -> Sealant<T> { fatalError() }
   func inspect(_: (Sealant<T>) -> Void) { fatalError() }
   func seal(_: T) {}
}
final class SealedBox<T>: Box<T> {
   let value: T
   init(value: T) {
      self.value = value
   }
   override func inspect() -> Sealant<T> {
      return .resolved(value)
   }
}
class EmptyBox<T>: Box<T> {
   private var sealant = Sealant<T>.pending(.init())
   private let barrier = DispatchQueue(label: "org.promisekit.barrier", attributes: .concurrent)
   override func seal(_ value: T) {
      var handlers: Handlers<T>!
      barrier.sync(flags: .barrier) {
         guard case .pending(let _handlers) = self.sealant else { return }
         handlers = _handlers
         self.sealant = .resolved(value)
         print("⚠️selaValue: \(value)")
      }
      if let handlers = handlers {
         handlers.bodies.forEach{ $0(value) }
      }
   }
   override func inspect() -> Sealant<T> {
      var rv: Sealant<T>!
      barrier.sync { rv = self.sealant }
      return rv
   }
   override func inspect(_ body: (Sealant<T>) -> Void) {
      var sealed = false
      barrier.sync(flags: .barrier) {
         switch sealant {
         case .pending: body(sealant)
         case .resolved: sealed = true
         }
      }
      if sealed { body(sealant) }
   }
}
extension Optional where Wrapped: DispatchQueue {
   @inline(__always)
   func async(flags: DispatchWorkItemFlags?, _ body: @escaping() -> Void) {
      switch self {
      case .none: body()
      case .some(let dispatchQueue):
         if let flags = flags {
            dispatchQueue.async(flags: flags, execute: body)
         } else {
            dispatchQueue.async(execute: body)
         }
      }
   }
}
public final class Resolver<T> {
   let box: Box<Result<T>>
   init(_ box: Box<Result<T>>) {
      self.box = box
   }
   deinit {
      if case .pending = box.inspect() { print("xxxxxx") }
   }
}
public extension Resolver {
   func fulfill(_ value: T) {
      box.seal(.fulfilled(value))
   }
}

public protocol Thenable: class {
   associatedtype T
   func pipe(to: @escaping(Result<T>) -> Void)
}
enum PMKUnambiguousInitializer {
   case pending
}
import class Foundation.Thread
public final class Promise<T>: Thenable {
   let box: Box<Result<T>>
   init(_: PMKUnambiguousInitializer) {
      box = EmptyBox()
   }
   public init(resolver body: (Resolver<T>) throws -> Void) {
      box = EmptyBox()
      let resolver = Resolver(box)
      do {
         try body(resolver)
      } catch {
         print("error")
      }
   }
   public func pipe(to: @escaping(Result<T>) -> Void) {
      switch self.box.inspect() {                    //第一inspect返回当前box内的enum
      case .pending:                                 //第二个inspect修改box内的enum
         box.inspect {                               print("⚠️inspect pending")
            switch $0 {
            case .pending(let handlers):             print("⚠️appending")
            handlers.append(to)
            case .resolved(let value):
               to(value)
            }
         }
      case .resolved(let value): to(value)
      }
   }
}
public struct PMKConfiguration {
   public var Q: (map: DispatchQueue?, return: DispatchQueue?) = (map: DispatchQueue.main, return: DispatchQueue.main)
}
public enum PMKError: Error {
   case returnedSelf
}
public var conf = PMKConfiguration()
public extension Thenable {
   func then<U: Thenable>(on: DispatchQueue? = conf.Q.map, flags: DispatchWorkItemFlags? = nil, _ body: @escaping(T) throws -> U) -> Promise<U.T> {
      let emptyPromise = Promise<U.T>(.pending)
      //注入函数表达式
      self.pipe {
         switch $0 {
         case .fulfilled(let value):               print("⚠️receive")
         on.async(flags: flags) {                 //主队列异步 按序执行 队列前如果有其他任务 则等待任务完成之后再执行
            do {
               let received = try body(value)     //闭包的运行要延迟到最后 接着运行 done
               guard received !== emptyPromise else { throw PMKError.returnedSelf }
               received.pipe(to: emptyPromise.box.seal)
               print(#line,"⚠️mainAsyncEnd\(emptyPromise.box.inspect())")
            } catch {
               emptyPromise.box.seal(.rejected(error))
            }
            }
         case .rejected(let error):
            emptyPromise.box.seal(.rejected(error))
         }
      }
      print("⚠️return: \(emptyPromise.box.inspect())")
      return emptyPromise
   }
   func done(on: DispatchQueue? = conf.Q.return, flags: DispatchWorkItemFlags? = nil, _ body: @escaping(T) throws -> Void) -> Promise<Void> {
      print("⚠️done-->")
      let empty = Promise<Void>(.pending)
      
      self.pipe {                                  print("⚠️done-->Receive")
         switch $0 {
         case .fulfilled(let value):
            on.async(flags: flags) {               print(#line, "⚠️done-->MainAsyncStart")
               do {
                  try body(value)
                  empty.box.seal(.fulfilled(()))
               } catch {
                  empty.box.seal(.rejected(error))
               }
            }
         case .rejected(let error):
            empty.box.seal(.rejected(error))
         }
      }
      
      return empty
   }
}
