// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "DependencyInjection",
    products: [
        .library(
            name: "DependencyInjection",
            targets: ["DependencyInjection"]
        )
    ],
    dependencies: [
        .package(path: "../ToolBox")
    ],
    targets: [
        .target(
            name: "DependencyInjection",
            dependencies: ["ToolBox"]
        )
    ]
)
