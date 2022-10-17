// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let postgres: Target.Dependency = .product(name: "PostgresNIO", package: "postgres-nio")
let tca: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let vapor: Target.Dependency = .product(name: "Vapor", package: "vapor")
let vaporRouting: Target.Dependency = .product(name: "VaporRouting", package: "vapor-routing")
let urlRouting: Target.Dependency = .product(name: "URLRouting", package: "swift-url-routing")

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
            name: "ApiClient",
            targets: ["ApiClient"]),
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "HomeFeature",
            targets: ["HomeFeature"]),
        .library(
            name: "MainFeature",
            targets: ["MainFeature"]),
        .library(
            name: "OnboardingFeature",
            targets: ["OnboardingFeature"]),
        .library(
            name: "ProductsFeature",
            targets: ["ProductsFeature"]),
        .library(
            name: "SignInFeature",
            targets: ["SignInFeature"]),
        .library(
            name: "SignUpFeature",
            targets: ["SignUpFeature"]),
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
            name: "TermsAndConditionsFeature",
            targets: ["TermsAndConditionsFeature"]),
        .library(
            name: "UserDefaultsClient",
            targets: ["UserDefaultsClient"]),
        .library(
            name: "UserModel",
            targets: ["UserModel"]),
        .library(
            name: "UserLocalSettingsFeature",
            targets: ["UserLocalSettingsFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.11.1"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.42.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.66.1"),
        .package(url: "https://github.com/pointfreeco/vapor-routing", from: "0.1.1"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.3.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ApiClient",
            dependencies: [
                "SiteRouter",
                tca,
                urlRouting,
            ],
            swiftSettings: swiftSettings
        ),
        
        .target(
            name: "AppFeature",
            dependencies: [
                tca,
                "MainFeature",
                "OnboardingFeature",
                "SplashFeature",
                "UserModel",
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]),
        .target(
            name: "HomeFeature",
            dependencies: [
                "ApiClient",
                "SiteRouter",
                "UserDefaultsClient",
                "UserModel",
                tca,
            ],
            swiftSettings: swiftSettings
        ),
        
            .target(
                name: "MainFeature",
                dependencies: [
                    "HomeFeature",
                    "ProductsFeature",
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
                    "SignInFeature",
                    "SignUpFeature",
                    "TermsAndConditionsFeature",
                    "UserLocalSettingsFeature",
                    "UserModel",
                    tca,
                ],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "OnboardingFeatureTests",
            dependencies: ["OnboardingFeature"]),
        
            .executableTarget(name: "runner", dependencies: [.target(name: "Server")]),
        
            .target(
                name: "ProductsFeature",
                dependencies: [
                    "ApiClient",
                    "SiteRouter",
                    "UserModel",
                    tca,
                ],
                swiftSettings: swiftSettings
            ),
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
                name: "SignInFeature",
                dependencies: [
                    "SiteRouter",
                    "ApiClient",
                    "UserDefaultsClient",
                    "UserModel",
                    tca,
                    urlRouting,
                ],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "SignInFeatureTests",
            dependencies: ["SignInFeature"]),
        
        .target(
            name: "SignUpFeature",
            dependencies: [
                "UserModel",
                tca,
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SignUpFeatureTests",
            dependencies: ["SignUpFeature"]),
        
        .target(
            name: "SiteRouter",
            dependencies: [
                "UserModel",
                tca,
                urlRouting,
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
                name: "TermsAndConditionsFeature",
                dependencies: [
                    "SiteRouter",
                    "ApiClient",
                    "UserDefaultsClient",
                    "UserModel",
                    tca,
                ],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "TermsAndConditionsFeatureTests",
            dependencies: ["TermsAndConditionsFeature"]),
            .target(
                name: "UserDefaultsClient",
                dependencies: [
                    "UserModel",
                    tca,
                ],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "UserDefaultsClientTests",
            dependencies: ["UserDefaultsClient"]),
        
            .target(
                name: "UserModel",
                dependencies: [
                    postgres,
                              ],
                swiftSettings: swiftSettings
            ),
        .target(
            name: "UserLocalSettingsFeature",
            dependencies: [
                "UserModel",
                tca,
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "UserLocalSettingsFeatureTests",
            dependencies: ["UserLocalSettingsFeature"]),
    ]
)
