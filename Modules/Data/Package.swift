// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        )
    ],
    dependencies: [
        .package(path: "../Core/NetWork"),
        .package(path: "../Core/Storage")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                "NetWork",
                "Storage"
            ]
        )
    ]
)
