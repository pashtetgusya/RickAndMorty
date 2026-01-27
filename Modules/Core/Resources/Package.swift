// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Resources",
    products: [
        .library(
            name: "Resources",
            targets: ["Resources"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Resources",
            path: ".",
            sources: ["Sources"],
            resources: [.process("Resources/Assets")]
        )
    ]
)
