#### 模块
* Swift 中的访问控制是基于模块和源文件这两个概念
* 模块: 独立的代码单元(框架或应用程序会作为一个独立的模块来构建和发布).在 Swift 中，一个模块可以使用 import 关键字导入另外一个模块。
* 源文件: Swift 中的源代码文件，它通常属于一个模块,同一个源文件也可以包含多个类型、函数之类的定义

---
#### 命名空间
>Swift 的命名空间是基于 module 而不是在代码中显式地指明，每个 module 代表了 Swift 中的一个命名空间。也就是说，同一个 target 里的类型名称还是不能相同的。
![009efd2d8a4637a53094f0858da54807.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1336)

**修改命名空间**
build settings ---> product name 
新改的名字不能含有`中文`,不能以`数字`开头,不能有`-`

**动态加载命名空间**
> 由于命名空间可以修改,所以项目中单纯的用项目名称代替命名空间的做法并不可靠. 为了满足项目中某些需求,比如:活动期间需要显示与平时完全不同风格的界面,活动结束后又要修改回来,我们不可能在短期连发两个版本,这个就需要跟后台就行互动,将类名提前预留在后台,程序里面使用动态加载类来实现
![d98bac4c42c9787aee9befcf9dfeacce.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1323)h=200
```swift
// 从info.plist读取namespace
let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
// 拼接类名的完整格式,即namespace.类名,vcName即控制器的类名
let clsName = namespace + "." + vcName
let cls: AnyClass = NSClassFromString(clsName)!
// 得到相应的控制器
let vc = cls.alloc() as! UITableViewController
```

**桥接**
![eb461edd9d5e827be3727018667105ab.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1325)

---
#### 静态库 (Static Library)
**存在形式:**
+ 静态库：.a 
+ 动态库：.dylib 和 .framework (ios9 取消 .dylib 改用`.tbd`  text-based stub libraries)

**静态库:**
1. 程序运行一般需经预处理、编译、汇编和链接几个步骤(链接是一个过程,该过程通过各模块间传递的参数和控制命令、使其组成一个可执行的整体)
2. 静态库在程序的链接阶段被复制到了程序中、使其包含了库代码的一份完整拷贝，多次使用就会有多份冗余拷贝。
3. 通常配合上公共的 .h 文件，我们可以获取到 .a 中暴露的方法或者成员等。
4. 在最后编译 app 的时候.a 将被链接到最终的可执行文件中，之后每次都随着app的可执行二进制文件一同加载，你不能控制加载的方式和时机，所以称为静态库。
5. 在 iOS 8 之前，iOS 只支持以静态库的方式来使用第三方的代码。iOS早起开发被手动引用和.a文件所支配.
6. iOS 8 之前也有一些第三方库提供 .framework 文件，但是它们实质上都是静态库，只不过通过一些方法进行了包装，相比传统的 .a 要好用一些。


----
#### 动态框架 (Dynamic Framework)
**存在形式:**
+ 静态库：.a 
+ 动态库：.dylib 和 .framework (ios9 取消 .dylib 改用`.tbd`  text-based stub libraries)

**动态库**
1. 链接时不复制，程序运行时由系统动态加载到内存供程序调用，系统只加载一次，多个程序共用，以节省内存(不能上传AppStore)
2. Framework 其实是一个 bundle，或者说是一个特殊的文件夹。系统的 framework 是存在于系统内部，而不会打包进 app 中。
3. app 的启动的时候会检查所需要的动态框架是否已经加载。像 UIKit 之类的常用系统框架一般已经在内存中，就不需要再次加载，这可以保证 app 启动速度。
4. 相比静态库，framework 是自包含的，你不需要关心头文件位置等，使用起来很方便。

----
#### Library v.s. Framework
**区别:**
1. 静态库不能包含像 xib 文件，图片这样的资源文件，其他开发者必须将它们复制到 app 的 main bundle 中才能使用，维护和更新非常困难；而 framework 则可以将资源文件包含在自己的 bundle 中。
2. 静态库必须打包到二进制文件中，这在以前的 iOS 开发中不是很大的问题。但是随着 iOS 扩展（比如通知中心扩展或者 Action 扩展）开发的出现，你现在可能需要将同一个 .a 包含在 app 本体以及扩展的二进制文件中，这是不必要的重复。
3. 静态库只能随应用 binary 一起加载，而动态框架加载到内存后就不需要再次加载，二次启动速度加快。另外，使用时也可以控制加载时机。

**转换:**
动态库提交AppStore需要改为静态库
![b6a3503ddcc917f9f38d7fc377586f51.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1335)

----
#### Cocoa Touch Framework
> 以前 Apple 不允许第三方框架使用动态方式，而只有系统框架可以通过动态方式加载。Apple 从 iOS 8 开始允许开发者有条件地创建和使用动态框架，这种框架叫做 Cocoa Touch Framework。

**区别:**
虽然同样是动态框架，但是和系统 framework 不同，app 中的使用的 Cocoa Touch Framework 在打包和提交 app 时会被放到 app bundle 中，运行在沙盒里，而不是系统中。也就是说，不同的 app 就算使用了同样的 framework，但还是会有多份的框架被分别签名，打包和加载。

**目的:**
Cocoa Touch Framework 的推出主要是为了解决两个问题：
+ 首先是应对刚才提到的从 iOS 8 开始的扩展开发。
+ 其次是因为 Swift，在 Swift 开源之前，它是不支持编译为静态库的。虽然在开源后有编译为静态库的可能性，但是因为 Binary Interface 未确定，现在也还无法实用.现在，Swift runtime 不在系统中，而是打包在各个 app 里的。所以如果要使用 Swift 静态框架，由于 ABI 不兼容，所以我们将不得不在静态包中再包含一次 runtime，可能导致同一个 app 包中包括多个版本的运行时，暂时是不可取的。


----
#### 依赖管理
**CocoaPods**
CocoaPods 是一个已经有五年历史的 ruby 程序，可以帮助获取和管理依赖框架,简化使用流程。从 0.36.0 开始，可以通过在 Podfile 中添加 use_frameworks! 来编译 CocoaTouch Framework，也就是动态框架。use_frameworks! 会把项目的依赖全部改为 framework。也就是说这是一个 none or all 的更改。你无法指定某几个框架编译为动态，某几个编译为静态。

**原理:**
>CocoaPods 的主要原理是框架的提供者通过编写合适的 `PodSpec` 文件来提供框架的基本信息，包括仓库地址，需要编译的文件，依赖等 用户使用 `Podfile` 文件指定想要使用的框架，CocoaPods 会创建一个新的工程来管理这些框架和它们的依赖，并把所有这些框架编译到成一个静态的 libPod.a。然后新建一个 workspace 包含你原来的项目和这个新的框架项目，最后在原来的项目中使用这个 libPods.a ,这是一种“侵入式”的集成方式，它会修改你的项目配置和结构。

**使用**
使用 CocoaPods 很简单，用 Podfile 来描述你需要使用和依赖哪些框架，然后执行 pod install 就可以了。下面是一个典型的 Podfile 的结构。
``` Swift
# Podfile
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
pod 'AFNetworking', '~> 2.6'
pod 'ORStackView', '~> 3.0'
pod 'SwiftyJSON', '~> 2.3'
end


$ pod install
```

**Carthage**
它是在 Cocoa Touch Framework 和 Swift 发布后出现的专门针对 Framework 进行的包管理工具。
> **特点:**
> Carthage *只支持动态框架*，它仅负责将项目 clone 到本地并将对应的 Cocoa Framework target 进行构建。之后你需要自行将构建好的 framework 添加到项目中。和 CocoaPods 需要提交和维护框架信息不同，Carthage 是去中心化的 它直接从 git 仓库获取项目，而不需要依靠 podspec 类似的文件来管理。

```swift
# Cartfile
github "ReactiveCocoa/ReactiveCocoa"
github "onevcat/Kingfisher" ~> 1.8
github "https://enterprise.local/hello/repo.git"

$ carthage update --platform ios
```
在使用 Framework 的时候，我们需要将用到的框架 Embedded Binary 的方式链接到希望的 App target 中。添加运行脚本
![16787ed10aac1d8a66fe55eecb8211c0.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1345)

**Swift Package Manager**
Package Manager 实际上做的事情和 Carthage 相似，不过是通过 llbuild （low level build system）的跨平台编译工具将 Swift 编译为 .a 静态库。

----
#### 创建框架
> app 开发所得到产品直接面向最终用户；而框架开发得到的是一个中间产品，它面向的是其他开发者。对于一款 app，我们更注重使用各种手段来保证用户体验，最终目的是解决用户使用的问题。而框架的侧重点与 app 稍有不同，像是集成上的便利程度，使用上是否方便，升级的兼容等都需要考虑。虽然框架的开发和 app 的开发有不少不同，但是也有不少共通的规则和需要遵循的思维方式。
![1eb6d0db36304352fad843cf442860db.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1288)@w=800


#### 支持Pod和Carthage
**创建.spec文件**
```shell
pod spec create TEST
// TEST名字会重名应避免
```

**配置spec**
```
Pod::Spec.new do |s|
s.name = 'TEST'
s.version = '0.0.1'
s.license = 'MIT'
s.summary = 'xxxxx'
s.homepage = 'https://github.com/xxxx/xxxxx'
s.social_media_url = 'http://twitter.com/xxxxxx'
s.authors = { 'xxxxxx' => 'xxxxxx@xxxx' }
s.source = { :git => 'https://github.com/xxxxxx/xxxxx.git', :tag => s.version }
s.documentation_url = 'https://xxxxxx.github.io/xxxxx/'

s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.10'
s.tvos.deployment_target = '9.0'
s.watchos.deployment_target = '2.0'

s.source_files = 'Source/*.swift'
end
```
s.source_files = 'Source/*.swift' 目录下必须有.swift文件

**.swift-version**
建立版本文件: touch .swift-version
查看swift版本号: xcrun swift -version
写入swift版本号

**验证推送到仓库**
```sehll
pod lib lint
```
把验证成功的.podspec文件和.swift-version（如果是 swift 项目要有这个）以及资源文件等commit并push到GitHub

**推送标签**
git tag 0.0.1   // 和spec配置文件一致
git push --tags

**推送到Cocoapods官方库**
```shell
pod trunk push TEST.podspec
```
如果搜索不到,进入目录 ~/资源库/Caches/CocoaPods,删除search_index.json这个文件，这个文件是pod search 搜索时的缓存文件


**Carthage构建Framework**
+ Build Phases --->Headers 将需要暴露的 .h 文件拖拽到 Public 里面，将相应的 .m 文件拖拽到 Compile source 里面
+ 如果你的 framework target 名称与你想要打包构建的 framework 名称不一致，选中 `Build Settings` 选项卡，搜索 `Packaging` ，把 `Produce Module Name` 和 `Produce Name` 改成你想要构建的 framework 名称
+ 如果你使用了类别，那么你需要在 Build Settings 的 Linking 的 Other Linker Flags 里加上 -all_load 。
+ 如果你想你的工程支持 bitcode ，需要在 Other C Flags 里加上 -fembed-bitcode 。
+ 由于 Carthage 在 build 时，会自动将设置为 `Shared` 的 framework target 构建成 framework ，所以需要单击顶部 target ，在弹出选项中选中 Manager Schemes ，将 framework target 的 Shared 选项选中
![ed63c37f21c3f5833da183914345b829.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1320)@w=200
![ad0e0fab037606e910dc4b222d9da1a1.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1321)@w=500

**打包**
```shell
carthage build --no-skip-current
```
cd 到工程目录下,打包 framework ，执行完成后会自动将 framework 文件保存在工程的 Carthage/Build 文件夹下
![e45ba6fbc056f6c4319aa4fa3aa772ec.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1322)@w=200
将生成的 framework 文件拖进测试项目进行测试即可


**发布**
测试没问题后，将工程 push 并打上 tag 即可，tag 名称必须是版本号

```shell
git tag 1.0.0
git push --tags
```
这样你的项目就已经支持 Carthage 了，其他开发者就可以使用 Carthage 来管理你的项目依赖了，只需要将 framework 工程 push 上去即可，打包生成的测试 framework 文件不需要 push。


**加载本地库**
```shell
// Use a local project
git "file:///Users/Lee/Desktop/TEST" ~> 0.0.1
```
限制条件：
1. 必须纳入 git 管理；
2. 指定路径是 .xcworkspace 或者 .xcodeproj 所在目录的绝对路径；
3. 在这种没有附加任何条件的情况下，库必须用 tag 来划分版本，即使上面的语法里没有指定版本，而上面的语法将使用最新版本号下的版本，如果你提交了一个新的 commit，但是却没有给这个 commit 添加 tag，上面的语法仍然使用最近的一个 tag 指定的版本而不是最新的 commit。


#### 访问控制 
> 常量、变量、属性不能拥有比它们的类型更高的访问级别,当类型是 public 访问级别时，其成员的访问级别却只是 internal
> 常量、变量、属性、下标的 Getters 和 Setters 的访问级别和它们所属类型的访问级别相同,Setter 的访问级别可以低于对应的 Getter 的访问级别，这样就可以控制变量、属性或下标的读写权限,可以通过 fileprivate(set)，private(set) 或 internal(set),> 在 var 或 subscript 关键字之前为它们的写入权限指定更低的访问级别
> 如果把该函数当做 public 或 internal 级别来使用的话，可能会无法访问 private 级别的返回值
> 如果你定义了一个 public 访问级别的协议，那么该协议的所有实现也会是 public 访问级别
> 枚举成员的访问级别和该枚举类型相同，你不能为枚举成员单独指定不同的访问级别
> 枚举定义中的任何原始值或关联值的类型的访问级别至少不能低于枚举类型的访问级别(不能在一个 internal 访问级别的枚举中定义 private 级别的原始值类型)
> 如果在 private 级别的类型中定义嵌套类型，那么该嵌套类型就自动拥有 private 访问级别
> 如果在 public 或者 internal 级别的类型中定义嵌套类型，那么该嵌套类型自动拥有 internal 访问级别
> 子类的访问级别不得高于父类的访问级别。例如，父类的访问级别是 internal，子类的访问级别就不能是 public。(通过继承可访问父类成员, 如果父类private则访问不到),可以通过重写为继承来的类成员提供更高的访问级别
> 扩展成员具有和原始类型成员一致的访问级别
> 泛型类型或泛型函数的访问级别取决于泛型类型或泛型函数本身的访问级别
> 类型别名的访问级别不可高于其表示的类型的访问级别

**open public**
+ 开放访问和公开访问可以访问同一模块源文件中的任何实体，在模块外也可以通过导入该模块来访问源文件里的所有实体
+ 通常情况下，框架中的某个接口可以被任何人使用时，你可以将其设置为开放或者公开访问。
+ 区别: *是否需要在其他模块中继承重写*
+ public或者其他更严访问级别的类，只能在它们定义的模块内部被继承;公开访问public或者其他更严访问级别的类成员，只能在它们定义的模块内部的子类中重写。
+ open访问的类，可以在它们定义的模块中被继承，也可以在引用它们的模块中被继承。开放访问open的类成员，可以在它们定义的模块中子类中重写，也可以在引用它们的模块中的子类重写
+ open把一个类标记为开放，显式地表明意味着其他模块中的代码使用此类作为父类，然后你已经设计好了你的类的代码了。

**internal**
+ 如果你不为代码中的实体显式指定访问级别，那么它们默认为 internal 级别
+ 内部访问可以访问同一模块源文件中的任何实体，但是不能从模块外访问该模块源文件中的实体。
+ 通常情况下，某个接口只在*应用程序或框架内部使用*时，你可以将其设置为内部访问。

**fileprivate**
+ 文件私有访问限制实体只能被所定义的文件内部访问。
+ 当需要把这些细节被*整个文件使用*的时候，使用文件私有访问隐藏了一些特定功能的实现细节。

**Private**
+ 私有访问限制实体只能在所定义的*作用域内使用*。
+ 需要把这些细节被整个作用域使用的时候，使用文件私有访问隐藏了一些特定功能的实现细节。


**最小化原则:**
>基于框架开发的特点，相较于 app 开发，需要更着重地考虑 API 的设计。你标记为 public 的内容将是框架使用者能看到的内容。提供什么样的 API 在很大程度上决定了其他的开发者会如何使用你的框架。
>在 API 设计的时候，从原则上来说，我们一开始可以提供尽可能少的接口来完成必要的任务，这有助于在框架初期控制框架的复杂程度。 之后随着逐步的开发和框架使用场景的扩展，我们可以添加公共接口或者将原来的 internal 或者 private 接口标记为 public 供外界使用
```swift
// Do this
public func mustMethod() { ... }
func onlyUsedInFramework() { ... }
private func onlyUsedInFile() { ... }

// Don't do this
public func mustMethod() { ... }
public func onlyUsedInFramework() { ... }
public func onlyUsedInFile() { ... }
```

----
#### 源文件规范
**API命名规范**  [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
1. 命名提倡*清晰的*用法包含所有必需的词组以避免歧义
```swift
public mutating func removeAt(position: Index) -> Element
employees.remove(x) // 有歧义：是移除元素 x 吗？
```
如果我们省略了这个方法名中 At 这个词，就会暗示读者这个方法是用来检索并移除 x 元素的，而不是使用 x 来表明要移除元素的位置

2. 通常情况下，应该要省略掉仅仅只重复类型信息的词组
```swift
public mutating func removeElement(member: Element) -> Element?
// 词组 Element 在这个调用语句中并没有增添任何有意义的信息
public mutating func remove(member: Element) -> Element? // 更直观
```

3. 有时候，为了避免歧义的出现，重复类型信息是非常有必要的，但是通常情况下使用词组来描述参数的作用会更好一些，而不是描述它的类型。
```swift
func add(observer: NSObject, for keyPath: String)
grid.add(self, for: graphics) // 不明确的表达

func addObserver(_ observer: NSObject, forKeyPath path: String)
grid.addObserver(self, forKeyPath: graphics) // 直观的作用
```

4. 遵循英文文法
通常情况下，Mutating 方法会拥有一个非 Mutating 的变体方法(variant)，返回和方法作用域相同或者相似的类型。
+ 当Mutating 方法是用一个*动词命名*的话，那么命名其对应的非 Mutating 的方法的时候，可以根据 "ed/ing" 的语法规则来进行命名: x.sort()和x.append(y)的 非Mutating 版本应该是x.sorted()以及x.appending(y)
+ Mutating 方法应该以*祈使句的形式命名*: x.reverse()、x.sort()、x.append(y)
+ 非 Mutating 方法的以*名词短语*的形式命名: x.distanceTo(y)、i.successor()
+ 通常使用动词的过去式（通常在动词末尾添加"ed"）来命名非 Mutating 的变体：
```swift
mutating func reverse() 
func reversed() -> Self
```
+ 如果动词拥有一个*直接宾语*的话，那么添加"ed"将不符合英文文法，这时候应该使用动词的*动名词形式*（通常在动词末尾添加"ing"）来命名非 Mutating 的变体：
```swift
mutating func stripNewlines()
func strippingNewlines() -> String
```
+ 非 Mutating 的布尔方法和属性应该以关于作用域断言(assertions)的形式命名: x.isEmpty
+ 描绘某个类*特征的协议*应该以名词的形式命名: Collection
+ 描绘某个类*作用的协议*应该以able、ible或者ing后缀的形式命名
+ 其余类型、属性、变量以及常量应该以名词的形式命名

5. 术语
+ 避免使用晦涩的术语。如果有一个同样能很好地传递相同意思的常用词的话，那么请使用这个常用词。如果用 "skin"(皮肤) 就能很好地表达您的意思的话，那么请不要使用 "epidermis"(表皮)。专业术语是一个必不可少的交流工具，但是应该仅在需要表达关键信息的时候使用，不然的话就不能达到交流的目的了。
+ 遵循公认的涵义。如果在使用专业术语的话，请使用最常见的那个意思。
+ 使用术语而不是使用常用词的唯一理由是：*需要精确描述某物*，否则就可能会导致涵义模糊或者不清晰。因此，API 应当严格地使用术语，秉承该术语所公认的涵义。
+ 不要试图新造词意：任何熟悉此术语的人在看到您新造词意的时候都会感到非常惊愕，并且很可能会被这种做法所惹怒。
+ 不要迷惑初学者：每个新学此术语的人都会去网上查询该术语的意思，他们看到的会是其传统的涵义。
+ *避免使用缩写*。缩写，尤其是非标准的缩写形式，实际上也是“术语”的一部分，因为理解它们的涵义需要建立在能够将其还原为原有形式的基础上。
+ 循规蹈矩：不要为了让初学者能更好理解，就要以破坏既有文化的代价来优化术语。

5. 约定
+ 任何复杂度不为 O(1)的计算型属性都应当将复杂度标注出来。 - Complexity: 
+ 优先考虑方法和属性，而不是自由函数。自由函数(Free Function)只在几种特殊情况下才能使用(可使用协议的默认实现)：
1. 当没有明显的self对象的时候：min(x, y, z)
2. 当函数是一个不受约束的泛型(unconstrained generic)的时候：print(x)
3. 当函数语法是某个领域中公认的符号时：sin(x)
+ 遵循大小写约定：*类型、协议和枚举*的命名应该是 UpperCamelCase 的形式，其他所有的命名全部是 lowerCamelCase 的形式。
+ 当多个方法拥有相同的基础含义的时候，可以使用相同的名字（重载），特别是对于有不同的参数类型，或者在不同的作用域范围内的方法。
```swift
extension Database {
/// Rebuilds the database's search index
func index() { ... }
/// Returns the `n`th row in the given table.
func index(n: Int, inTable: TableID) -> TableRow { ... }
}
```
+ 要避免“返回类型的重载”，因为这会导致在类型推断的时候出现歧义：
```swift
extension Box {
/// Returns the `Int` stored in `self`, if any, and
/// `nil` otherwise.
func value() -> Int? { ... }

/// Returns the `String` stored in `self`, if any, and
/// `nil` otherwise.
func value() -> String? { ... }
}
```

6. 参数
+ 充分利用参数默认值，这样可以简化常用的操作. 默认参数通过隐藏不相关的信息提高了方法的可读性
```swift
let order = lastName.compare(royalFamilyName, options: [], range: nil, locale: nil)
let order = lastName.compare(royalFamilyName)
```
+ 最好将带有默认值的参数放在参数列表的最后面
+ 最好遵循 Swift 关于外部参数名(argument labels)的默认约定:
1.方法和函数的第一个参数不应该有外部参数名
2.方法和函数的其他参数都应该有外部参数名
+ 所有构造器(initializer)中的参数都需要有外部参数名
+ 对于执行类型转换（参数是待转换的类型，构造器所在的类是要转换的目标类型）的构造器来说,第一个参数应该是待转换的类型，并且这个参数不应该写有外部参数名
+ 有损转换”就意味着编译器需要删除待转换类型多余的空间以便存放到目标类型当中，比如说 Int64 转换为 Int32，编译器会将 Int64 多余的32位数据砍掉，才能放到 Int32当中
```swift
extension UInt32 {
init(_ value: Int16)            // 无损(widening)转换，无需外部参数名
init(truncating bits: UInt64)
init(saturating value: UInt64)
}
```
+ 当所有的参数都能相互配对，以致*无法有效区分*的时候，这些参数都不应该添加外部参数名。最常见的例子就是 min(number1, number2) 以及 zip(sequence1, sequence2)了。
+ 当第一个参数有默认值的时候，应该为之添加一个不同的外部参数名。
```swift
extension Document {
func close(completionHandler completion: ((Bool) -> Void)? = nil)
}
doc1.close()
doc2.close(completionHandler: app.quit)
```
如果您省略了外部参数名的话，语句调用就可能会出现歧义，它可能会将参数认做是"语句"的直接宾语
```swift
extension Document {
func close(completion: ((Bool) -> Void)? = nil)
}
doc.close(app.quit)              // 是要关闭这个退出函数 ？
```

7. 特别说明
+ 要特别小心无约束的多态类型(unconstrained polymorphism)（比如说 Any、AnyObject 以及其它未加约束的泛型参数），避免重载集(Overload Set)中出现的歧义
+ 如果某个方法的名字加上一行简单注释，就已经可以完全表达这个方法的作用的话，那么可以忽略为每个参数和它的返回值撰写详细的文档注释。

[**Markdown注释规范**](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html#//apple_ref/doc/uid/TP40016497-CH2-SW1)


**Swiftlint格式规范**
1. 代理应该写成weak类型（弱代理）来避免循环引用,如果要使用swiftlint中的这个 weak_delegate 属性， 当你所定义的变量名被理解成某某代理时， 则需要加关键字 weak 来消除warning， 最好的方式是别乱取名字， 比如这样取名也是错误的：var delegate: String?， 这也会trigger swiftlint warning!
```swift
class Langke {
var chenlong: NSObjectProtocol?
}
/// 编译通过，但是触发swiftlint的 weak_delegate警告，原因是变量名 myDelegate 中有 delegate 关键字，这属于名字滥用:
class Langke {
var myDelegate: NSObjectProtocol?
}
/// 编译通过， 不会触发警告， 原因是在 var 关键字前面加了 weak
class Langke {
weak var myDelegate: NSObjectProtocol?
}
/// 编译通过，但是触发 weak_delegate 警告，原因是 scrollDelegate 中 Delegate 放在了最后， 被理解成了代理
class Langke {
var scrollDelegate: UIScrollViewDelegate?
}
/// 编译通过， 既然变量名被理解成了代理， 那为了类似防止循环引用， 应该加关键字 weak
class Langke {
weak var scrollDelegate: UIScrollViewDelegate?
}
/// 编译通过， 不会触发警告， 因为delegate放在了前面， 没有被理解成代理
class Langke {
var delegateScroll: UIScrollViewDelegate?
}
```
2. void_return。 返回值为空，推荐用 ” -> Void “, 而不是 ” -> () “, 主要针对全局变量/常量闭包：如let xingYun: () -> () = {},返回为空全部统一用关键字 Void， 不要用 ()
```swift
/// 触发void_return 和 属性46：redundant_void_return
func XingYun() -> () {}
// 触发void_return
let xingYun: () -> ()
/// 不触发 void_return, 但是会触发属性46： redundant_void_return
func XingYun() -> Void {}
// 不触发
let xingYun: () -> Void
```
3. vertical_whitespace。 垂直方向上的空格行，限制为一行（注释除外),垂直方向行间数最多为1， 这样可以保证code的饱满性、可读性
4. variable_name 。 变量名应该只包含字符数字字符， 并且只能以小写字母开头或者应该只包含大写字母。
变量名不应该太长或者太短(应该在3-40个字符间)
5. valid_ibinspectable 。@IBInspectable在swiftlint中的使用需要注意， 第一必须是变量， 第二必须要有指定的类型，如果指定的类型是可选类型或者隐式类型，则目前官方只支持以下几种类型：String, NSString, UIColor, NSColor, UIImage, NSImage.
6. file_header。文件头。文件应该有一致的注释.
7. prohibited_super_call 。被禁止的父类响应。一些方法不应该响应父类。
8. colon 。冒号的使用， swiftlint的这个colon属性规则很简单，要求“ ：”紧靠所定义的常量或变量等，必须没有空格，与所指定的类型之间必须只有一个空格，多一个或少一个都不行，如果是用在Dictionary中，则要求紧靠Key，与Value之间必须有且仅有一个空格。这个规则我觉得应该强制推荐使用。由于简单，就不举例子了。
9. comma 。逗号规则，只要遵循“前不离身后退一步”就行了
10. trailing_newline 。尾部新行，官方文档给出的description是：”Files should have single trailing newline”, 也就是说，文件（属性、方法）结束的的时候*（“}”之前*， 应该有一个空格新行，但这里要注意的是， 只是应该， 而不是必须， 所以这个属性也算是一个可选属性。
11. line_length 。行的字符长度属性。这个强烈不推荐使用。官方的规定是超过120字符就给warning， 超过200个字符就直接报error！
12. mark 。 标记方法或者属性。这个推荐使用， 可以统一方法标记的格式， 有利于review查找某个方法或者属性的时候更清晰。使用也非常简单： “MARK”前空一格，”MARK:”后空一格。
13. todo 。TODO 和 FIXME 应该避免使用， *使用“notaTODO 和 notaFIXME”代替*。另外， 和 MARK 标记不同的是， “notaTODO 和 notaFIXME”没有空格要求，但是我建议如果要使用这个 todo 属性， 尽量写成和 MARK 一样的规范。
14. trailing_comma 。尾部逗号， 这个强烈推荐使用， 这个属性主要针对数组和字典最后一个元素。
```swift
/// 数组这样写是没有任何问题的, 但是最后一个元素3后面加了一个逗号“,”尽管这样不会报错，但是这会让程序的可读性变差
let ages = [1, 2, 3,]
let person = ["XingYun": 98, "JinGang": 128, "LangKe": 18,]
```
15. trailing_semicolon 。末尾分号， 强烈推荐使用，尽管在变量或常量赋值之后加不加分号在swift中没有硬性的要求，但是为了使code style更swift化，所以尽量或者绝对不要加“;”。
16. closing_brace 。封闭大括号， 大括号和括号中间不应该有任何的空格， 也就是 “{}”和“（）”不能有空格， 这个属性推荐使用。
17. closure_end_indentation 。 闭包结束缩进， 什么意思呢？就是 大括号（一般是方法）上下对齐的问题，这样使code看起来更加整洁。
```swift
/// 必须注意的是，大括号左边“{”前面有一个空格，没有则会触发closure_end_indentation警告
langke.beginFishing {.........
.............
}
```
18. closure_spacing 。 闭包空格，闭包表达式在每个大括号内应该有一个单独的空格， 要注意的是这里指的是“应该”， 我自己测试了一下，在swift 3.0并没有报warning， 所以这也不是强制性要求，但这个推荐使用。
```swift
[].filter { content }
```
19. closure_parameter_position 。 闭包参数位置， 闭包参数应该和大括号左边在同一行, 推荐使用。
```swift
/// number 和 { 在同一行
let names = [1, 2, 3]
names.forEach { (number) in
print(number)
}
/// 这样不行，违背 closure_parameter_position规则, 触发warning
let names = [1, 2, 3]
names.forEach { 
(number) in
print(number)
}
```
20. dynamic_inline 。动态–内联， 避免一起使用 dynamic 和 @inline(_ _ always)， 否则报 error
21. unused_closure_parameter 。 不使用的闭包参数， swiftlint建议最好不使用的闭包参数使用 “_”代替。
22. compiler_protocol_init 。 编译器协议初始化，
23. control_statement 。 控制语句， if、for、while、do语句不应该将 条件 写在 圆括号 中， 另外注意条件出的空格。这个属性保证了代码的简洁性， 一般而言，在swift中的条件句中尽量不加括号， 直接写条件，除非特别需要！
24. custom_rules 。 自定义规则。 这个属性可以通过提供正则表达式来创建自定义规则， 可选指定语法类型搭配， 安全、级别和要陈列的什么信息。 这个属性只要熟悉使用正则表达式的人使用，目前可以不适用。
25. cyclomatic_complexity 。循环复杂度。函数体的复杂度应该要限制，这个属性主要约束条件句、循环句中的循环嵌套问题， 当嵌套太多的循环时，则会触发swiftlint中的warning和error，当达到10个循环嵌套时就会报warning，达到20个循环嵌套时就会报error，
26. empty_count 。比起检查 count 是否为 0 ， swiftlint上说更喜欢检测 “isEmpty”。
27. statement_position。 陈述句位置， 这里主要指的是 else 和 catch 前面要加一个空格， 也不能大于1个空格， 否则就会触发警告。
28. opening_brace 。在声明的时候， 左大括号应该有一个空格，并且在同一行
29. empty_parameters 。为空参数
```
/// 01 不会触发warning
let abc: () -> Void
func foo(completion: () -> Void) {}
/// 02 直接报错
let bcd: Void -> Void
```
30. file_length 。
31. force_cast 。强制转换， 强制转换应该被避免
32. function_body_length 。函数体长度， 函数体不应该跨越太多行， 超过40行给warning， 超过100行直接报错。
33. function_parameter_count 。函数参数个数， 函数参数数量(init方法除外)应该少点， 不要太多，swiftlint规定函数参数数量超过5个给warning， 超过8个直接报error。
34. imlicit_getter 。隐式getter方法。计算的只读属性应该避免使用 get 关键字
35. legacy_cggeometry_functions 。遗留的CG几何函数， 当获取某个视图的宽、高、最小X、最大X值等等， swiftlint推荐使用swift的标准语法， 尽量不要使用从Objective-C中的遗留版本， 尽量语法swift化。
```swift
/// 这样不推荐使用
CGRectGetWidth(someView.frame)
/// 推荐使用下面的形式
rect.width
rect.height
rect.minX
rect.midX
rect...................
/// swift 3.0, Xcode 8.1中作如下尝试， 编译直接失败，报错：CGRectGetMaxX has been replaced by property CGRect.maxX
let myLabel = UILabel(frame: CGRect(x: CGRectGetMaxX(myView.frame), y: 22, width: 33, height: 44))
/// 根据**系统**提示信息改正如下
let myLabel = UILabel(frame: CGRect(x: myView.frame.maxX, y: 22, width: 33, height: 44))
// swiftlint已经将这个属性紧靠系统原生API， OC带过来的CG几何函数很多已被弃用
```
36. legacy_constructor 。遗留版本构造器, swiftlint要求系统自带构造器， 使用swift语法化， 不要使用OC版本的构造器。
```swift
/// swift语法， swift 3.0已经强制使用了，所以尽管swiftlint不定制这种规则， 系统也会强制规定使用
CGPoint（x: 10， y: 20）
/// 错误的构造器语法
CGPointMake(10, 20)
```
37. legacy_nsgeometry_functions 。 ns类几何函数，和前面的几个属性一样， 使用swift点语法函数，不使用以前的版本。
38. operator_usage_whitespace 。操作符使用规则， 操作符两边应该有空格。
39. overridden_super_call 。 重写父类方法
```swift
/// 正确的写法
override func viewWillAppear(_ animated: Bool) {
/// 注意重写父类方法
super.viewWillAppear(animated)
}
```
40. private_outlet 。私人输出， IBOutlet 这个属性应该是私人的， 为了避免泄露UIKit到更高层
41. redundant_string_enum_value 。 多余的字符串枚举值， 在定义字符串枚举的时候， 不要让枚举值和枚举成员名相等
```swift
// warning 1
enum Numbers: String {
case one = "one"
case two
}
```
当然， 只要有一个case 的成员名和枚举值不相等， 那就没有warning， 比如：
```swift
enum Numbers: String {
case one = "ONE"
case two = "two"
}
```
42. redundant_void_return 。多余的返回值为空， 在函数声明的时候，返回值为空是多余的。定义常量或者变量的时候可以。
43. return_arrow_whitespace 。 返回箭头空格， swiftlint推荐返回箭头和返回类型应该被空格分开， 也就是 “->”和 type 之间有空格。
44. type_name 。类型名， 类型名应该只包含字母数字字符， 并且以大写字母开头，长度在3-40个字符。
45. syntactic_sugar 。语法糖， swiftlint推荐使用速记语法糖， 例如 [Int] 代替 Array
46. switch_case_on_newline 。switch语句新行， 在switch语法里， case应该总是在一个新行上面,就是要求在switch语句中，case要求换行。
47. shorthand_operator 。速记操作符， 什么是速记操作符呢？ 在swiftlint中， 就是我们常用的简洁操作运算符，比如：+= ， -=，/= 等等。在swiftlint中，在做一些赋值操作的时候，推荐使用简短操作符。
48. sorted_imports 。 分类/有序导入。
49. number_separator 。数字分割线。当在大量的小数中， 应该使用下划线来作为千分位分割线。1_000
50. nimble_operator 。 敏捷操作符。和自由匹配函数相比， 更喜欢敏捷操作符， 比如：>=、 ==、 <=、 <等等。
51. nesting 。嵌套。类型嵌套至多一级结构， 函数语句嵌套至多五级结构。
52. redundant_optional_initialization。 多余的可选初始化， 可选变量初始化为 nil 时是多余的
53. leading_whitespace 。文件开始不应该有空格或者换行
54. vertical_parameter_alignment 。垂直方向上的参数对齐。当函数参数有多行的时候， 函数参数在垂直方向上应该对齐（参数换行的时候左边对齐）。
55. conditional_returns_on_newline 。条件返回语句应该在新的一行。 当有条件返回的时候应该换行返回，而不是在同一行。
```swift
/// swiftlint 不推荐的写法, 否则会触发warning（但是在swift 3.0上测试并不会触发任何warning）
if true { return }
guard true else { return }
/// swiftlint 推荐的写法
if true {
return
}
guard true else {
return 
}
```
56. force_unwrapping 。 强制解包/拆包。我们知道，当一个类型是可选类型的时候，当我们获取值时，需要强制解包（也叫隐式解包）, 通常我们是在一个变量或者所需要的常量、类型等后面加一个“ ！”， 然而，swiftlint建议强制解包应该要避免， 否则将给予warning.
57. missing_docs 。缺失说明注释, 官方解释：”Public declarations should be documented.”， 公共声明应该被注释/标记。 在函数声明的时候， 一般情况下， 带public关键字的函数的注释只能用 “///”和 “/* /”来注释， 如果不带public关键字的函数只能用 “//” 和 “/* /”
58. valid_docs 。有效文件 。 文件声明应该有效 
59. type_body_length 。类型体长度。类型体长度不应该跨越太多行， 超过200行给warning，超过350行给error。
60. redundant_nil_coalescing 。多余的为空联合操作符。为空联合操作符用来判断左边是否为空，伴随nil的为空操作符在右边是多余的。
61. object_literal 。对象字面量， swiftlint表示比起图片和颜色初始化，更喜欢对象字面量
62. private_unit_test 。私有的单元测试。被标记为private的单元测试不会被测试工具XCTest运行， 也就是说，被标记为private的单元测试会被静态跳过。
63. frist_where 。
64. operator_whitespace 。
```swift
// "=="和“(lhs: Something, rhs: Something)”之间应该有一个空格
static func ==(lhs: Something, rhs: Something) -> Bool {
return lhs.text == rhs.text
}
```
65. overridden_super_call。一些复写方法应该总是调用父类
```swift
/// 这样会触发警告
class VCd: UIViewController {
override func viewWillAppear(_ animated: Bool) {
//没有调用父类

}
}

/// 不会触发警告
class VCd: UIViewController {
override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(animated)

}
}
```
66. override_in_extension 在 extension中,不能重写未声明的属性和未定义的方法
67. 在switch-case语句中, 建议不要将case中的let和var等关键字放到元祖内
```swift
//正确写法
switch foo {
case let .foo(x, y): break
}
switch foo {
case .foo(let x), .bar(let x): break
}
```
68. prefixed_toplevel_constant 类似*全局常量,建议前缀以k开头*
```swift
//推荐写法
private let kFoo = 20.0
public let kFoo = false
internal let kFoo = "Foo"
let kFoo = true
```
69. private_action  IBActions修饰的方法,应该都是私有的
```swift
//推荐写法
class Foo {
@IBAction private func barButtonTapped(_ sender: UIButton) {}
}
struct Foo {
@IBAction private func barButtonTapped(_ sender: UIButton) {}
}
class Foo {
@IBAction fileprivate func barButtonTapped(_ sender: UIButton) {}
}
struct Foo {
@IBAction fileprivate func barButtonTapped(_ sender: UIButton) {}
}
private extension Foo {
@IBAction func barButtonTapped(_ sender: UIButton) {}
}
fileprivate extension Foo {
@IBAction func barButtonTapped(_ sender: UIButton) {}
}
```
70. private_outlet  IBOutlets修饰的属性应该都是私有的
```swift
//推荐写法
class Foo {
@IBOutlet private var label: UILabel?
}
class Foo {
@IBOutlet private var label: UILabel!
}
//不推荐写法
class Foo {
@IBOutlet var label: UILabel?
}
class Foo {
@IBOutlet var label: UILabel!
}
```
71. protocol_property_accessors_order 在协议中声明属性时，访问者的顺序应该是get set
72. quick_discouraged_call 在单元测试中,不建议在describe和content比保重直接调用方法和类
73. quick_discouraged_focused_test 在单元测试中,不建议集中测试,否则可能不能运行成功
74. quick_discouraged_pending_test 单元测试中阻止未进行的测试单元
75. redundant_discardable_let 不需要初始化方法返回结果时,建议使用: _ = Person(), 而不是:let _ = Person()
76. redundant_nil_coalescing 使用可能为为nil的可选值时,建议使用: str ?? “”, ??左右两侧要有一个空格
77. redundant_string_enum_value 在定义字符串枚举的时候, 当字符串枚举值等于枚举名称时，可以不用赋值
```swift
//不会触发warning
enum Numbers: String {
case one
case two
}
enum Numbers: Int {
case one = 1
case two = 2
}
//会触发warning
enum Numbers: String {
case one = "one"
case two = "two"
}
enum Numbers: String {
case one = "one", two = "two"
}
```
78. required_enum_case 定义的枚举,必须有与其对应的操作实现
79. single_test_class 单元测试中,测试文件应该包含一个QuickSpec或XCTestCase类
80. sorted_first_last 在获取某数组中最大最小值时,建议使用min和max函数,而不是sorted().first和sorted().lase
81. strict_fileprivate extension中不建议使用fileprivate 修饰方法和属性
82. superfluous_disable_command 被禁用的规则不会在禁用区域触发警告


---
#### 版本控制Git
**安装和配置**
```shell
brew install git

git config —global user.name 'XXXX'
git config —global user.email 'XXXX@hotmail.com'
git config —global core.editor 'vim'
git config --global alias.st status //配置别名
git config --global unset alias.l   //删除别名
```
+ --global：表示修改全局配置；
+ user.name和user.email：用于设置Git的用户名和邮箱，git会使用这些信息记录各种操作；
+ core.editor：用于设置git的默认编辑器。例如，当我们提交的时候，git就会打开这个默认编辑器，让我们输入提交注释；
相关信息保存在 Finder-前往-个人-隐藏文件  git.config
```shell
cd ~/.ssh
$ ls
authorized_keys2  id_dsa       known_hosts config            id_dsa.pub
$ cat ~/.ssh/id_rsa.pub        // 查看公钥加入到Github

$ git remote -v
origin https://github.com/someaccount/someproject.git (fetch)
origin https://github.com/someaccount/someproject.git (push)

git remote set-url origin git@github.com:someaccount/someproject.git
// 复制出ssh链接替换
```

**创建git仓库**
|命令|解释|
|-|-|
git init|跟踪的所有信息，都包含在.git目录里|
git status|
git add|
git commit|
git commit -m "Add welcome content."|
git log|


**提交**
1.修改提交
git commit --amend  修改上一条

2.挂起提交
>当你在某个分支上进行开发时，如果要紧急切换回master修复BUG，则可以先在当前分支上提交，之后切换分支，修复BUG并提交，然后，切换回功能分支继续开发。当然，这只是一个理想的情况，现实中，有很多时候，我们的代码还不具备提交条件，面对这种情况，该怎么办呢？
>error: Your local changes to the following files would be overwritten by checkout:  test.rb
Please commit your changes or stash them before you switch branches.
Aborting
```
git stash
// Saved working directory and index state WIP on NEW: cfcf9b7 add new file
```
在别的分支处理完后执行git stash apply stash{0}。这里的stash ID是可选的，如果不指定，git就会使用最新的一次stash把“缓存”的代码恢复回来
```
git stash list
// stash@{0}: WIP on NEW: cfcf9b7 add new file

git stash apply stash{0} // 恢复 缓存内还会存在副本
git stash pop stash{0}   // 恢复 并且删除副本
git stash drop stash{0}  // 清除 缓存记录s
```
如果删除分支,在其他分支上 git stash pop 进行恢复


Saved working directory and index state WIP on NEW: cfcf9b7 add new file
**分支**
1.创建
```shell
git branch xxxx
git branch -d xxx 
git checkout xxx
```

2.合并
>`冲突` Automatic merge failed; fix conflicts and then commit the result. 
>git status --->  both modified: test.swift
>对同一处代码修改,提交后存在两个不同的版本. 合并分支之前，我们得明确告诉git究竟哪边的代码才是真正需要的
>git提示我们合并的路径上有冲突，要么自己解决冲突之后再提交，要么执行git merge --abort取消合并
```rb
<<<<<<< HEAD
当前分支修改的内容
=======
另一个分支上修改的内容
>>>>>>> MyBranch2
```
+ <<<<<<< HEAD和=======之间的部分，表示当前分支上中的内容
+ =======和>>>>>>> 另一个分支上的内容

3.删除
```shell
git branch -d xxxx
git pull origin -d xxx   //删除远程分支
git branch -a           //查看远程分支
```

4. rebase
> 仅仅变基那些尚未公开的提交对象,一旦分支中的提交对象发布到公共仓库，就千万不要对该分支进行变基操作
> 一般我们使用变基的目的，是想要得到一个能在远程分支上干净应用的补丁 — 比如某些项目你不是维护者，但想帮点忙的话，最好用变基
> 主要是把解决分支补丁同最新主干代码之间冲突的责任，化转为由提交补丁的人来解决。rebase 的时候解决好 然后就直接可以merge了
变基会生成一个新的合并提交对象，从而改写提交历史, master 只是执行了Fast forward
+ 如果master主要分支提交 分支也存在提交 存在两个快照 会新建一个commit快照 此时 git rebase master 处理冲突
+ git merge branch 就不需要处理冲突了 保留分支提交内容都在一条线上 


```shell
git rebase master
git merge branch
```
+ 如果master主要分支没有提交快照 此时新建的分支在master merge该分支后只是指针的右移 Fast forward 
+ 如果master主要分支提交 分支提交 存在两个快照 会新建一个commit快照


**版本控制**
> HEAD 指向最近一次commit里的所有snapshot
> Index 缓存区域，只有Index区域里的东西才可以被commit
> Working Directory 用户操作区域
> --mixed 默认操作 index不保留之前的提交 Working Directory保留修改 删除回退点前的历史记录 保留回退点前的文件
> --soft index保留之前的提交 Working Directory保留修改 删除回退点前的历史记录 保留回退点前的文件
> --hard 之前的提交和修改都不保留 删除回退点前的历史记录 删除回退点前的文件
> --keep Working Directory保留当前的修改文件 不保留之前的提交 删除回退点前的历史记录 删除回退点前的文件
|command|explanation|
|-|-|
git reset --hard HEAD^|返回上一个版本
git reset --hard HEAD^^|返回到前两个版本
git reset --hard 2ff85c9|返回到指定版本
git reflog|如果回到早期版本 那么之后的版本就不存在了 需要历史引用日志

reset是用来修改提交历史的,这个时候你有两个选择，要么使用git revert（推荐），要么使用git reset。

![3f8bdf022224f1928c6eea7bbeec0980.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1375)@w=200

上图可以看到git reset是会修改版本历史的，他会丢弃掉一些版本历史。所以*已经push*到远程仓库的commit不允许reset
而git revert是根据那个commit逆向生成一个新的commit，版本历史是不会被破坏

git add files 把当前文件放入暂存区域。
git commit 给暂存区域生成快照并提交。
git reset -- files 用来撤销最后一次git add files，你也可以用git reset 撤销所有暂存区域文件。
git checkout -- files 把文件从暂存区域复制到工作目录，用来丢弃本地修改。


在提交层面上，reset将一个分支的末端指向另一个提交。这可以用来移除当前分支的一些提交。比如，下面这两条命令让hotfix分支向后回退了两个提交。

git checkout hotfix
git reset HEAD~2
hotfix分支末端的两个提交现在变成了悬挂提交。也就是说，下次Git执行垃圾回收的时候，这两个提交会被删除。换句话说，如果你想扔掉这两个提交,如果你的更改还没有共享给别人，git reset是撤销这些更改的简单方法。当你开发一个功能的时候重新来过时，reset就像是go-to命令一样,除了在当前分支上操作，你还可以通过传入这些标记来修改你的缓存区或工作目录：

--soft 缓存区和工作目录都不会被改变 reset only HEAD
已经commit a  b  c) add d或者没有add  然后reset --soft到b  
log中c的提交记录会删除 缓存区保留c和d 如果没有add工作区保留d   c的文件会保留


--mixed – 默认选项。缓存区和你指定的提交同步，但工作目录不受影响 reset HEAD and index
已经commit a  b  c) add d或者没有add  然后reset --soft到b  
log中c的提交记录会删除 缓存区不保留c和d 如果没有add工作区保留d   c的文件会保留


--keep  reset HEAD but keep local changes
已经commit a  b  c) add d或者没有add  然后reset --keep到b 
log中c的提交记录会被删除  d的修改会被保留(无论是否添加到缓存区) c的文件会删除 缓存中也不会留下C

--hard  – 缓存区和工作目录都同步到你指定的提交 reset HEAD, index and working tree
什么都不保留全部舍弃改动

这些标记往往和HEAD作为参数一起使用。比如，git reset --mixed HEAD 将你当前的改动从缓存区中移除，但是这些改动还留在工作目录中。另一方面，如果你想完全舍弃你没有提交的改动，你可以使用git reset --hard HEAD。这是git reset最常用的两种用法。

当你传入HEAD以外的其他提交的时候要格外小心，因为reset操作会重写当前分支的历史。正如Rebase黄金法则所说的，在公共分支上这样做可能会引起严重的后果。


checkout命令用于从历史提交（或者暂存区域）中拷贝文件到工作目录，也可用于切换分支。如果回到早期版本 那么之后的版本就不存在了
这个命令做的不过是*将HEAD移到一个新的分支*，然后更新工作目录。因为这可能会覆盖本地的修改，Git强制你提交或者缓存工作目录中的所有更改，不然在checkout的时候这些更改都会丢失。
如果你当前的HEAD*没有任何分支引用*，那么这会造成HEAD分离。这是非常危险的，如果你接着添加新的提交，然后切换到别的分支之后就没办法回到之前添加的这些提交。因此，*在为分离的HEAD添加新的提交的时候你应该创建一个新的分支*
和git reset不一样的是，git checkout没有移动这些分支。


Revert
相比git reset，它不会改变现在的提交历史。因此，git revert可以用在公共分支上，git reset应该用在私有分支上。
你也可以把git revert当作撤销已经提交的更改，而git reset HEAD用来撤销没有提交的更改。
reset 是在正常的commit历史中,删除了指定的commit,这时HEAD是向后移动了,而revert是在正常的commit历史中再commit一次,只不过是反向提交,他的HEAD 是一直向前的，因此此次操作之前和之后的commit和history都会保留


|命令|作用域|常用情景|
|-|-|-|
git reset|    提交层面|    在私有分支上舍弃一些没有提交的更改
git reset|    文件层面|    将文件从缓存区中移除
git checkout|    提交层面|    切换分支或查看旧版本
git checkout|    文件层面|    舍弃工作目录中的更改
git revert|    提交层面|    在公共分支上回滚更改
git revert|    文件层面|    （然而并没有）

---
#### Github

**创建**

![2500c89b345be3a0c75c3201b0f1cd51.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1294)@w=500

如果我们要把一个本地的项目直接推送到GitHub，就不要选中上图中的"Initialize this repository with a README"选项。否则，GitHub就会直接创建一个空项目.

![ad2e81f9fc2d33b1507910b87733a75c.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1296)@w=500

第三种是把一个已有的由其它版本管理工具管理的项目，移植到Github。


**Pull Request**
>假设一个是项目的创建者Host，另一个，则是使用者User。
1.创建
这部分操作，我们都是以User身份完成的。
为了给github-demo贡献代码，我们要先在github-demo的项目页面，点击右上角的Fork，把它复制到自己的仓库。这样，原始的项目中，Fork数字就会变成1,而User自己的GitHub项目中，就会多出来一个github-demo
```swift
git clone https://github.com/user/github-demo.git\github-demo
```
克隆到本地修改添加相关源文件
```swift
git add .
git commit -m "Display my information"
git push -u origin master
```
把自己的改动推送到了自己Fork出来的仓库,为了把这个改动推送到原始的仓库，我们得点击页面上的New pull request按钮，创建一个PR：

![7d3092f2ce9f158a45073cc8e65ffaa6.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1299)@w=400

在这个页面上，base fork表示我们要请求合并改动的原始仓库，head fork表示我们自己克隆出来修改的仓库。确认好合并信息之后，就点击Create pull request按钮，这时GitHub就会要求我们输入一个合并说明:

![800199c771277f13a466157a4ee70caf.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1300)@w=500

完成后，再点击Create pull request按钮，PR就创建好了

2.处理Pull Request
这时Host的github-demo项目中，就会看到有一个Pull reqests等待我们处理：

![277ec895077465eed558ac7f602ddcc6.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1301)@w=500

点进去，就会看到关于这个PR是否和当前代码有冲突，具体的改动等信息：

![176f8149011ee732edac162f068783cf.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1302)@w=500

如果需要和提交PR的人沟通，就可以在页面下边留言，或者关闭这个PR表示拒绝合并：

![b7c2728f82100810feefd6f24bbfd7ce.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1303)@w=500

如果我们决定接受合并，就可以点击上面绿色的Merge pull request按钮，实际上，这个按钮提供了三个选项：

![96847d9adc32cb20327bf95313c104fa.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1304)@w=500

+ Create a merge commit：表示把这个PR作为一个分支合并，并保留分支上的所有提交记录；
+ Squash and merge：表示只为这次合并保留一个提交记录；
+ Rebase and merge：表示直接把PR中的提交记录合并到base的分支，这里也就是master分支；

---

#### 测试
1. 测试目的：模拟多种可能性，减少错误，增强健壮性，提高稳定性
2. 测试种类：在iOS中的通常分为单元测试和UI测试
3. 单元测试（Unit Test）：对函数进行测试,用来保证每一个类正常工作
4. UI测试（UI Test）：从业务层的角度保证各个业务可以正常工作
5. 测试框架：
+ Unit Test -> Quick\Kiwi\specta
+ UI Test -> KIF appium 基于Client – Server的测试框架。App相当于一个Server，测试代码相当于Client，通过发送JSON来操作APP，测试语言可以是任意的，支持android和iOS。

**FIRST原则**
+ Fast：测试的运行速度要快，这样人们就不介意你运行它们了。
+ Independent/Isolated：一个测试不应当依赖于另一个测试。
+ Repeatable：同一个测试，每次都应当获得相同的结果。外部数据提供者和并发问题会导致间歇性的出错。
+ Self-validating：测试应当是完全自动化的，输出结果要么是 pass 要么是 fail，而不是依靠程序员对日志文件的解释。
+ Timely：理想情况下，测试的编写，应当在编写要测试的产品代码之前。

**开始**
![67fe14ac6c4ce55c44cd5933074a92a1.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1327)@w=400
![996cdc3627e098f9dd8bf847e799d3a6.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1340)@w=400h=400
`Command + U` 运行测试类 (testPerformance)
![2a18b5e98e3e91def2cdf3403820bc1d.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1341)@w=400
+ Baseline 计算标准差的参考值
+ MAX STDD 最大允许的标准差
+ 底部点击1，2…10可以看到每次运行的结果。
+ Edit -> Average -> Accept，来让本次运行的平均值设置为baseline，修改MAX STDD%


|API|解释|
|-|-|
setUp|  继承与XCTestCase 函数测试文件开始执行的时候运行
tearDown|    继承与XCTestCase 测试函数运行完之后执行
testExample|    测试的例子函数
testPerformanceExample|    性能测试
```swift
import XCTest
class testExample: XCTestCase {
var f1: Float?
var f2: Float?
override func setUp() {
super.setUp()
f1 = 10.0
f2 = 20.0
}
override func tearDown() {
super.tearDown()
}
func testExample() {
XCTAssertTrue(f1! + f2! == 30.0)
}
//simpale Test
func testIsPrimenumber()  {
let oddNumber = 5
//There are lot XCTAssert function, you can check it
XCTAssertTrue(isPrimenumber(number: Double(oddNumber)))
}
func isPrimenumber(number:Double) -> Bool{
for No in 1...Int(sqrt(number)) {
if Int(number)/No != 0 {
return true
}
}
return false
}
func testPerformanceExample() {
self.measure {
// 对于性能测试，每一个测试用例每次会运行10次。
}
}
}
```

#### 异步测试
下面一些情况会用到异步测试：
+ 打开文档
+ 在其他线程工作
+ 和服务或者扩展进行交流
+ 网络活动
+ 动画
+ UI测试的一些条件

#### 代码覆盖率
选择Target，然后选择Test模块，然后勾选Gather coverage data
![a3a69005798fb8f8573924cc91ad5954.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1333)


#### 网络层的测试


---
**用`XCTAssert`测试模型**
导入项目模块
@testable import XXXXXX

![22791bce78bf29f9beeca4763e38eab7.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1331)@w=8000
![86bc384b0d43345e5afbfe4ca4204ae8.png](evernotecid://8E9F489F-CC19-4F57-906F-93B470B7AF4A/appyinxiangcom/5436588/ENResource/p1332)@w=8000

|API|解释|
|-|-|
|`XCTFail(format…)`|生成一个失败的测试|
|`XCTAssertNil(a1, format...)`|为空判断，a1为空时通过，反之不通过|
|`XCTAssertNotNil(a1, format…)`|不为空判断，a1不为空时通过，反之不通过|
|`XCTAssert(expression, format...)`|当expression求值为TRUE时通过|
|`XCTAssertTrue(expression, format...)`|当expression求值为TRUE时通过|
|`XCTAssertFalse(expression, format...)`|当expression求值为False时通过|
|`XCTAssertEqualObjects(a1, a2, format...)`|判断相等，[a1 isEqual:a2]值为TRUE时通过，其中一个不为空时，不通过|
|`XCTAssertNotEqualObjects(a1, a2, format...)`|判断不等，[a1 isEqual:a2]值为False时通过|
|`XCTAssertEqual(a1, a2, format...)`|判断相等（当a1和a2是 C语言标量、结构体或联合体时使用, 判断的是变量的地址，如果地址相同则返回TRUE，否则返回NO）|
|`XCTAssertNotEqual(a1, a2, format...)`|判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）|
|`XCTAssertEqualWithAccuracy(a1, a2, accuracy, format...)`|判断相等，（double或float类型）提供一个误差范围，当在误差范围（+/-accuracy）以内相等时通过测试|
|`XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format...)`|判断不等，（double或float类型）提供一个误差范围，当在误差范围以内不等时通过测试|
|`XCTAssertThrows(expression, format...)`|异常测试，当expression发生异常时通过；反之不通过|
|`XCTAssertThrowsSpecific(expression, specificException, format...)`|异常测试，当expression发生specificException异常时通过；反之发生其他异常或不发生异常均不通过|
|`XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format...)`|异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过|
|`XCTAssertNoThrow(expression, format…)`|异常测试，当expression没有发生异常时通过测试|
|`XCTAssertNoThrowSpecific(expression, specificException, format...)`|异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过|
|`XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format...)`|异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过|


