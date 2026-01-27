// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Storage",
            targets: ["Storage"]
        )
    ],
    dependencies: [],
    targets: [
        .target(name: "Storage")
    ]
)
