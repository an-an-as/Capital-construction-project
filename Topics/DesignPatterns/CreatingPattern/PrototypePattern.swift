class Menu {
    var food: String
    var drink: String?
    init(food: String) {
        self.food = food
    }
    func clone() -> Menu {
        return Menu(food: self.food)
    }
}
let menu = Menu(food: "🍔")
menu.drink = "🥛"
print(menu.drink, menu.food)
let newMenu = menu.clone()
print(newMenu.drink, newMenu.food)
