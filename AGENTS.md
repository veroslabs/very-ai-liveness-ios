# AGENTS.md — very-ai-liveness-ios

Prebuilt binary distribution of the VeryAILiveness iOS SDK (v1.1.2).
This repository's tags (Swift Package Manager) and the `VeryAILiveness`
podspec in `veroslabs/very-cocoapods-specs` (CocoaPods; trunk up to 1.1.1) are both
canonical. Every release regenerates this repository except
`.github/` and `.markdownlint.jsonc`, so an edit here does not survive the
next release; do not hand-edit the xcframework.

## Layout

- `VeryAILiveness.xcframework` — one dynamic framework, device (arm64) and
  simulator (arm64, x86_64) slices; the simulator never scans, and its x86_64
  code carries no inference runtime. It carries no models: the SDK downloads
  them on first use and checks their SHA-256.
- `Sources/VeryAILiveness/Exports.swift` — SPM wrapper target
  `VeryAILivenessWrapper` (`@_exported import VeryAILiveness`).
- `Package.swift` — swift-tools 5.7, iOS 13.0. Products
  `VeryAILiveness` and `VeryAILivenessBundled`, both the same binary.
- `VeryAILiveness.podspec` — subspecs `Core` (default) and `Bundled`, which
  only depends on `Core`.

## Release invariants

- Each release is one commit on `main` plus the tag `1.1.2`; tags never move.
- `1.1.2` appears in the podspec `s.version` and `:tag`, the README's
  install lines and this file; a release updates all of them together.
- `VeryAILivenessBundled` and `VeryAILiveness/Bundled` stay so existing
  manifests resolve.

## Testing and CI

- No automated tests. The check needs a camera: run it on a device.
- CI only lints Markdown: `npx markdownlint-cli2 "**/*.md"`.
