// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let tca: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")

let package = Package(
    name: "Webshop",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "SplashFeature",
            targets: ["SplashFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "protocol-beta"),
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
                "SplashFeature"
            ]),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]),
        .target(
            name: "SplashFeature",
            dependencies: [tca]),
        .testTarget(
            name: "SplashFeatureTests",
            dependencies: ["SplashFeature"]),
    ]
)
