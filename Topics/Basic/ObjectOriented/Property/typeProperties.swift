struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

print(SomeStructure.storedTypeProperty)
SomeStructure.storedTypeProperty = "Another value."

print(SomeStructure.storedTypeProperty)
print(SomeEnumeration.computedTypeProperty)
print(SomeClass.computedTypeProperty)


/***********************************************************************/
 struct AudioChannel {
 static let thresholdLevel = 10
 static var maxInputLevelForAllChannels = 0
 var currentLevel: Int = 0 {
 didSet {
 if currentLevel > AudioChannel.thresholdLevel {
 currentLevel = AudioChannel.thresholdLevel
 }
 if currentLevel > AudioChannel.maxInputLevelForAllChannels {
 AudioChannel.maxInputLevelForAllChannels = currentLevel
 }
 }
 }
 }
 
 var leftChannel = AudioChannel()
 var rightChannel = AudioChannel()
 
 leftChannel.currentLevel = 7
 print(leftChannel.currentLevel) // 7
 print(AudioChannel.maxInputLevelForAllChannels)// 7
 
 rightChannel.currentLevel = 11
 print(rightChannel.currentLevel)// 10
 print(AudioChannel.maxInputLevelForAllChannels)// 10
