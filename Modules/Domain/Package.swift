// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        )
    ],
    dependencies: [
        .package(path: "../Data")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                "Data"
            ]
        )
    ]
)
