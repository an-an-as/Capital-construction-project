/**
现在要为某些鸭子添加上飞的方法，该如何去做呢？ 一些假的鸭子是不能飞的
1、在基类中添加fly()，在不会飞的鸭子中重新fly， 但是这样的话，子类中会有些无用的方法
2.使用接口，需要实现fly()的鸭子，实现接口即可，但是会产生重复的带。
*/

//解决方案1: 使用Swift中的协议延展来做
protocol Flyable {
    func fly()
}
extension Flyable {
    func fly() {
        print("我是会飞的鸭子，我用翅膀飞")
    }
}
class Duck {
    func swim() {
        print("鸭子游泳喽~")
    }
    func quack() {
        print("鸭子呱呱叫")
    }
    func display(){
    }
}
//为绿头鸭子实现会飞的功能
class MallarDuck: Duck, Flyable {
    override func display() {
        print("我是绿头鸭子")
    }
}
class RedHeadDuck: Duck, Flyable {
    override func display() {
        print("我是红头鸭子")
    }
}
class RubberDuck: Duck {
    override func display() {
        print("橡皮鸭")
    }
}
let mallarDuck = MallarDuck()
mallarDuck.fly()


//解决方案二：使用多态，行为代理--------策略模式（Strategy Pattern）--------------
//设计原则1：找出应用中可能需要变化之处，把它们独立出来，不要和那些不变的代码混在一起。
//设计原则2：针对接口编程，而不是针对实现编程
//设计原则3：多用组合，少用继承


//飞的行为协议
protocol Flyable {
    func fly();
}

//使用翅膀飞的类 存在各类鸭子 而区分他们的只是会飞和不会飞的行为
class FlyWithWings: Flyable {
    func fly() {
        print("我是会飞的鸭子, 我用翅膀飞呀飞")
    }
}
//什么都不会飞
class FlyNoWay: Flyable {
    func fly() {
        print("我是不会飞的鸭子")
    }
}

class Duck {
    //添加行为委托代理者
    var flyBehavior: Flyable?
    func setFlyBehavior(flyBehavior: Flyable) {
        self.flyBehavior = flyBehavior
    }
    func swim() {
        print("鸭子游泳喽~")
    }
    func quack() {
        print("鸭子呱呱叫")
    }
    func display(){
    }
    //执行飞的行为
    func performFly() {
        guard (self.flyBehavior != nil) else { return }
        self.flyBehavior.fly()
    }
}
//为绿头鸭子实现会飞的功能
class MallarDuck: Duck {
    override init() {
        super.init()
        self.setFlyBehavior(FlyWithWings())
    }
    override func display() {
        print("我是绿头鸭子")
    }
}
class RedHeadDuck: Duck {
    override init() {
        super.init()
        self.setFlyBehavior(FlyWithWings())
    }
    override func display() {
        print("我是红头鸭子")
    }
}

class RubberDuck: Duck {
    override init() {
        super.init()
        self.setFlyBehavior(FlyNoWay())
    }
    override func display() {
        print("橡皮鸭")
    }
}

var duck: Duck = MallarDuck()
duck.performFly()

duck.setFlyBehavior(FlyNoWay())
duck.performFly()



//现在需求又来了，要创建一个模型的鸭子，并且该鸭子会飞
//在上面的基础上进行扩充是非常简单的
class ModelDuck: Duck {
    override init() {
        super.init()
        self.setFlyBehavior(FlyWithWings())
    }

    override func display() {
        print("鸭子模型")
    }
}

duck = ModelDuck()
duck.performFly()



//需求又来了，要给模型的鸭子装发动机，支持他飞，好，扩充就比较简单了
//为鸭子创建新的动力系统
class FlyAutomaticPower: Flyable {
    func fly() {
        print("我是用发动机飞的鸭子")
    }
}
//指定新的动力系统
duck.setFlyBehavior(FlyAutomaticPower())
duck.performFly()


/*
策略模式：
定义了算法族（就是上面鸭子的各种飞行行为），分别封装了起来，让他们之间可以相互替换，此模式让算法的变化独立于使用算法的客户
*/


//实现角色可以使用的不同的攻击行为，也就是不同的攻击策略
//武器策略
protocol WeaponBehavior {
    func useWeapon();
}
class AWPBehavior: WeaponBehavior {
    func useWeapon() {
        print("大狙---biu~biu~")
    }
}
class HK48Behavior: WeaponBehavior {
    func useWeapon() {
        print("HK48---tu~tu~tu~")
    }
}
class PistolBehavior: WeaponBehavior {
    func useWeapon() {
        print("手枪--pa~pa~pa~")
    }
}

//上面定义了一系列的武器策略
//下面是用户=================
class Character {
    //默认是配备的是手枪
    private var weapon: WeaponBehavior! = PistolBehavior()
    
    func setWeapon(weapon: WeaponBehavior) {
        self.weapon = weapon
    }
    
    //换手枪
    func changePistol() {
        self.setWeapon(PistolBehavior());
    }
    
    func fire() {
        guard self.weapon != nil else {
            return
        }
        self.weapon.useWeapon()
    }
}

//中尉只配备了手枪和HK48
class Lieutenant: Character {
    
    override init() {
        super.init();
    }
    
    //切换武器（策略）：换HK
    func changeHK() {
        self.setWeapon(HK48Behavior());
    }
}

//上尉尉只配备了手枪和大狙
class Captain: Character {
    
    override init() {
        super.init();
    }
    //切换武器（策略）：换大狙
    func changeAWP() {
        self.setWeapon(AWPBehavior());
    }
}

//中尉
let lieutenant: Lieutenant = Lieutenant()
lieutenant.fire()

print("\n手枪火力不行，得换HK48\n")

lieutenant.changeHK()
lieutenant.fire()
