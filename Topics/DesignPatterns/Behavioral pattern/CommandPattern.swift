struct Light {
    func on() {
        print("LIGHT ON")
    }
    func off() {
        print("LIGHT OFF")
    }
}
struct Computer {
    func start() {
        print("COMPUTER START")
    }
    func load() {
        print("COMPUTER LOAD")
    }
    func off() {
        print("COMPUTER OFF")
    }
}
protocol CommandProtocol {
    func execute()
}
/// 将一个请求封装成一个对象，从而使您可以用不同的请求对客户进行参数化。
struct LightOnCommand: CommandProtocol {
    private let light = Light()
    func execute() {
        light.on()
    }
}
struct LightOffCommand: CommandProtocol {
    private let light = Light()
    func execute() {
        light.off()
    }
}
struct ComputerStartCommand: CommandProtocol {
    private let computer = Computer()
    func execute() {
        computer.start()
        computer.load()
    }
}
struct Console {
    private var command: CommandProtocol?
    mutating func setCommand(_ command: CommandProtocol) {
        self.command = command
    }
    func action() {
        command?.execute()
    }
}
var console = Console()
console.setCommand(LightOnCommand())        // 将请求分装成不同的对象 通过console调用形成记录 可撤销 可恢复
console.action()

console.setCommand(LightOffCommand())
console.action()

console.setCommand(ComputerStartCommand())
console.action()
