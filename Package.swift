// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let postgres: Target.Dependency = .product(name: "PostgresNIO", package: "postgres-nio")
let tca: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let vapor: Target.Dependency = .product(name: "Vapor", package: "vapor")
let vaporRouting: Target.Dependency = .product(name: "VaporRouting", package: "vapor-routing")
let urlRouting: Target.Dependency = .product(name: "URLRouting", package: "swift-url-routing")
let tagged: Target.Dependency = .product(name: "Tagged", package: "swift-tagged")
let kingfisher: Target.Dependency = .product(name: "Kingfisher", package: "Kingfisher")
let dependencies: Target.Dependency = .product(name: "Dependencies", package: "swift-composable-architecture")

var swiftSettings: [SwiftSetting] = [
    .unsafeFlags([
        "-Xfrontend", "-warn-concurrency",
        "-Xfrontend", "-enable-actor-data-race-checks",
    ])
]

let package = Package(
    name: "Webshop",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ApiClient",
            targets: ["ApiClient"]),
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "Boardgame",
            targets: ["Boardgame"]),
        .library(
            name: "BoardgameService",
            targets: ["BoardgameService"]),
        .library(
            name: "CheckoutFeature",
            targets: ["CheckoutFeature"]),
        .library(
            name: "CartModel",
            targets: ["CartModel"]),
        .library(
            name: "CartService",
            targets: ["CartService"]),
        .library(
            name: "Database",
            targets: ["Database"]),
        .library(
            name: "DatabaseBoardgameClient",
            targets: ["DatabaseBoardgameClient"]),
        .library(
            name: "DatabaseCartClient",
            targets: ["DatabaseCartClient"]),
        .library(
            name: "DatabaseProductClient",
            targets: ["DatabaseProductClient"]),
        .library(
            name: "DatabaseUserClient",
            targets: ["DatabaseUserClient"]),
        .library(
            name: "DatabaseWarehouseClient",
            targets: ["DatabaseWarehouseClient"]),
        .library(
            name: "FavoritesClient",
            targets: ["FavoritesClient"]),
        .library(
            name: "HomeFeature",
            targets: ["HomeFeature"]),
        .library(
            name: "JSONClients",
            targets: ["JSONClients"]),
        .library(
            name: "JWT",
            targets: ["JWT"]),
        .library(
            name: "LoginFeature",
            targets: ["LoginFeature"]),
        .library(
            name: "MainFeature",
            targets: ["MainFeature"]),
        .library(
            name: "OnboardingFeature",
            targets: ["OnboardingFeature"]),
        .library(
            name: "FavoriteFeature",
            targets: ["FavoriteFeature"]),
        .library(
            name: "NavigationBar",
            targets: ["NavigationBar"]),
        .library(
            name: "Product",
            targets: ["Product"]),
        .library(
            name: "ProductViews",
            targets: ["ProductViews"]),
        .library(
            name: "ProductService",
            targets: ["ProductService"]),
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
            name: "StyleGuide",
            targets: ["StyleGuide"]),
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
            name: "UserService",
            targets: ["UserService"]),
        .library(
            name: "UserLocalSettingsFeature",
            targets: ["UserLocalSettingsFeature"]),
        .library(
            name: "Warehouse",
            targets: ["Warehouse"]),
        .library(
            name: "WarehouseService",
            targets: ["WarehouseService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.11.1"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.47.1"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.66.1"),
        .package(url: "https://github.com/pointfreeco/vapor-routing", from: "0.1.1"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.7.0"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.3.1"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.4.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ApiClient",
            dependencies: [
                "SiteRouter",
                dependencies,
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
                name: "Boardgame",
                dependencies: [
                    tagged,
                ],
                swiftSettings: swiftSettings
            ),
        .target(
            name: "BoardgameService",
            dependencies: [
                "DatabaseBoardgameClient",
                "SiteRouter",
                dependencies,
                vapor,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "CartModel",
            dependencies: [
                "Product",
                tagged,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "CartService",
            dependencies: [
                "DatabaseCartClient",
                "SiteRouter",
                dependencies,
                vapor,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "CheckoutFeature",
            dependencies: [
                tca,
                "CartModel",
                "Product",
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Database",
            dependencies: [
                postgres,
                vapor,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DatabaseBoardgameClient",
            dependencies: [
                "Boardgame",
                "Database",
                dependencies,
                postgres,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DatabaseCartClient",
            dependencies: [
                "CartModel",
                "Database",
                dependencies,
                postgres,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DatabaseUserClient",
            dependencies: [
                "Database",
                "UserModel",
                dependencies,
                postgres,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DatabaseProductClient",
            dependencies: [
                "Product",
                "Database",
                dependencies,
                postgres,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DatabaseWarehouseClient",
            dependencies: [
                "Database",
                "Warehouse",
                dependencies,
                postgres,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FavoritesClient",
            dependencies: [
                dependencies,
                "JSONClients",
                "Product",
                "UserDefaultsClient",
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FavoriteFeature",
            dependencies: [
                "ApiClient",
                "CartModel",
                "FavoritesClient",
                "Product",
                "ProductViews",
                "StyleGuide",
                "SiteRouter",
                "UserModel",
                tca,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                "ApiClient",
                "Boardgame",
                "CartModel",
                "FavoritesClient",
                "NavigationBar",
                "ProductViews",
                "SiteRouter",
                "StyleGuide",
                "UserDefaultsClient",
                kingfisher,
                tca,
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["HomeFeature"]),
        
            .target(
                name: "MainFeature",
                dependencies: [
                    "CartModel",
                    "CheckoutFeature",
                    "HomeFeature",
                    "FavoriteFeature",
                    "Product",
                    tca,
                ],
                swiftSettings: swiftSettings
            ),
        .target(
            name: "JSONClients",
            dependencies: [
                dependencies
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "JWT",
            dependencies: [
                "JSONClients",
                dependencies,
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MainFeatureTests",
            dependencies: ["MainFeature"]),
        
            .target(
                name: "OnboardingFeature",
                dependencies: [
                    "LoginFeature",
                    "SignUpFeature",
                    "TermsAndConditionsFeature",
                    "UserLocalSettingsFeature",
                    "UserModel",
                    tca,
                ],
                swiftSettings: swiftSettings
            ),
        .target(
            name: "NavigationBar",
            dependencies: [
                "ProductViews",
                "StyleGuide",
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "OnboardingFeatureTests",
            dependencies: ["OnboardingFeature"]),
        
            .executableTarget(name: "runner", dependencies: [.target(name: "Server")]),
        
            .target(
                name: "Product",
                dependencies: [
                    "Boardgame",
                    tagged,
                ],
                swiftSettings: swiftSettings
            ),
        .target(
            name: "ProductViews",
            dependencies: [
                "Product",
                "StyleGuide",
                kingfisher,
                tca,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "ProductService",
            dependencies: [
                "DatabaseProductClient",
                "SiteRouter",
                "Product",
                dependencies,
                vapor,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Server",
            dependencies: [
                "Database",
                "CartModel",
                "CartService",
                "JWT",
                "Product",
                "BoardgameService",
                "SiteRouter",
                "ProductService",
                "UserModel",
                "UserService",
                "WarehouseService",
                postgres,
                tca,
                vapor,
                vaporRouting,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "LoginFeature",
            dependencies: [
                "StyleGuide",
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
            name: "LoginFeatureTests",
            dependencies: ["LoginFeature"]),
        
            .target(
                name: "SignUpFeature",
                dependencies: [
                    "StyleGuide",
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
                    "Boardgame",
                    "CartModel",
                    "UserModel",
                    "Warehouse",
                    tca,
                    urlRouting,
                ],
                swiftSettings: swiftSettings
            ),
        
        
            .target(
                name: "SplashFeature",
                dependencies: [
                    tca,
                    "StyleGuide",
                    "UserDefaultsClient",
                ],
                swiftSettings: swiftSettings
            ),
        .testTarget(
            name: "SplashFeatureTests",
            dependencies: ["SplashFeature"]),
        
            .target(
                name: "StyleGuide",
                dependencies: [
                ],
                swiftSettings: swiftSettings
            ),
        .target(
            name: "TermsAndConditionsFeature",
            dependencies: [
                "SiteRouter",
                "StyleGuide",
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
                "Product",
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
                ],
                swiftSettings: swiftSettings
            ),
        .target(
            name: "UserService",
            dependencies: [
                "DatabaseUserClient",
                "SiteRouter",
                "UserModel",
                dependencies,
                vapor,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "UserLocalSettingsFeature",
            dependencies: [
                "Boardgame",
                "StyleGuide",
                "UserModel",
                tca,
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "UserLocalSettingsFeatureTests",
            dependencies: ["UserLocalSettingsFeature"]),
        .target(
            name: "Warehouse",
            dependencies: [
                "Product",
                tagged,
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "WarehouseService",
            dependencies: [
                "DatabaseWarehouseClient",
                "SiteRouter",
                "Product",
                dependencies,
                vapor,
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
