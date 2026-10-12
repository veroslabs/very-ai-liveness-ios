# AGENTS.md — very-ai-liveness-ios

Binary distribution repo for the VeryAILiveness iOS SDK (v1.0.65). SDK source
lives in `veroslabs/very-mobile-sdk`; do not hand-edit the xcframeworks here.

## Layout

- `VeryAILiveness.xcframework`, `PalmAPISaas.xcframework` — prebuilt. `PalmAPISaas` is a runtime dependency; both must be embedded.
- `Sources/VeryAILiveness/Exports.swift` — SPM wrapper target `VeryAILivenessWrapper` (`@_exported import VeryAILiveness`).
- `BundledModel/` — `packed_data.bin` plus `BundleAccessor.swift` (`@objc(VerySDKBundledModelBundle)`, looked up at runtime via `NSClassFromString`). SPM target `VeryAILivenessBundledModel`.
- `Package.swift` — swift-tools 5.7, iOS 13. Products: `VeryAILiveness` (slim), `VeryAILivenessBundled`.
- `VeryAILiveness.podspec` — subspecs `Core` (default, slim) and `Bundled` (resource-only).

## Release invariants

- Keep the version in sync: podspec `s.version`, podspec `:tag`, README SPM `from:` line.
- The `Bundled` subspec's `resource_bundle` name must stay `VerySDK_BundledModel`; the CocoaPods lookup in `BundleAccessor.swift` searches for that bundle name, so renaming it silently disables bundled mode.
- CocoaPods does not compile `BundleAccessor.swift` (the `Bundled` subspec is resource-only to avoid module shadowing); SPM does.

## Testing and CI

- No tests. The SDK needs a physical device (the native palm library does not run in the Simulator).
- CI only lints Markdown: `npx markdownlint-cli2 "**/*.md"`.
