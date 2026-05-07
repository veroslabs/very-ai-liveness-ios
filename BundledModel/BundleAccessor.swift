import Foundation

/// Bridge that lets the main `VerySDK` target locate this auxiliary
/// target's resource bundle without a compile-time dependency.
///
/// The slim SPM distribution (`VerySDKSlim`) compiles WITHOUT this target,
/// so `VerySDK` cannot `import VerySDKBundledModel`. Instead it looks the
/// class up at runtime via `NSClassFromString("VerySDKBundledModelBundle")`
/// — returning the URL when present, nil when slim.
///
/// CocoaPods does not compile this Swift file; its `VerySDK/Bundled` subspec
/// is resource-only so it cannot create a pod target module named `VerySDK`
/// that shadows the vendored binary framework module.
///
/// `@objc(VerySDKBundledModelBundle)` pins the Objective-C name so the
/// runtime lookup works regardless of Swift module mangling.
@objc(VerySDKBundledModelBundle)
public final class VerySDKBundledModelBundle: NSObject {
    @objc public static var modelURL: URL? {
        #if SWIFT_PACKAGE
        return Bundle.module.url(forResource: "packed_data", withExtension: "bin")
        #else
        // CocoaPods: subspec configures `resource_bundle` as
        // "VerySDK_BundledModel", which lands inside the framework.
        let parent = Bundle(for: VerySDKBundledModelBundle.self)
        if let nestedURL = parent.url(forResource: "VerySDK_BundledModel", withExtension: "bundle"),
           let nested = Bundle(url: nestedURL),
           let modelURL = nested.url(forResource: "packed_data", withExtension: "bin") {
            return modelURL
        }
        return parent.url(forResource: "packed_data", withExtension: "bin")
        #endif
    }
}
