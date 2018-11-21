protocol ComputerPowerSourceType {
    func outputVoltage() -> Float
}
protocol SocketType {
    func socketOutputVoltage() -> Float
}
class Socket: SocketType {
    func socketOutputVoltage() -> Float {
        return 220.0
    }
}
class MacBookProBattery: ComputerPowerSourceType {
    func outputVoltage() -> Float {
        return 16.5
    }
}
class MacBookPro {
    private var powerSource: ComputerPowerSourceType?
    func connectPowerSource(powerSource: ComputerPowerSourceType) {
        self.powerSource = powerSource
    }
    func inputVoltage() {
        if powerSource != nil {
            print("输入电压为：\(powerSource!.outputVoltage())")
        }
    }
}
/// MacBookPro需要PowerSource  Socket对象通过MacPowerObjectAdapter转换后构成PowerSource
class MacPowerObjectAdapter: ComputerPowerSourceType {
    var socketPower: SocketType?
    /// 导入Socket
    func insertSocket(socketPower: SocketType) {
        self.socketPower = socketPower
    }
    /// 电流通过适配器后进行转换输出，输出规则要遵循ComputerPowerSourceType协议
    func outputVoltage() -> Float {
        guard let  voltage = socketPower?.socketOutputVoltage() else {
            return 0
        }
        if voltage > 16.5 {
            return 16.5
        } else {
            return 0
        }
    }
}

///类适配器：继承自某个特定插座并实现计算机电源协议
class MacPowerClassAdapter: Socket, ComputerPowerSourceType {
    func outputVoltage() -> Float {               // 电源协议
        if self.socketOutputVoltage() > 16.5 {    // socket协议
            return 16.5
        } else {
            return 0
        }
    }
}
let macBookPro: MacBookPro = MacBookPro()       //创建笔记本对象
let macBookProBattery = MacBookProBattery()     //创建MacBookPro所用电池的对象
let socket: SocketType = Socket()               //创建电源对象

//创建适配器“对象适配器”的对象
let macBookProObjectAdapter: MacPowerObjectAdapter = MacPowerObjectAdapter()

//创建“类适配器”对象
let macBookProClassAdapter: MacPowerClassAdapter = MacPowerClassAdapter()

print("笔记本使用电池")
macBookPro.connectPowerSource(powerSource: macBookProBattery)
macBookPro.inputVoltage()

print("\n电池没电了，使用对象适配器")
macBookProObjectAdapter.insertSocket(socketPower: socket)              //1.适配器插入插座
macBookPro.connectPowerSource(powerSource: macBookProObjectAdapter)    //2.MacBookPro连接适配器
macBookPro.inputVoltage()                                              //3.电流输出

print("\n使用类适配器")
macBookPro.connectPowerSource(powerSource: macBookProClassAdapter)
macBookPro.inputVoltage()
