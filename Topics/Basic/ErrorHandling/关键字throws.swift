// version1
enum Result<T> {
    case success(T)
    case failure(Error)
}
enum CarError: Error {
    case outOfFuel
}
struct Car {
    var fuelInLitre: Double
    func start() -> Result<String> {
        guard fuelInLitre > 5 else {
            return .failure(CarError.outOfFuel)
        }
        return .success("Ready to go")
    }
}
let vw = Car(fuelInLitre: 6)
switch vw.start() {
case let .success(message): print(message)
case let .failure(error):
    if let carError = error as? CarError, carError == .outOfFuel {
        print("Cannot start due to out of fuel")
    } else {
        print(error.localizedDescription)
    }
}

// version 2
enum CarError: Error {
    case outOfFuel(currentFuel: Int)
}
struct Car {
    var fuelInLitre: Int
    func start() throws -> String {
        guard fuelInLitre > 5 else {
            throw CarError.outOfFuel(currentFuel: fuelInLitre)
        }
        return "Ready to go"
    }
}
let vw = Car(fuelInLitre: 2)
do {
    let message = try vw.start()
    print(message)
} catch CarError.outOfFuel(let currentFuel) {
    print("Cannot start due to out of fuel \(currentFuel)")
} catch {
    print("We have something wrong")
}
