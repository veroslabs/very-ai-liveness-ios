// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "VeryAILiveness",
    platforms: [.iOS(.v13)],
    products: [
        // Default — slim (model downloads at first scan, mirrors the
        // CocoaPods Core subspec default).
        .library(name: "VeryAILiveness",        targets: ["VeryAILivenessWrapper"]),
        // Bundled — ships ~8 MB packed_data.bin inside the SDK so the
        // first scan does not block on CDN download.
        .library(name: "VeryAILivenessBundled", targets: ["VeryAILivenessWrapper", "VeryAILivenessBundledModel"]),
    ],
    targets: [
        .target(
            name: "VeryAILivenessWrapper",
            dependencies: ["VeryAILivenessBinary", "PalmAPISaas"],
            path: "Sources/VeryAILiveness"
        ),
        .target(
            name: "VeryAILivenessBundledModel",
            path: "BundledModel",
            resources: [.process("packed_data.bin")]
        ),
        .binaryTarget(name: "VeryAILivenessBinary", path: "VeryAILiveness.xcframework"),
        .binaryTarget(name: "PalmAPISaas",          path: "PalmAPISaas.xcframework"),
    ]
)
