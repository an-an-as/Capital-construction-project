enum MenuEnumation {
    case menuA
    case menuB
}
class MenuBuilder {
    var drink: String?
    var food: String?
    init(build: (MenuBuilder) -> Void) {
        build(self)
    }
}
class Menu {
    var drink: String
    var food: String
    init?(builder: MenuBuilder) {
        if let drink = builder.drink, let food = builder.food {
            self.drink = drink
            self.food = food
        } else {
            return nil
        }
    }
    convenience init?(select menu: MenuEnumation = .menuA) {
        var builder: MenuBuilder
        switch menu {
        case .menuA:
            builder = MenuBuilder {
                $0.food = "🍗"
                $0.drink = "🥛"
            }
        case .menuB:
            builder = MenuBuilder {
                $0.food = "🍔"
                $0.drink = "🍷"
            }
        }
        self.init(builder: builder)
    }
}
extension Menu: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(drink)\(food)"
    }
}
let menuA = Menu()
let menuB = Menu(select: .menuB)
let build = MenuBuilder {
    $0.drink = "🍹🍹"
    $0.food = "🍕🍕"
}
let custom = Menu(builder: build)
print(menuA, menuB, custom)
