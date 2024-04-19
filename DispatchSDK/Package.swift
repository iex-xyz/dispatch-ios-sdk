// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DispatchSDK",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DispatchSDK",
            targets: ["DispatchSDK"]),
    ],
    targets: [
        .target(
            name: "DispatchSDK"
        ),
        .testTarget(
            name: "DispatchSDKTests",
            dependencies: ["DispatchSDK"]),
    ]
)
