private protocol WeaponProtocol {
    func fire()
}
private class WeaponA: WeaponProtocol {
    func fire() {
        print("weapoinA fire !")
    }
}
private class WeaponB: WeaponProtocol {
    func fire() {
        print("weapoinB fire !")
    }
}
private class WeaponC: WeaponProtocol {
    func fire() {
        print("weapoinC fire !")
    }
}
public enum WeaponEnumation {
    case weaponA, weaponB, weaponC
}
private struct WeaponFactory {
    func createWeapon(_  select: WeaponEnumation) -> WeaponProtocol {
        switch select {
        case .weaponA:
            return WeaponA()
        case .weaponB:
            return WeaponB()
        case .weaponC:
            return WeaponC()
        }
    }
}
public struct User {
    private let factory = WeaponFactory()
    func selectWeaponAndFire(_ userSelected: WeaponEnumation) {
        let selectedWeapon = factory.createWeapon(userSelected)
        print(selectedWeapon.fire())
    }
}
let user1 = User()
user1.selectWeaponAndFire(.weaponA)
