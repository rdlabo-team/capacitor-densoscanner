// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorDensoscanner",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapacitorDensoscanner",
            targets: ["DensoScannerPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "DensoScannerPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/DensoScannerPlugin"),
        .testTarget(
            name: "DensoScannerPluginTests",
            dependencies: ["DensoScannerPlugin"],
            path: "ios/Tests/DensoScannerPluginTests")
    ]
)