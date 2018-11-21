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
public enum AttackKindEnumation {
    case normal, chemical
}
public struct User {
    var plant: FactoryProtocol
    init(select attackKind: AttackKindEnumation) {
        switch attackKind {
        case .normal:
            plant = NomalAttackWeaponProcessingPlant()
        case .chemical:
            plant = ChemicalAttackWeaponProcessingPlant()
        }
    }
    mutating func resetAttackKind(_ attackKind: AttackKindEnumation) {
        switch attackKind {
        case .normal:
            plant = NomalAttackWeaponProcessingPlant()
        case .chemical:
            plant = ChemicalAttackWeaponProcessingPlant()
        }
    }
    func fire(_ selectWeapon: WeaponEnumation) {
        var weapon: WeaponProtocol
        switch selectWeapon {
        case .weaponA:
            weapon = plant.createWeaponA()
        case . weaponB:
            weapon = plant.createWeaponB()
        }
        print(weapon.fire())
    }
}
var user = User(select: .chemical)
user.fire(.weaponA)
user.resetAttackKind(.normal)
user.fire(.weaponB)
