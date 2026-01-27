// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]
        )
    ],
    dependencies: [
        .package(path: "../Resources"),
        .package(
            url: "https://github.com/CombineCommunity/CombineCocoa.git",
            from: "0.4.0"
        )
    ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: [
                "Resources",
                "CombineCocoa"
            ]
        )
    ]
)
