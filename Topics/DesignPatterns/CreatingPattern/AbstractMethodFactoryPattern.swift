internal protocol WeaponProtocol {
    func fire() -> String
}
private struct WeaponA: WeaponProtocol {
    func fire() -> String {
        return "WeaponA Fire"
    }
}
private struct WeaponB: WeaponProtocol {
    func fire() -> String {
        return "WeaponB Fire"
    }
}
public enum WeaponEnumation {
    case weaponA, weaponB
}
private class WeaponDecorator: WeaponProtocol {
    var weapon: WeaponProtocol
    init(weapon: WeaponProtocol) {
        self.weapon = weapon
    }
    func fire() -> String {
        return weapon.fire()
    }
}
private class NormalAttackDecorator: WeaponDecorator {
    override func fire() -> String {
        return "Normal Attack! ---- \(weapon.fire())"
    }
}
private class ChemicalAttackDecorator: WeaponDecorator {
    override func fire() -> String {
        return "Chemical Attack! ---- \(weapon.fire())"
    }
}
// MARK: - FACTORY PROTOCPL
internal protocol FactoryProtocol {
    func createWeaponA() -> WeaponProtocol
    func createWeaponB() -> WeaponProtocol
}
private struct NomalAttackWeaponProcessingPlant: FactoryProtocol {
    func createWeaponA() -> WeaponProtocol {
        return NormalAttackDecorator(weapon: WeaponA())
    }
    func createWeaponB() -> WeaponProtocol {
        return NormalAttackDecorator(weapon: WeaponB())
    }
}
private struct ChemicalAttackWeaponProcessingPlant: FactoryProtocol {
    func createWeaponA() -> WeaponProtocol {
        return ChemicalAttackDecorator(weapon: WeaponA())
    }
    func createWeaponB() -> WeaponProtocol {
        return ChemicalAttackDecorator(weapon: WeaponB())
    }
}
// MARK: - USER PROTOCOL
internal protocol UserProtocol {
    func selectWeapon(_ select: WeaponEnumation)
    func addAttackKind(_ selected: WeaponEnumation) -> WeaponProtocol
    func processingWeapon() -> FactoryProtocol
}
extension UserProtocol {
    func selectWeapon(_ select: WeaponEnumation) {
        let weapon = addAttackKind(select)
        print(weapon.fire())
    }
    func addAttackKind(_ selected: WeaponEnumation) -> WeaponProtocol {
        var weapon: WeaponProtocol
        switch selected {
        case .weaponA:
            weapon = processingWeapon().createWeaponA()
        case .weaponB:
            weapon = processingWeapon().createWeaponB()
        }
        return weapon
    }
}
public struct NormalUser: UserProtocol {
    func  processingWeapon() -> FactoryProtocol {
        return NomalAttackWeaponProcessingPlant()
    }
}
public struct ChemicalUser: UserProtocol {
    func processingWeapon() -> FactoryProtocol {
        return ChemicalAttackWeaponProcessingPlant()
    }
}
var user: UserProtocol = NormalUser()
user.selectWeapon(.weaponA)
user = ChemicalUser()
user.selectWeapon(.weaponB)

///- Version: 2
protocol WeaponProtocol {
    func fire() -> String
}
struct WeaponA: WeaponProtocol {
    func fire() -> String {
        return "💥💥💥"
    }
}
struct WeaponB: WeaponProtocol {
    func fire() -> String {
        return "❄️❄️❄️"
    }
}
/// 倒入一个Weapon 通过继承对Weapon方法重写 最终一个Weapon有两种方法
class Attack: WeaponProtocol {
    var weapon: WeaponProtocol
    init(use weapon: WeaponProtocol) {
        self.weapon = weapon
    }
    func fire() -> String {
        return weapon.fire()
    }
}
class ChemicalAttack: Attack {
    override func fire() -> String {
        return "🧪🧪🧪" + "\(weapon.fire())"
    }
}
/// 展开多态分别构建
protocol AttackMode {
    func normal() -> WeaponProtocol
    func chemical() -> WeaponProtocol
}
struct WeaponAAttackMode: AttackMode {
    func normal() -> WeaponProtocol {
        return Attack(use: WeaponA())
    }
    func chemical() -> WeaponProtocol {
        return ChemicalAttack(use: WeaponA())
    }
}
struct WeaponBAttackMode: AttackMode {
    func normal() -> WeaponProtocol {
        return Attack(use: WeaponB())
    }
    func chemical() -> WeaponProtocol {
        return ChemicalAttack(use: WeaponB())
    }
}
enum AttackModeEnumation {
    case noraml
    case chemical
}
enum WeaponEnumation {
    case weaponA
    case weaponB
}
protocol UserProtocol {}
extension UserProtocol {
    func attack(use selected: WeaponEnumation = .weaponA, mode: AttackModeEnumation = .noraml) {
        var weapon: WeaponProtocol
        var attackMode: AttackMode
        switch selected  {
        case .weaponA: attackMode = WeaponAAttackMode()
        case .weaponB: attackMode = WeaponBAttackMode()
        }
        switch mode {
        case .noraml: weapon = attackMode.normal()
        case .chemical: weapon = attackMode.chemical()
        }
        print(weapon.fire())
    }
}
struct WeaponUser: UserProtocol {}
let user = WeaponUser()
user.attack()
user.attack(use: .weaponA, mode: .chemical)
user.attack(use: .weaponB, mode: .noraml)
user.attack(use: .weaponB, mode: .chemical)
