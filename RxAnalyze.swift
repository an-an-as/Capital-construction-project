let disposeBag = DisposeBag()
let custom = Observable<String>.create { observer in
   observer.onNext("A")
   observer.onNext("B")
   observer.onCompleted()
   return Disposables.create()
}
custom.subscribe { print($0.element) }.disposed(by: disposeBag)

/// I N H E R I T O R
//
// static create(Anyobserver) -> AnonymousObservable(AnyObserver)
//     |                                                          |- override run(ObserverType, Cancelable) -> (Disposable, Disposable)
// ObservableType ------ Observable ------ Producer ------ AnonymousObservable
//     |                                      |
// subscribe(Event)->Disposable            override subscribe(ObserverType)->Disposable
//     |
// asObservable() -> Observable
//
//
//
//                                           | - forwardOn(Event): Observer.on(Event)
//                                           | - init(Observer, Cancelable)
//  |- onNext(element)                       |
//  |- on(Event)        Disposable -------- Sink ---- AnonymousObservableSink
//  |                       |                                        | - run(AnonymousObservable) -> Disposable
// ObserverType ----- ObserverBase ----- AnonymousObserver           | - on(Event)
//  |                       |- on(Event)      |
//  |                       |- onCore(Event)  |- override onCore(Event): handler(Event)
//  |- Anyobserver
//         |- init(Observer): (Event) -> Void = Observer.on
//         |- on(Event): run (Event)


// isDisposed
//   |
// Cancelable
// Disposable ----- SinkDisposer
//   |                 |
// Dispose()        setSinkAndSubscription(Disposable, Disposable)
//

//
//
//                                 - schedule<StateType>(StateType, @escaping (StateType) -> Disposable) -> Disposable
//          ImmediateSchedulerType - scheduleRecursive(State,) @escaping (State, `(State) -> Void`) -> Void) -> Disposable
//             |
//          CurrentThreadScheduler                              |-isDisposed     |-dispose()
//             |                                            |- Cancelable-------Disposable
//             |- ScheduleQueue = RxMutableBox<Queue<ScheduledItemType>>
//             |-                                           |- InvocableType -> invoke()
//             |- static let instance = CurrentThreadScheduler()
//             |- static var isScheduleRequiredKey
//             |-
//             |-
//             |-
//


/// S U M M A R Y
///
/// ```
///
///
/// create - anonymousObservable ------------- subscribe(Event)
///                |                            |
///                |                            |- asOBservable.subscribe(anonymousObserver(Event))
///          handler =  { AnyObserver.onNext }         |
///                                             create-anonymousObservable
///                                                    |
///                                             handler = { anonymousObservable.subscribe(ObserverType)  }
///                                                                                        |
///                                             schedual ---- run ---- sink(ObserverType).run(parent: anonymousObservable)
///                                                                                        |
///                                                                                  ** handler(Anyobserer(sink)) **
///                                                                                        |
///                      Anyobserver.onNext("A") --- Anyobserver.on(Event.next("A")) --- handler(Event.next("A"))
///                                                                                        |
///                                                                        handler = { sink.on(Event.next("A")) }
///                                                                                        |
///                   forwardOn(Event.next("A")) --- ObserverType.on(Event.next("A")) --- onCore(Event.next("A"))
///                                                                                        |
///                                                      handler = { Event.element } --- handler(Event.next("A"))
///
/// asOBservable.subscribe(anonymousObserver(Event))
///     |- schedual -- run -- sink(anonymousObserver(Event.element)).run(parent: anonymousObservable)
///     |- handler = { anonymousObservable.subscribe(Anyobserver(sink)) }
///
///     ** Anyobserver( Anyobserver(sink) ) **
///         | - handler = Anyobserver(sink).on(Event) --- sink.on(Event)
///
/// ```
///

/// D E T A I L
//.
/// Observable.create(AnyObserver)
/// AnonymousObservable(AnyObserver).subscribe(Event)
//  存储事件闭包,定义事件闭包的处理逻辑

/// AnonymousObservable(AnyObserver).asObservable()
/// Observable.create { AnonymousObservable(AnyObserver).subscribe(Anyobserver) }
//  通过调用子类方法来接收事件的处理逻辑,并将该闭包存储为函数表达式, (而处理逻辑最终存储在Sink通过Anyobserver传递)

/// AnonymousObservable( {AnonymousObservable(AnyObserver).subscribe(Anyobserver)} ).subscribe(AnonymousObserver(Event))
//  将上个步骤闭包存储为函数表达式接收事件参数,并将定义好的事件处理逻辑闭包通过第三方对象存储传入子类方法

/// !isSchedualRequest ? schedual()
// 线程操作避免循环调用

/// AnonymousObservable( {AnonymousObservable(AnyObserver).subscribe(Anyobserver)} ).run(AnonymousObserver(Event),SinkDispose)
/// <run>sink = AnonymousObservableSink(AnonymousObserver(Event), SinkDispose)
// 传递事件处理逻辑并进一步存储

/// sink.run(AnonymousObservable( {AnonymousObservable(AnyObserver).subscribe(Anyobserver)} ))
/// {AnonymousObservable(AnyObserver).subscribe(Anyobserver(sink))}
// 执行调用者的函数表达式传入参数

/// !isSchedualRequest ? schedual()
// 线程操作避免循环调用

/// AnonymousObservable(AnyObserver).run(Anyobserver(sink))
/// <run>sink = AnonymousObservableSink(Anyobserver(sink), SinkDispose)
/// sink.run(AnonymousObservable(AnyObserver))
/// handler = { AnyObserver.onNext("A") }     -- 产生事件
/// handler( AnyObserver(Anyobserver(sink)) ) -- 处理逻辑

/// AnyObserver(Anyobserver(sink)).on(Event.next("A"))
/// handler = Anyobserver(sink).on(Event.next("A"))
/// handler = AnonymousObservableSink(Anyobserver(sink), SinkDispose).on(Event.next("A"))
/// Anyobserver(sink).on(Event.next("A"))
/// AnonymousObservableSink(AnonymousObserver(Event), SinkDispose).on(Event.next("A"))
/// forWardOn(Event.next("A"))
/// AnonymousObserver(Event.element).on(Event.next"A")
/// onCore(Event.next"A")
/// handler = { Event.element }
/// handler(Event.next("A"))

/// S I M P L E
//
//         OnNext(产生).subscribe(处理) ---asObservabler--> AnonymousObservable-handler: { AnonymousObservable-handler:OnNext(E).subscribe(AnyObserve) }.subscribe(E)
//
//         subscribe-schedule-run -> AnonymousObservableSink-observer: AnonymousObserver-handler: { (Event) -> Void }
//
//         AnonymousObservable(AnyObserver(sink))
//
//         AnonymousObservable{产生}.run(处理)  --> sink(处理).run(产生) --> { AnyObserver(sink<处理>) .onNext("A") }
//                                                                               |              | self.on(.next"A")
//                                                                         handler: sink.on
//                                                                                        |
//                                                                                       sink.handler: 处理
//
///     S U B S C R I B E                   C R E A T E
// AnonymousObervable-handler: { AnonymousObervable.subscribe(AnyObserve) }.subscribe(AnonymousObserver(Event))
//                                                                              |               disposable.setSinkAndSubscription
///                                                                       isScheduleRequired {  self.run(AnonymousObserver(Event))  }()  通过p_thread避免循环调用
//                                                                                                     |
//                                                                        sink=AnonymousObservableSink(Observer).run(self) **sink.handler:AnonymousObserver(Event)**
//                                                                                                                           |
//                                                                        AnonymousObervable-handler( AnyObserver(self)) ) **init:AnyObserver-handler: sink.on**
//                                                                                                        |
//                                                  {  AnonymousObservable(AnyObserver).subscribe( AnyObserver-handler: AnonymousObserver(Event).on ) }()
//                                                                                                        |
///asObservable                               isScheduleRequired {  self.run(AnyObserver-handler))  }() 运行isSchedual将闭包加入队列等待执行(前面已尽对p_thread设置过)
//                                                                      |
//                                         sink = AnonymousObserableSink(AnyObserver-handler).run(self)     **self: AnonymousObservable(AnyObserver)**
//                                                                                             |
//                                                     AnonymousObservable-handler( AnyObserver(sink) )
//                                                                                      |
//                                                                                {  AnyObserver(sink) .onNext("A") } **onNext: self.on( .next("A") )**
//                                                                                   AnyObserver(sink) .onNext("B")
//                                                                                      |
//                                                                                   AnyObserver.on(.next("A"))       **AnyObserver-handler: sink.on**
//                                                                                                |
//                                                                                   AnyObserver-handler(.next"A")- sink.on(.next"A")
//                                                                                                                        |
//                                                                                   case .next: sefl.forwordOn(.next"A")- sink.handler(.next"A")
//                                                                                                                                |
//                                        AnyObserver(sink)- sink.on(.next"A") -  self.handler { $0.element } - case.next(let value) - retutn "A"
//


//通过基类遵循协议 对外提供方法接口 ObservableType 该协议单边遵守作用为接收 Anyobserver 进而传入闭包
public class Observable<Element>: ObservableType {
   public func subscribe<Observer: ObserverType>(_ observer: Observer){}
}
//隐藏内部实现 通过继承实现的多态此时由run承担 Template-subscribe需要继承并且执行多态run
class Producer<Element>: Observable<Element> {
   func run<Observer: ObserverType>(_ observer: Observer) { fatalError() }
   override func subscribe<Observer: ObserverType>(_ observer: Observer) where Observer.Element == Element {
      self.run(observer)
   }
}
final class AnonymousObservable<Element>: Producer<Element> {
   //传入第三方中间类用于连接事件的产生和处理
   typealias SubscribeHandler = (AnyObserver<Element>) -> Void
   let _subscribeHandler: SubscribeHandler
   init(_ subscribeHandler: @escaping SubscribeHandler) {
      self._subscribeHandler = subscribeHandler
   }
   override func run<Observer: ObserverType>(_ observer: Observer) where Element == Observer.Element  {
      //将事件的产生和处理全部传入sink
      AnonymousObservableSink(observer: observer).combine(self)
   }
}
class Sink<Observer: ObserverType> {
   fileprivate let _observer: Observer
   init(observer: Observer) {
      self._observer = observer
   }
   final func forwardOn(_ event: Event<Observer.Element>) {
      self._observer.on(event)
   }
}
// 该类在事件发生类使用通过combine将其传入
// 该类用于存储存储事件的处理(事件的处理由协议带入) 同时具备其相同的功能on以便传递
final private class AnonymousObservableSink<Observer: ObserverType>: Sink<Observer>, ObserverType {
   typealias Element = Observer.Element
   typealias Sink = AnonymousObservable<Element>
   func on(_ event: Event<Element>) {
      if case .next = event { forwardOn(event) }
   }
   func combine(_ parent: Sink) {
      //AnyObserver 遵守了ObserverType 和 AnonymousObserver 具有相同的功能 作用为转换功能 传入闭包
      //闭包调用了AnyObserver. onNext方法间接激活AnonymousObserver的闭包并将产生的事件对象参数传入
      return parent._subscribeHandler(AnyObserver(self))
   }
}

class ObserverBase<Element> {
   func onCore(_ event: Event<Element>) { fatalError() }
}
// 静态执行不可修改
extension ObserverBase: ObserverType  {
   func on(_ event: Event<Element>) {
      if case .next = event {  self.onCore(event) }
   }
}
class AnonymousObserver<Element>: ObserverBase<Element> {
   typealias EventHandler = (Event<Element>) -> Void
   private let _eventHandler: EventHandler
   init(_ eventHandler: @escaping EventHandler) {
      self._eventHandler = eventHandler
   }
   override func onCore(_ event: Event<Element>) {
      return self._eventHandler(event)
   }
}

extension ObservableType {
   ///存储闭包onNext创建Event对象传入代理方法执行(该闭包等待处理Event对象的参数)再通过AnyObserver桥接代理方法
   /// { $0.on }      产生  代理方法on
   ///                 |   相互等待 产生需要执行-执行需要产生  第三方 sink-Anyobserver将Event传入执行
   /// { $0.element } 执行  执行代理on
   ///
   public static func create(_ subscribe: @escaping (AnyObserver<Element>) -> Void) -> Observable<Element> {
      return AnonymousObservable(subscribe)
   }
   public func subscribe(_ on: @escaping (Event<Element>) -> Void) {
      let observer = AnonymousObserver { on($0) }
      self.subscribe(observer)
   }
}


let event = Observable<String>.create {
   $0.onNext("a")
   $0.onNext("b")
   $0.onNext("c")
}
// sink 激活前面的闭包并存储{ $0.element! }   通过 Anyobserver 函数化sink.on    传入见面的闭包
event.subscribe { print($0.element!) }

//: ---
//:>*
//:>+ onNext: 模版方法 创建一个Event事件 关联参数通过装饰器OnNext获取 执行.on(Event)传递出去 该方法由遵循 AnyobserType 的类实现
//:>+ create: 整个闭包由AnonymousObservable存储
//:>- subscribe: 通过AnonymousObserver存储闭包 { $0.element } 实现.on(Event) 可将Event传入闭包并激活
//:>-            AnonymousObservableSink.run(self)    **sink.observer AnonymousObserver-handler:{ $0.element }**
//:>-
//:>- sink.run   AnonymousObservable.handler { $0.onNext("a")  }()  onNext 激活$0的on方法
//:>-                                           | “a”传入激活
//:>-                                          AnyObserver(sink)    函数表达式 sink.on  oncore将“A”传入闭包
//:>-
//:>-
//:>-
//:>-
//:>-
let arrayDictionaryMaxSize = 30
struct BagKey {
   fileprivate let rawValue: UInt64
}
extension BagKey: Hashable {
   //哈西化后作为key
   func hash(into hasher: inout Hasher) {
      hasher.combine(rawValue)
   }
}
func ==(lhs: BagKey, rhs: BagKey) -> Bool {
   return lhs.rawValue == rhs.rawValue
}
/**
 ContiguousArray Array 还有 ArraySlice 的大部分属性和方法是共用的。
 在存储Class或者@objc协议时，使用ContiguousArray效率会更高一些。
 但是ContiguousArray不能和Objective-C的NSArray进行桥接，并且不能将ContiguousArray传入到Objective-C的API中
 */
struct Bag<T> {
   typealias KeyType = BagKey
   typealias Entry = (key: BagKey, value: T)
   private var _nextKey: BagKey = BagKey(rawValue: 0)
   var _key0: BagKey?
   var _value0: T?
   var _pairs = ContiguousArray<Entry>()
   var _dictionary: [BagKey: T]?
   //第一次由属性存储
   var _onlyFastPath = true
   init() {}
}
extension Bag {
   var count: Int {
      let dictionaryCount: Int = _dictionary?.count ?? 0
      return (_value0 != nil ? 1 : 0) + _pairs.count + dictionaryCount
   }
}
extension Bag {
   //通过改变struct的值设为key 第一次存入存储属性 接着存入数组 超过30存入字典 存入on(Event)的闭包表达式
   mutating func insert(_ element: T) -> BagKey {
      let key = _nextKey
      _nextKey = BagKey(rawValue: _nextKey.rawValue &+ 1)
      //第一次写入(只有一个Event对象)
      if _key0 == nil {
         _key0 = key
         _value0 = element
         return key
      }
      _onlyFastPath = false
      //array满30后的存储
      if _dictionary != nil {
         _dictionary![key] = element
         return key
      }
      //第二次开始存入元组知道元素数量达到30
      if _pairs.count < arrayDictionaryMaxSize {
         _pairs.append((key: key, value: element))
         return key
      }
      //元素数量达到30后开始存入字典
      _dictionary = [key: element]
      return key
   }
}
extension Bag {
   mutating func removeKey(_ key: BagKey) -> T? {
      if _key0 == key {
         _key0 = nil
         let value = _value0!
         _value0 = nil
         return value
      }
      if let existingObject = _dictionary?.removeValue(forKey: key) {
         return existingObject
      }
      
      for i in 0 ..< _pairs.count where _pairs[i].key == key {
         let value = _pairs[i].value
         _pairs.remove(at: i)
         return value
      }
      return nil
   }
}
extension Bag {
   mutating func removeAll() {
      _key0 = nil
      _value0 = nil
      _pairs.removeAll(keepingCapacity: false)
      _dictionary?.removeAll(keepingCapacity: false)
   }
}
extension Bag {
   func forEach(_ action: (T) -> Void) {
      if _onlyFastPath {
         if let value0 = _value0 {
            action(value0)
         }
         return
      }
      let value0 = _value0
      let dictionary = _dictionary
      if let value0 = value0 {
         action(value0)
      }
      for i in 0 ..< _pairs.count {
         action(_pairs[i].value)
      }
      if dictionary?.count ?? 0 > 0 {
         for element in dictionary!.values {
            action(element)
         }
      }
   }
}
extension Bag: CustomDebugStringConvertible {
   var debugDescription : String {
      return "\(self.count) elements in Bag"
   }
}

func dispatch<Element>(_ bag: Bag< (Event<Element>) -> Void >, _ event: Event<Element>) {
   bag._value0?(event) //激活第一次的存储
   if bag._onlyFastPath {
      return
   }
   let pairs = bag._pairs //激活第二次的存储
   for i in 0 ..< pairs.count {
      pairs[i].value(event)
   }
   if let dictionary = bag._dictionary {
      for element in dictionary.values {
         element(event)
      }
   }
}

extension AnyObserver {
   typealias s = Bag<(Event<Element>) -> Void>
}
public final class PublishSubject<Element>: Observable<Element> {
   typealias Observers = AnyObserver<Element>.s
   private var _observers = Observers()
   public override init() { super.init() }
   public override func subscribe<Observer: ObserverType>(_ observer: Observer) where Observer.Element == Element {
      //激活AnymousObserver的on此时作为函数表达式传入Bag存储
      _observers.insert(observer.on)
   }
}
extension PublishSubject: ObserverType {
   public func on(_ event: Event<Element>) {
      //将装好函数表达式的Bag传入dispatch
      dispatch(self._observers, event)
   }
}
var publish = PublishSubject<Int>()
publish.subscribe { print("A: \($0)") }// 创建AnonymousObserver 调用self.subscribe 存储到Bag
publish.subscribe { print("B: \($0)") }
publish.onNext(1)
publish.onNext(2)
publish.onNext(3)


import class Foundation.NSLock
final class AtomicInt: NSLock {
   fileprivate var value: Int32
   public init(_ value: Int32 = 0) {
      self.value = value
   }
}
@discardableResult
@inline(__always)
func fetchOr(_ this: AtomicInt, _ mask: Int32) -> Int32 {
   this.lock()
   let oldValue = this.value
   this.value |= mask
   this.unlock()
   return oldValue
}

enum DisposeState: Int32 {
   case disposed = 1
   case sinkAndSubscriptionSet = 2
}
let _state = AtomicInt(0)
func once() {
   //修改  0|2=2  2|2=2
   let previousState = fetchOr(_state, DisposeState.sinkAndSubscriptionSet.rawValue)
   //0&1=0 1&2=0 2&2=2
   guard !((previousState & DisposeState.sinkAndSubscriptionSet.rawValue) != 0) else {
      print("⚠️Sink and subscription were already set!")
      return
   }
   // 0&1=0 1&2=0 2&2=2
   if (previousState & DisposeState.disposed.rawValue) != 0 {
      print("excute")
   }
}
once()
once()

//:---
//:>#### fetchOr 函数的作用类似于标记 通过判断标志位的状态来控制值的传递与否
//:>+ 实际的10进制结果不变，只是改变了里面的二进制位，可以用来做标志位 是C语言里面经常用的方法，
//:>+ 即一个Int类型处理本身的值可以使用外，还可以通过按位与，或，来改变它的标志位,达到传递值的目的
//:```或运算
//:      二进制          十进制
//:      0000 0001      1
//:      0000 0010      2
//:      0000 0011      3
//:
//:```
//:>- fetchOr（）函数的作用就是，可以确保每段代码只被执行一次，就相当于一个标志位
//:>- 如果初始值为0 ，如果传入参数1
//:>- 假设这段代码重复执行5次，只有第一次会从0变为1 后面四次调用都是为1，不会发送变化
//:
//:```
//:   this.value   mask   oldValue    或 运算后this.value   返回值
//:   0             1        0.       1<                    0
//:   1             1        1        1=                    1
//:   0             2        0.       2<                    0
//:   1             2        1        3<                    1
//:   2             2        2        2=                    2  <---
//:
//:
//:   this.value   mask   oldValue   &                   返回值
//:   0             1        0       0                    0
//:   1             1        1       1                    1
//:   0             2        0       0                    0
//:   1             2        1       0                    1
//:   2             2        2       2                    2   <---
//:```
//:```

//:>#### 递归锁 Recursive locks
//:>+ 允许单个线程多次获取相同的锁。
//:>+ 非递归锁被同一线程重复获取时可能会导致死锁、崩溃或其他错误行为
//:>
//:>
//:>+ NSRecursiveLock 是递归锁，他和 NSLock 的区别在于
//:>+ NSRecursiveLock 可以在一个线程中重复加锁（反正单线程内任务是按顺序执行的，不会出现资源竞争问题
//:>+ NSRecursiveLock 会记录上锁和解锁的次数，当二者平衡的时候，才会释放锁，其它线程才可以上锁成功
//:
//:>#### 自旋锁 Spinglock
//:>+ 使用一个循环不断地检查锁是否被释放。
//:>+ 如果等待情况很少话这种锁是非常高效的，相反会浪费 CPU 时间。
//:>
//:>#### 递归锁 Recursive locks
//:>+ 允许单个线程多次获取相同的锁。
//:>+ 非递归锁被同一线程重复获取时可能会导致死锁、崩溃或其他错误行为
//:>
//:>
//:>#### 阻塞锁Blocking locks
//:>+ 常见的表现形式是当前线程会进入休眠，直到被其他线程释放。
//:>- `NSLock` 是 `Objective-C` 类的阻塞锁
//:>- `pthread_mutex_t` 是一个可选择性地配置为递归锁的阻塞锁
//:>- dispatch_queue_t 可以用作阻塞锁，也可以通过使用 barrier block 配置一个同步队列作为读写锁，还支持异步执行加锁代码
//:>
//:>#### 读写锁 Reader/writer locks
//:>+ 允许多个读线程同时进入一段代码，但当写线程获取锁时，其他线程（包括读取器）只能等待。
//:>+ 这是非常有用的，因为大多数数据结构读取时是线程安全的，但当其他线程边读边写时就不安全了。
//:>+ - pthread_rwlock_t
//:>+

//:>+
//:>+

//:>+
//:>+ [参考(1).](https://swift.gg/2018/06/07/friday-qa-2015-02-06-locks-thread-safety-and-swift/)
//:>+ [参考(2).](https://blog.csdn.net/changexhao/article/details/80666823)

import Foundation
final class View: NSObject, NSCopying {
   var name = ""
   func copy(with zone: NSZone? = nil) -> Any {
      let copy = View()
      print("copyed")
      copy.name = name
      return copy
   }
}
final class Test: NSObject {
   @NSCopying var currentView: View
   init(view : View) {
      self.currentView = view
      super.init()
   }
}
var view1 = View()
view1.name = "R E D"

let test = Test(view: view1)
test.currentView.name

test.currentView.name
let new = view1.copy() as! View
//:---
//:>+ 如果类想要支持copy操作，则必须实现NSCopying协议，也就是说实现copyWithZone方法;
//:>+ 如果类想要支持mutableCopy操作，则必须实现NSMutableCopying协议，也就是说实现mutableCopyWithZone方法;
//:>+ 如果向未实现相应方法的系统类或者自定义类发送copy或者mutableCopy消息，则会crash
//:>- 发送copy消息，拷贝出来的是不可变对象;发送mutableCopy消息，拷贝出来的是可变对象;
//:>- 不可变对象copy，是浅拷贝，也就是说指针复制；发送mutableCopy，是深复制，也就是说内容复制
//:>- 可变对象copy和mutableCopy均是单层深拷贝，也就是说单层的内容拷贝；
//:>* Swift 中的@NSCopying和 Objective-C 中的copy关键字类似。
//:>* @NSCopying修饰的属性必须是遵循NSCopying协议的，而在 Swift 中， NSCopying协议被限制给类使用。
//:>*
//:>*
//: 自定义类去遵循NSCopying协议，不太符合 Swift 的类型体系：请使用结构体！
//: [Previous](@previous)|[Next](@next)

import class Foundation.NSRecursiveLock
typealias RecursiveLock = NSRecursiveLock
extension RecursiveLock {
   @inline(__always)
   final func performLocked(_ action: () -> Void) {
      self.lock(); defer { self.unlock() }
      action()
   }
   @inline(__always)
   final func calculateLocked<T>(_ action: () -> T) -> T {
      self.lock(); defer { self.unlock() }
      return action()
   }
   @inline(__always)
   final func calculateLockedOrFail<T>(_ action: () throws -> T) throws -> T {
      self.lock(); defer { self.unlock() }
      let result = try action()
      return result
   }
}

import Foundation
func incrementor(ptr: UnsafeMutablePointer<Int>) {
   ptr.pointee += 1
}
var numberA = 10
incrementor(ptr: &numberA)
numberA

func incrementor1(num: inout Int) {
   num += 1
}
var numberB = 10
incrementor1(num: &numberB)
numberB

var intPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)//为指针分配内存
intPtr.initialize(to: 10)//初始化内存
intPtr.deinitialize(count: 10)
intPtr.deallocate()

//UnsafeMutableBufferPointer
//BufferPointer 是一段连续的内存的指针，通常用来表达像是数组或者字典这样的集合类型
//baseAddress   是第一个元素的指针，类型为 UnsafeMutablePointer<Int>
var array = [10, 20, 30, 40, 50]
UnsafeMutableBufferPointer<Int>(start: &array, count: array.count).baseAddress.map {
   print($0)
   print($0.pointee)
   $0.pointee = 5_000 //根据当前baseAddress.pointee 修改元素值
   print(array)
   print($0.pointee)
   print($0.successor().pointee)//下一个元素
}
//withUnsafePointer 或 withUnsafeMutablePointer 的差别是前者转化后的指针不可变，后者转化后的指针可变
var testNumber = 10
testNumber = withUnsafeMutablePointer(to: &testNumber) {
   $0.pointee += 1//对地址上的值修改
   return $0.pointee
}
testNumber


// unsafeBitCast 是非常危险的操作，它会将一个指针指向的 内存 强制按位转换为目标的类型。
// 因为这种转换是在 Swift 的类型管理之外进行的，因此编译器无法确保得到的类型是否确实正确，你必须明确地知道你在做什么
let arr = NSArray(object: "meow")
let str = unsafeBitCast(CFArrayGetValueAtIndex(arr, 0), to: CFString.self)// 内存转换
str
/**
 因为 NSArray 是可以存放任意 NSObject 对象的，
 当我们在使用 CFArrayGetValueAtIndex 从中取值的时候，得到的结果将是一个 UnsafePointer<Void>。
 由于我们很明白其中存放的是 String 对象，因此可以直接将其强制转换为 CFString。
 
 关于 unsafeBitCast 一种更常见的使用场景是 不同类型的指针之间进行转换。
 因为指针本身所占用的的大小是一定的，所以指针的类型进行转换是不会出什么致命问题的。
 这在与一些 C API 协作时会很常见。
 比如有很多 C API 要求的输入是 void *，对应到 Swift 中为 UnsafePointer<Void>。
 我们可以通过下面这样的方式将任意指针转换为 UnsafePointer。
 */
var count = 100
let voidPtr = withUnsafePointer(to: &count) { UnsafeRawPointer($0) } //指针转换为C
print(voidPtr)
voidPtr.assumingMemoryBound(to: Int.self).pointee// 转换回 UnsafePointer<Int>

//:---
//:>+ UnsafeMutablePointer
//:>+ UnsafeMutableBufferPointer  baseAddress  pointee  successor
//:>+ withUnsafeMutablePointer 可修改
//:>+ unsafeBitCast 内存转换为指定类型 危险
//:>+ UnsafeRawPointer转换到C的指针
//:
//: [Previous](@previous)|[Next](@next)


import Foundation
import Darwin
import class Foundation.Thread
import protocol Foundation.NSCopying
//Thread存储Queue
extension Thread {//Thread线程字典 key 需要一个NSCopying对象
   static func setThreadLocalStorageValue<T: AnyObject>(_ value: T?, forKey key: NSCopying) {
      let currentThread = Thread.current
      let threadDictionary = currentThread.threadDictionary//NSMutableDictionary key:value
      if let newValue = value {
         threadDictionary[key] = newValue
      }
      else {
         threadDictionary[key] = nil
      }
   }
   static func getThreadLocalStorageValueForKey<T>(_ key: NSCopying) -> T? {
      let currentThread = Thread.current
      let threadDictionary = currentThread.threadDictionary
      return threadDictionary[key] as? T
   }
}
//一个Box装以Queue
final class RxMutableBox<T> {
   var value: T
   init (_ value: T) {
      self.value = value
   }
}
class CurrentThreadSchedulerQueueKey: NSObject, NSCopying {
   static let instance = CurrentThreadSchedulerQueueKey()
   private override init() {
      super.init()
   }
   override var hash: Int {
      return 0
   }
   public func copy(with zone: NSZone? = nil) -> Any {
      return self
   }
}
typealias ScheduleQueue = RxMutableBox<Int>//RxMutableBox<Queue<ScheduledItemType>>
//利用对 queue的set,get方法的观察，绑定当前队列与静态字符串
var queue: ScheduleQueue? {
   get { //将一个可以深拷贝的类作为KEY
      return Thread.getThreadLocalStorageValueForKey(CurrentThreadSchedulerQueueKey.instance)
   }
   set { //将Queue存储到线程字典
      Thread.setThreadLocalStorageValue(newValue, forKey: CurrentThreadSchedulerQueueKey.instance)
   }
}
///线程特有数据的key, 用于pthread_setspecific的键
//这是一个静态（static）的属性，它会保存创建后的线程特有数据的 key
//所以可以将申请的内存空间进行释放，而不会丢失线程特有数据的 key   static var scheduleRequiredKey
var scheduleRequiredKey: pthread_key_t = {
   let key = UnsafeMutablePointer<pthread_key_t>.allocate(capacity: 1)//为指针分配内存(可变)
   defer { key.deallocate() }
   guard pthread_key_create(key, nil) == 0 else { fatalError() }//在指定内存上创建key
   //第二个参数是一个清理函数，用来在线程释放该线程存储的时候被调用
   //设成nil, 系统将调用默认的清理函数。该函数成功返回0.其他任何返回值都表示出现了错误
   return key.pointee//返回指针指向的内存上的值
}()
///创建指针分配内存并转换为C类型的指针, 该内存用于pthread_setspecific的值
var scheduleInProgressSentinel: UnsafeRawPointer = {
   return UnsafeRawPointer(UnsafeMutablePointer<Int>.allocate(capacity: 1))
}()
//是否需要线程特有数据 该布尔判断为所在线程特有
//isScheduleRequired 就是通过在线程特有数据的 key 设置或清除一个 Int 指针来保存 true 或 false
var isScheduleRequired: Bool {
   get {
      //如果需要取出所存储的值，调用pthread_getspecific() 该函数返回void*类型的值。
      return pthread_getspecific(scheduleRequiredKey) == nil
   }
   set(isScheduleRequired) {
      //当线程中需要存储特殊值的时候调用该函数
      //该函数有两个参数，第一个为前面声明的pthread_key_t变量，第二个为void*变量，用来存储任何类型的值。
      if pthread_setspecific(scheduleRequiredKey,
                             isScheduleRequired ? nil : scheduleInProgressSentinel) != 0 {
         fatalError("pthread_setspecific failed❕")
      }
   }
}
var arr = [() -> Void]()
//action 在 schedule 方法中被执行，如果再在 action 中调用 schedule 这样势必会造成循环调用
//为了避免循环引用在 schedule 方法中，在执行 action 之前
//首先判断当前线程中之前是否有调用过 schedule 方法,并且还没有执行结束
//如果有则先将 action 保存到和线程关联的队列中，如果没有则直接执行 action
//执行结束后查看和线程关联的队列中是否有未执行的 action
//那么怎样判读一个线程是否正在执行一个方法呢？这里需要引入线程特有数据 （Thread Specific Data 或 TSD）
func schedule(action: @escaping () -> Void) -> Int {
   if isScheduleRequired {
      isScheduleRequired = false
      action()
      defer {
         isScheduleRequired = true
      }
      arr.removeLast()()
      return 1
   }
   print("🌹🌹🌹🌹🌹")
   arr.append(action)
   return 0
}
print(schedule { _ = schedule { print("H E L L O") } })


//:---
//:> ### 线程特有数据
//:>+ 在一个线程内部的各个函数都能访问、但其它线程不能访问的变量，
//:>+ 我们就需要使用线程局部静态变量(Static memory local to a thread)
//:>+ 同时也可称之为线程特有数据（Thread-Specific Data 或 TSD），或者线程局部存储（Thread-Local Storage 或 TLS）
//:>+ POSIX 线程库提供了如下 API 来管理线程特有数据（TSD）
//:>+ OS X和iOS提供使用POSIX线程API创建线程基于C的支持。 pthread
//:>+ 该技术可以在任何类型的应用中使用（包括Cocoa和Cocoa Touch应用），并且当你在为多平台编写软件时会更加方便。
//:>+ 用来创建线程的POSIX程序称为pthread_create。
//:>- 你可以使用该字典来存储贯穿线程执行过程的信息。例如，你可以使用它来存储线程运行循环的多次迭代的状态信息。
//:>- 在Cocoa中，你使用NSThread 对象的threadDictionary 方法
//:>- 来检索一个NSMutableDictionary 对象，你可以往该对象添加任何你线程需要的键。
//:>- 在POSIX中，你使用pthread_setspecific函数和pthread_getspecific 函数来设置或获取你线程的键值对。
//:>*
//:>* 在多线程程序中，所有线程共享程序中的变量。现在有一全局变量，所有线程都可以使用它，改变它的值。
//:>* 而如果每个线程希望能单独拥有它，那么就需要使用线程存储了
//:>* 线程存储是实现同一个线程中不同函数间共享数据的一种很好的方式
//:>* pthread_key_t无论是哪一个线程创建，其他所有的线程都是可见的，即一个进程中只需phread_key_create()一次。
//:>* 看似是全局变量，然而全局的只是key值，对于不同的线程对应的value值是不同的
//:>*  (通过pthread_setspcific()和pthread_getspecific()设置)
//:>* 不论哪个线程调用pthread_key_create()，
//:>* 所创建的key都是所有线程可访问的，但各个线程可根据自己的需要往key中填入不同的值，
//:>* 这就相当于提供了一个同名而不同值的全局变量
//:>* 写入（pthread_setspecific()）时，
//:>* 将pointer的值（不是所指的内容）与key相关联，而相应的读出函数则将与key相关联的数据读出来。
//:>* 数据类型都设为void *，因此可以指向任何类型的数据。
//:>* 调用pthread_key_create()来创建该变量。
//:>* 该函数有两个参数，第一个参数就是上面声明的pthread_key_t变量，第二个参数是一个清理函数，
//:>* 用来在线程释放该线程存储的时候被调用。
//:>* 该函数指针可以设成 NULL，这样系统将调用默认的清理函数。该函数成功返回0.其他任何返回值都表示出现了错误。
//:>*
//:>* [参考(1)](https://github.com/FuYouFang/fuyoufangBlog/blob/master/articles/Thread_Specific_Data.md)
//:>* [参考(2)](https://www.jianshu.com/p/6a63f7353ad4)
//:>* [参考(3)](https://juejin.im/post/5ac4e162518825558b3e288b)
//:>
//: [Previous](@previous)|[Next](@next)
