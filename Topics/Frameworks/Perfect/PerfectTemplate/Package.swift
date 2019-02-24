// swift-tools-version:4.0
import PackageDescription
let package = Package(
	name: "PerfectDemo",
	products: [
        .executable(name: "PerfectTemplate", targets: ["PerfectTemplate"])
    ],
	dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(url:"https://github.com/PerfectlySoft/Perfect-MySQL.git", from: "3.0.0")
        ],
	targets: [
        .target(name: "PerfectTemplate", dependencies: ["PerfectHTTPServer", "PerfectMySQL"])
    ]
)
// 添加依赖后 swift package generate-xcodeproj 
