// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Navigation",
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection")
    ],
    targets: [
        .target(
            name: "Navigation",
            dependencies: ["DependencyInjection"]
        )
    ]
)
