// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "NetWork",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "NetWork",
            targets: ["NetWork"]
        )
    ],
    dependencies: [
        .package(path: "../ToolBox")
    ],
    targets: [
        .target(
            name: "NetWork",
            dependencies: ["ToolBox"]
        )
    ]
)
