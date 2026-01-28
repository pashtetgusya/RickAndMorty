import ProjectDescription

let project = Project(
    name: "RickAndMorty",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    packages: [
        .local(path: "Modules/Core/DependencyInjection"),
        .local(path: "Modules/Core/Navigation"),
        .local(path: "Modules/Core/NetWork"),
        .local(path: "Modules/Core/Resources"),
        .local(path: "Modules/Core/Storage"),
        .local(path: "Modules/Core/ToolBox"),
        .local(path: "Modules/Core/UIComponents"),
        .local(path: "Modules/Data"),
        .local(path: "Modules/Domain"),
        .local(path: "Modules/Features/Characters")
    ],
    settings: .settings(base: [
        "CURRENT_PROJECT_VERSION": "1",
        "MARKETING_VERSION": "1.0.0"
    ]),
    targets: [
        .target(
            name: "RickAndMorty",
            destinations: [.iPhone],
            product: .app,
            bundleId: "pavel-yarovoi.RickAndMorty",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "UIUserInterfaceStyle": "Light",
                "UILaunchStoryboardName": "LaunchScreen.storyboard",
                "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                "CFBundleDisplayName": "Rick and Morty"
            ]),
            sources: ["Application/Sources/**"],
            resources: ["Application/Resources/**"],
            dependencies: [
                .package(product: "DependencyInjection", type: .runtime, condition: nil),
                .package(product: "Navigation", type: .runtime, condition: nil),
                .package(product: "NetWork", type: .runtime, condition: nil),
                .package(product: "Resources", type: .runtime, condition: nil),
                .package(product: "Storage", type: .runtime, condition: nil),
                .package(product: "ToolBox", type: .runtime, condition: nil),
                .package(product: "UIComponents", type: .runtime, condition: nil),
                .package(product: "Data", type: .runtime, condition: nil),
                .package(product: "Domain", type: .runtime, condition: nil),
                .package(product: "Characters", type: .runtime, condition: nil),
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "RickAndMorty",
            shared: true,
            hidden: false,
            buildAction: .none,
            testAction: .none,
            runAction: .runAction(
                configuration: .configuration("Debug"),
                attachDebugger: true,
                customLLDBInitFile: "",
                preActions: [],
                postActions: [],
                executable: .target("RickAndMorty"),
                arguments: .arguments(
                    environmentVariables: [
                        "OS_ACTIVITY_MODE": .environmentVariable(value: "disable", isEnabled: true)
                    ],
                    launchArguments: []
                ),
                options: .options(
                    language: nil,
                    region: nil,
                    storeKitConfigurationPath: nil,
                    simulatedLocation: .moscow,
                    enableGPUFrameCaptureMode: .default
                ),
                diagnosticsOptions: .options(),
                metalOptions: .options(),
                expandVariableFromTarget: .target("RickAndMorty"),
                launchStyle: .automatically
            ),
            archiveAction: .none,
            profileAction: .none,
            analyzeAction: .none
        ),
    ]
)
