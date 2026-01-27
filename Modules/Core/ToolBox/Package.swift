// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ToolBox",
    products: [
        .library(
            name: "ToolBox",
            targets: ["ToolBox"]
        )
    ],
    dependencies: [],
    targets: [
        .target(name: "ToolBox")
    ]
)
