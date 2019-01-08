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
internal protocol UserProtocol {
    func selectWeaponAndFire(_ select: WeaponEnumation)
    func addAttackKind(_ selected: WeaponEnumation) -> WeaponProtocol
}
extension UserProtocol {
    func selectWeaponAndFire(_ select: WeaponEnumation) {
        let specialWeapon = addAttackKind(select)
        print(specialWeapon.fire())
    }
}
internal class NormalWeaponUser: UserProtocol {
    func addAttackKind(_ selected: WeaponEnumation) -> WeaponProtocol {
        let specialWeapon: WeaponProtocol
        switch selected {
        case.weaponA:
            specialWeapon = NormalAttackDecorator(weapon: WeaponA())
        case .weaponB:
            specialWeapon = NormalAttackDecorator(weapon: WeaponB())
        }
        return specialWeapon
    }
}
internal class ChemicalWeaponUser: UserProtocol {
    func addAttackKind(_ selected: WeaponEnumation) -> WeaponProtocol {
        var specialWeapon: WeaponProtocol
        switch selected {
        case .weaponA:
            specialWeapon = ChemicalAttackDecorator(weapon: WeaponA())
        case .weaponB:
            specialWeapon = ChemicalAttackDecorator(weapon: WeaponB())
        }
        return specialWeapon
    }
}
let normalUser = NormalWeaponUser()
normalUser.selectWeaponAndFire(.weaponA)
let chemicalUser = ChemicalWeaponUser()
chemicalUser.selectWeaponAndFire(.weaponB)
