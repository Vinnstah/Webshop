// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let postgres: Target.Dependency = .product(name: "PostgresNIO", package: "postgres-nio")
let tca: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let vapor: Target.Dependency = .product(name: "Vapor", package: "vapor")
let vaporRouting: Target.Dependency = .product(name: "VaporRouting", package: "vapor-routing")
let urlRouting: Target.Dependency = .product(name: "_URLRouting", package: "swift-parsing")

var swiftSettings: [SwiftSetting] = [
    .unsafeFlags([
        "-Xfrontend", "-warn-concurrency",
        "-Xfrontend", "-enable-actor-data-race-checks",
    ])
]

let package = Package(
    name: "Webshop",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "MainFeature",
            targets: ["MainFeature"]),
        .library(
            name: "OnboardingFeature",
            targets: ["OnboardingFeature"]),
        .library(
            name: "Server",
            targets: ["Server"]),
        .library(
            name: "SiteRouter",
            targets: ["SiteRouter"]),
        .library(
            name: "SplashFeature",
            targets: ["SplashFeature"]),
        .library(
            name: "URLRoutingClient",
            targets: ["URLRoutingClient"]),
        .library(
            name: "UserDefaultsClient",
            targets: ["UserDefaultsClient"]),
        .library(
            name: "UserModel",
            targets: ["UserModel"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.11.1"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "protocol-beta"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/pointfreeco/vapor-routing", from: "0.1.1"),
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.1.0"),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppFeature",
            dependencies: [
                tca,
                "MainFeature",
                "OnboardingFeature",
                "SplashFeature",
                "URLRoutingClient",
                "UserModel",
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]),
        
            .target(
                name: "MainFeature",
                dependencies: [
                    "UserDefaultsClient",
                    "UserModel",
                    tca,
                ],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "MainFeatureTests",
            dependencies: ["MainFeature"]),
        
            .target(
                name: "OnboardingFeature",
                dependencies: [
                    "SiteRouter",
                    "URLRoutingClient",
                    "UserDefaultsClient",
                    "UserModel",
                    tca,
                    urlRouting,
                ],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "OnboardingFeatureTests",
            dependencies: ["OnboardingFeature"]),
        
            .executableTarget(name: "runner", dependencies: [.target(name: "Server")]),
        
            .target(
                name: "Server",
                dependencies: [
                    "SiteRouter",
                    "UserModel",
                    postgres,
                    vapor,
                    vaporRouting,
                ],
                swiftSettings: swiftSettings
            ),
        
        
            .target(
                name: "SiteRouter",
                dependencies: [
                    "UserModel",
                    tca,
                    urlRouting,
                    vapor,
                    vaporRouting,
                ],
                swiftSettings: swiftSettings
            ),
        
        
            .target(
                name: "SplashFeature",
                dependencies: [
                    tca,
                    "UserDefaultsClient",
                ],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "SplashFeatureTests",
            dependencies: ["SplashFeature"]),
        
            .target(
            name: "URLRoutingClient",
            dependencies: [
                "SiteRouter",
                tca,
                vaporRouting,
            ],
            swiftSettings: swiftSettings
        ),
        
            .target(
                name: "UserDefaultsClient",
                dependencies: [tca],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "UserDefaultsClientTests",
            dependencies: ["UserDefaultsClient"]),
        
        .target(
            name: "UserModel",
            dependencies: [vapor],
            swiftSettings: swiftSettings
        ),
    ]
)
