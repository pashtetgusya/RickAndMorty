// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Characters",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Characters",
            targets: ["Characters"]
        )
    ],
    dependencies: [
        .package(path: "../../Core/DependencyInjection"),
        .package(path: "../../Core/Navigation"),
        .package(path: "../../Core/NetWork"),
        .package(path: "../../Core/UIComponents"),
        .package(path: "../../Core/Resources"),
        .package(path: "../../Data"),
        .package(path: "../../Domain"),
        .package(url: "https://github.com/CombineCommunity/CombineCocoa.git", from: "0.4.0")
    ],
    targets: [
        .target(
            name: "Characters",
            dependencies: [
                "DependencyInjection",
                "Navigation",
                "NetWork",
                "UIComponents",
                "Resources",
                "Data",
                "Domain",
                "CombineCocoa"
            ]
        )
    ]
)
