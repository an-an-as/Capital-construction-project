internal protocol WeaponProtocol {
    func fire()
}
private struct WeaponA: WeaponProtocol {
    func fire() {
        print("WeaponA fired !")
    }
}
private struct WeaponB: WeaponProtocol {
    func fire() {
        print("WeaponB fired !")
    }
}
private struct WeaponC: WeaponProtocol {
    func fire() {
        print("WeaponC fired !")
    }
}
public enum WeaponEnumation {
    case weaponA, weaponB, weaponC
}
public struct User {
    func selectWeaponAndFire(_ selected: WeaponEnumation) {
        var weapon: WeaponProtocol
        switch selected {
        case .weaponA:
            weapon = WeaponA()
        case .weaponB:
            weapon = WeaponB()
        case .weaponC:
            weapon = WeaponC()
        }
        print(weapon.fire())
    }
}
