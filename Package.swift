// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-ast-parser",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "swift-ast-parser", targets: ["swift-ast-parser"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0") // Swift 5.9
    ],
    targets: [
        .executableTarget(
            name: "swift-ast-parser",
            dependencies: [
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
            ],
            path: "Sources"
        ),
    ]
)
