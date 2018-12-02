enum VendingMachineError: Error {
    case insufficentFunds(price: Int)
    case invalidSelection
}
struct Item {
    var price: Int
}
class VendingMachine {
    let inventory = ["Candy Bar": Item(price: 10)]
    var coinsDeposit = 0
    func vend(name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        guard coinsDeposit >= item.price else {
            throw VendingMachineError.insufficentFunds(price: item.price - coinsDeposit)
        }
    }
}
var vendingMaching = VendingMachine()
vendingMaching.coinsDeposit = 8
do {
    try vendingMaching.vend(name: "Candy Bar")
    print("Success")
} catch VendingMachineError.invalidSelection {
    print("invalidSelection")
} catch VendingMachineError.insufficentFunds(let price) {
    print("insufficentFunds Please insert additional \(price) coins" )
}
