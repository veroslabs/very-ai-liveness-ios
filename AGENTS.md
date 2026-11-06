# AGENTS.md — very-ai-liveness-ios

Prebuilt binary distribution of the VeryAILiveness iOS SDK (v1.1.1).
CocoaPods trunk (`VeryAILiveness`) and this repository's tags (Swift Package
Manager) are both canonical. Every release regenerates this repository except
`.github/` and `.markdownlint.jsonc`, so an edit here does not survive the
next release; do not hand-edit the xcframework.

## Layout

- `VeryAILiveness.xcframework` — one dynamic framework, device (arm64) and
  arm64 simulator slices. It carries no models: the SDK downloads them on
  first use and checks their SHA-256.
- `Sources/VeryAILiveness/Exports.swift` — SPM wrapper target
  `VeryAILivenessWrapper` (`@_exported import VeryAILiveness`).
- `Package.swift` — swift-tools 5.7, iOS 13.0. Products
  `VeryAILiveness` and `VeryAILivenessBundled`, both the same binary.
- `VeryAILiveness.podspec` — subspecs `Core` (default) and `Bundled`, which
  only depends on `Core`.

## Release invariants

- Each release is one commit on `main` plus the tag `1.1.1`; tags never move.
- `1.1.1` appears in the podspec `s.version` and `:tag`, the README's
  install lines and this file; a release updates all of them together.
- `VeryAILivenessBundled` and `VeryAILiveness/Bundled` stay so existing
  manifests resolve.

## Testing and CI

- No automated tests. The check needs a camera: run it on a device.
- CI only lints Markdown: `npx markdownlint-cli2 "**/*.md"`.
