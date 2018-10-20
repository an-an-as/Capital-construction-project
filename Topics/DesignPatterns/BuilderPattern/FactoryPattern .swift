/// swiftlint:disable identifier_name
/**
 + 简介: 这种类型的设计模式属于创建型模式，在创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。
 + 意图：定义一个创建对象的接口，让其子类自己决定实例化哪一个工厂类，工厂模式使其创建过程延迟到子类进行。
 + 主要解决：主要解决接口选择的问题。
 + 何时使用：我们明确地计划不同条件下创建不同实例时。
 + 如何解决：让其子类实现工厂接口，返回的也是一个抽象的产品。
 + 关键代码：创建过程在其子类执行。
 + 应用实例：
 + 1、您需要一辆汽车，可以直接从工厂里面提货，而不用去管这辆汽车是怎么做出来的，以及这个汽车里面的具体实现。
 + 2、Hibernate 换数据库只需换方言和驱动就可以。
 + 优点：
 + 1、一个调用者想创建一个对象，只要知道其名称就可以了。
 + 2、扩展性高，如果想增加一个产品，只要扩展一个工厂类就可以。
 + 3、屏蔽产品的具体实现，调用者只关心产品的接口。
 + 缺点：
 每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖。这并不是什么好事。
 + 使用场景：
 + 1、日志记录器：记录可能记录到本地硬盘、系统事件、远程服务器等，用户可以选择记录日志到什么地方。
 + 2、数据库访问，当用户不知道最后系统采用哪一类数据库，以及数据库可能有变化时。
 + 3、设计一个连接服务器的框架，需要三个协议，"POP3"、"IMAP"、"HTTP"，可以把这三个作为产品类，共同实现一个接口。
 + 注意事项：
 作为一种创建类模式，在任何需要生成复杂对象的地方，都可以使用工厂方法模式。
 有一点需要注意的地方就是复杂对象适合使用工厂模式，而简单对象，特别是只需要通过 new 就可以完成创建的对象，无需使用工厂模式。
 如果使用工厂模式，就需要引入一个工厂类，会增加系统的复杂度。
 
 -----
 */

/*********************    Simple Factory Pattern   *******************
WeapUser                             WeaponFactory 枚举武器类型 选定创建                                                   接口协议 WeaponType 都具备的功能fire()
WeapFactory           ---------->    createWeaponWithType(weaponType: WeaponTypeEnumeration) -> WeaponType  ----->     接口实现 AK AWP HK  呈现多态
func fireWithType()                                                                                                                       |
选定武器类型通过工厂创建                                                                                                                  WeaponUser
                                                                                                                                     存储属性 WeaponFactory
                                                                                                                                     共有方法: 选择武器 倒入createWeaponWithType
 */

protocol WeaponProtocol {
    func fire() -> String
}
private class AWP: WeaponProtocol {
    func fire() -> String {
        return "AWP FIRE"
    }
}
private class AUG: WeaponProtocol {
    func fire() -> String {
        return "AUG FIRE"
    }
}
private class AK47: WeaponProtocol {
    func fire() -> String {
        return "AK47 FIRE"
    }
}
public enum WeaponEnumation {
    case AWP, AUG, AK47
}
private struct WeaponFactory {
    func createWeapon(select: WeaponEnumation) -> WeaponProtocol {
        switch select {
        case .AK47:
            return AK47()
        case .AUG:
            return AUG()
        case .AWP:
            return AWP()
        }
    }
}
public struct WeaponUser {
    private let factory = WeaponFactory()
    public func fire(select: WeaponEnumation) {
        let weapon = factory.createWeapon(select: select)
        print(weapon.fire())
    }
}
let user1 = WeaponUser()
user1.fire(select: .AK47)

/***************************************   No Factory Pattern  ********************************************/
protocol WeaponProtocol {
    func fire() -> String
}
private class AWP: WeaponProtocol {
    func fire() -> String {
        return "AWP FIRE"
    }
}
private class AUG: WeaponProtocol {
    func fire() -> String {
        return "AUG FIRE"
    }
}
private class AK47: WeaponProtocol {
    func fire() -> String {
        return "AK47 FIRE"
    }
}
public enum WeaponEnumation {
    case AWP, AUG, AK47
}
public struct User {
    func fire(select: WeaponEnumation) {
        var weapon: WeaponProtocol
        switch select {
        case .AK47:
            weapon = AK47()
        case .AUG:
            weapon = AUG()
        case .AWP:
            weapon = AWP()
        }
        print(weapon.fire())
    }
}
let user1 = User()
user1.fire(select: .AK47)

/***************************************  Factory Method Pattern  ********************************************
+ 工厂方法模式：定义了一个创建对象的接口，但由子类决定要实例化的类是哪一个。工厂方法让类把实例化推迟到子类。
+ 依赖倒置原则：要依赖抽象，不要依赖具体类
+ 使用“装饰者模式”为武器添加不同的装饰（生产厂商）

````
 接口协议 WeaponProtocol 都具备的功能fire()                                             接口协议: WeaponUser
 接口实现 AK AWP AUG  遵循协议呈现多态 -----  各类型fire()不同的实现                                 createWeapon(枚举) -> WeaponProtocol!  (AK AWP AUG Decorator )
 接口装饰 WeaponDecorator 遵循协议       |  倒入到装饰器提取原先的实现                      默认实现: fireWithType(枚举)
        fire()                        |                                                      weapon = createWeapon  weapon.fire()   (可以返回具体武器或装饰器)
        weapon: WeaponProtocol  <-----   通过继承添加额外的信息
             |                                                                      接口实现: GermanyWeaponUser 使用德国制
             | 继承 WeaponDecorator                                                           createWeapon(枚举) -> WeaponProtocol!
        GermanyDecorator: fire() -> 通过子类添加额外信息         <-----------------------------  switch 类型的枚举创建具体子类的实例 GermanyDecorator()
        AmericaDecorator: fire() -> return "美国造：" + weapon.fire()
 
 ````
*/

protocol WeaponProtocol {
    func fire() -> String
}
private class AWP: WeaponProtocol {
    func fire() -> String {
        return "AWP FIRE"
    }
}
private class AUG: WeaponProtocol {
    func fire() -> String {
        return "AUG FIRE"
    }
}
private class AK47: WeaponProtocol {
    func fire() -> String {
        return "AK47 FIRE"
    }
}
public enum WeaponEnumation {
    case AWP, AUG, AK47
}
/// 通过装饰器继承呈现多态 而非各个类直接遵循协议呈现不同实现
class WeaponDecorator: WeaponProtocol {
    var weapon: WeaponProtocol! = nil
    init(weapon: WeaponProtocol) {
        self.weapon = weapon
    }
    func fire() -> String {
        return weapon.fire()
    }
}
///添加德国厂商装饰 通过继承重写呈现多态
class GermanyDecorator: WeaponDecorator {
    override func fire() -> String {
        return "德国造：" + weapon.fire()
    }
}
/// 添加美国厂商装饰
class AmericaDecorator: WeaponDecorator {
    override func fire() -> String {
        return "美国造：" + weapon.fire()
    }
}
////武器用户的接口
protocol WeaponUser {
    func fireWithType(weaponType: WeaponEnumation)
    func createWeaponWithType(weaponType: WeaponEnumation) -> WeaponProtocol!
}
extension WeaponUser {
    func fireWithType(weaponType: WeaponEnumation) {
        let weapon: WeaponProtocol = createWeaponWithType(weaponType: weaponType)
        print(weapon.fire())
    }
}

/// 德国用户：使用德国造
class GermanyWeaponUser: WeaponUser {
    func createWeaponWithType(weaponType: WeaponEnumation) -> WeaponProtocol! {
        var weapon: WeaponProtocol
        switch weaponType {
        case .AK47:
            weapon = GermanyDecorator(weapon: AK47())
        case .AUG:
            weapon = GermanyDecorator(weapon: AUG())
        case .AWP:
            weapon = GermanyDecorator(weapon: AWP())
        }
        return weapon
    }
}
/// 美国用户：使用德国造
class AmericaWeaponUser: WeaponUser {
    func createWeaponWithType(weaponType: WeaponEnumation) -> WeaponProtocol! {
        var weapon: WeaponProtocol
        switch weaponType {
        case .AK47:
            weapon = AmericaDecorator(weapon: AK47())
        case .AUG:
            weapon = AmericaDecorator(weapon: AUG())
        case .AWP:
            weapon = AmericaDecorator(weapon: AWP())
        }
        return weapon
    }
}
var user: WeaponUser = GermanyWeaponUser()
user.fireWithType(weaponType: .AK47)
user = AmericaWeaponUser()
user.fireWithType(weaponType: .AK47)


/***************************************  Abstract FactoryPattern  ********************************************
+ 提供一个接口，用于创建相关或者依赖对象的家族，而不需要明确指向具体类

 ````
 接口协议 WeaponProtocol 都具备的功能fire()                                 接口协议: WeaponFactoryType
 接口实现 AK AWP AUG  遵循协议呈现多态 -----   各类型fire()不同的实现                   func createAK createAWP createAUG() -> WeaponProtocol
 接口装饰  WeaponDecorator 遵循协议       |  倒入到装饰器提取原先的实现         接口实现: AmericanWeaponFactory createAK   -> AmericaDecorator(weapon: AK())
         fire()                        |                                         GermanyWeaponFactory  createAWP  -> GermanyDecprator(weapon: AWP())
    init weapon: WeaponProtocol  <-----   通过继承添加额外的信息
                |                                                       WeaponUser                         |
                | 继承 WeaponDecorator                                   factory:  WeaponFactoryType  ------
 GermanyDecorator: fire() -> 通过子类添加额外信息                           init(factory: WeaponFactoryType) select AK -> factory.createAK
 AmericaDecorator: fire() -> return "美国造：" + weapon.fire()
 
 ````
 */
enum WeaponTypeEnumeration {
    case AK, HK, AWP
}
protocol WeaponType {
    func fire() -> String
}
class AK: WeaponType {
    func fire() -> String {
        return "AK: Fire"
    }
}
class AWP: WeaponType {
    func fire() -> String {
        return "AWP: Fire"
    }
}
class HK: WeaponType {
    func fire() -> String {
        return "HK: Fire"
    }
}
class WeaponDecorator: WeaponType {
    var weapon: WeaponType! = nil
    init(weapon: WeaponType) {
        self.weapon = weapon
    }
    func fire() -> String {
        return weapon.fire()
    }
}
///添加德国厂商装饰
class GermanyDecorator: WeaponDecorator {
    override func fire() -> String {
        return "德国造：" + self.weapon.fire()
    }
}
/// 添加美国厂商装饰
class AmericaDecorator: WeaponDecorator {
    override func fire() -> String {
        return "美国造：" + weapon.fire()
    }
}
/// 创建抽象工厂（工厂接口）
protocol WeaponFactoryType {
    func createAK() -> WeaponType
    func createAWP() -> WeaponType
    func createHK() -> WeaponType
}
/// 美国兵工厂：生产”美国造“系列的武器
class AmericanWeaponFactory: WeaponFactoryType {
    func createAK() -> WeaponType {
        return AmericaDecorator(weapon: AK())
    }
    func createAWP() -> WeaponType {
        return AmericaDecorator(weapon: AWP())
    }
    func createHK() -> WeaponType {
        return AmericaDecorator(weapon: HK())
    }
}
/// 德国兵工厂：生产”德国造“系列的武器
class GermanyWeaponFactory: WeaponFactoryType {
    func createAK() -> WeaponType {
        return GermanyDecorator(weapon: AK())
    }
    func createAWP() -> WeaponType {
        return GermanyDecorator(weapon: AWP())
    }
    func createHK() -> WeaponType {
        return GermanyDecorator(weapon: HK())
    }
}
/// 对用户进行重写
class WeaponUser {
    private var factory: WeaponFactoryType
    init(factory: WeaponFactoryType) {
        self.factory = factory
    }
    func setFactory(factory: WeaponFactoryType) {
        self.factory = factory
    }
    func fireWithType(weaponType: WeaponTypeEnumeration) {
        var weapon: WeaponType
        switch weaponType {
        case .AK:
            weapon = factory.createAK()
        case .AWP:
            weapon = factory.createAWP()
        case .HK:
            weapon = factory.createHK()
        }
        print(weapon.fire())
    }
}
var user: WeaponUser = WeaponUser(factory: AmericanWeaponFactory())
user.fireWithType(.AK)
user.fireWithType(.AWP)
user.fireWithType(.HK)
user.setFactory(GermanyWeaponFactory())
user.fireWithType(.AK)
user.fireWithType(.AWP)
user.fireWithType(.HK)

/***************************************  Abstract Factory Method Pattern  ********************************************
 
 ````
 接口协议 WeaponProtocol 都具备的功能fire()                                 接口协议: WeaponFactoryType
 接口实现 AK AWP AUG  遵循协议呈现多态 -----   各类型fire()不同的实现                   func createAK createAWP createAUG() -> WeaponProtocol
 接口装饰  WeaponDecorator 遵循协议       |  倒入到装饰器提取原先的实现         接口实现: AmericanWeaponFactory createAK   -> AmericaDecorator(weapon: AK())
         fire()                        |                                         GermanyWeaponFactory  createAWP  -> GermanyDecprator(weapon: AWP())
 init weapon: WeaponProtocol  <-----   通过继承添加额外的信息                                                                                        \
            |                                                                                                                                    /
            | 继承 WeaponDecorator                                       接口协议: WeaponUserType                                                  |
 GermanyDecorator: fire() -> 通过子类添加额外信息                                    fireWithType(枚举)                                              /
 AmericaDecorator: fire() -> return "美国造：" + weapon.fire()                     createWeapon(枚举) -> WeaponProtocol                           |
                                                                                  createWeaponFactory -> WeaponFactoryType ---------------------
                                                                        接口实现:  AmericanUser createWeaponFactory -> return AmericanWeaponFactory()
                                                                                  GermanyUser  createWeaponFactory -> return GermanyWeaponFactory()
 ````
 */
enum WeaponTypeEnumeration {
    case AK, HK, AWP
}
protocol WeaponType {
    func fire() -> String
}
class AK: WeaponType {
    func fire() -> String {
        return "AK: Fire"
    }
}
class AWP: WeaponType {
    func fire() -> String {
        return "AWP: Fire"
    }
}
class HK: WeaponType {
    func fire() -> String {
        return "HK: Fire"
    }
}
class WeaponDecorator: WeaponType {
    var weapon: WeaponType! = nil
    init(weapon: WeaponType) {
        self.weapon = weapon
    }
    func fire() -> String {
        return weapon.fire()
    }
    
}
///添加德国厂商装饰
class GermanyDecorator: WeaponDecorator {
    override func fire() -> String {
        return "德国造：" + self.weapon.fire()
    }
}
/// 添加美国厂商装饰
class AmericaDecorator: WeaponDecorator {
    override func fire() -> String {
        return "美国造：" + weapon.fire()
    }
}
/// 创建抽象工厂（工厂接口）
protocol WeaponFactoryType {
    func createAK() -> WeaponType
    func createAWP() -> WeaponType
    func createHK() -> WeaponType
}
/// 美国兵工厂：生产”美国造“系列的武器
class AmericanWeaponFactory: WeaponFactoryType {
    func createAK() -> WeaponType {
        return AmericaDecorator(weapon: AK())
    }
    func createAWP() -> WeaponType {
        return AmericaDecorator(weapon: AWP())
    }
    func createHK() -> WeaponType {
        return AmericaDecorator(weapon: HK())
    }
}
/// 德国兵工厂：生产”德国造“系列的武器
class GermanyWeaponFactory: WeaponFactoryType {
    func createAK() -> WeaponType {
        return GermanyDecorator(weapon: AK())
    }
    func createAWP() -> WeaponType {
        return GermanyDecorator(weapon: AWP())
    }
    func createHK() -> WeaponType {
        return GermanyDecorator(weapon: HK())
    }
}


/// 抽象工厂 + 工厂方法， 使用工厂方法模式重写WeaponUser类的结构
protocol WeaponUserType {
    func fireWithType(weaponType: WeaponTypeEnumeration)
    func createWeaponWithType(weaponType: WeaponTypeEnumeration) -> WeaponType!
    //工厂方法
    func createWeaponFactory() -> WeaponFactoryType
    
}
// MARK: - 为fireWithType方法添加默认实现
extension WeaponUserType {
    func fireWithType(weaponType: WeaponTypeEnumeration) {
        let weapon: WeaponType = createWeaponWithType(weaponType)
        print(weapon.fire())
    }
    func createWeaponWithType(weaponType: WeaponTypeEnumeration) -> WeaponType! {
        var weapon: WeaponType
        switch weaponType {
        case .AK:
            weapon = createWeaponFactory().createAK()
        case .AWP:
            weapon = createWeaponFactory().createAWP()
        case .HK:
            weapon = createWeaponFactory().createHK()
        }
        return weapon
    }
    
}

class AmericanWeaponUser: WeaponUserType {
    func createWeaponFactory() -> WeaponFactoryType {
        return AmericanWeaponFactory()
    }
}
class GermanyWeaponUser: WeaponUserType {
    func createWeaponFactory() -> WeaponFactoryType {
        return GermanyWeaponFactory()
    }
}
var  user: WeaponUserType = AmericanWeaponUser()
user.fireWithType(.AK)
user.fireWithType(.AWP)
user.fireWithType(.HK)

user = GermanyWeaponUser()
user.fireWithType(.AK)
user.fireWithType(.AWP)
user.fireWithType(.HK)
