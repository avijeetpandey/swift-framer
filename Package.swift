// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "framer-swift",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "FramerSwift",
            targets: ["FramerSwift"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FramerSwift",
            dependencies: [],
            path: "Sources/FramerSwift",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "FramerSwiftTests",
            dependencies: ["FramerSwift"],
            path: "Tests/FramerSwiftTests"
        )
    ]
)
