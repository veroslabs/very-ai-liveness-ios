// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "VeryAILiveness",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "VeryAILiveness",        targets: ["VeryAILivenessWrapper"]),
        // Kept for existing manifests: the same binary as VeryAILiveness
        // (the SDK downloads its models on first use).
        .library(name: "VeryAILivenessBundled", targets: ["VeryAILivenessWrapper"]),
    ],
    targets: [
        .target(
            name: "VeryAILivenessWrapper",
            dependencies: ["VeryAILivenessBinary"],
            path: "Sources/VeryAILiveness",
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreImage"),
                .linkedLibrary("c++"),
            ]
        ),
        .binaryTarget(name: "VeryAILivenessBinary", path: "VeryAILiveness.xcframework"),
    ]
)
