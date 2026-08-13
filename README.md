# VeryAILiveness — iOS distribution

Prebuilt binary distribution of the VeryAILiveness palm-liveness SDK for iOS.
Source code lives in [veroslabs/very-mobile-sdk](https://github.com/veroslabs/very-mobile-sdk).

A liveness check opens a single-shot palm scan that confirms a live human
palm. The flow makes two backend calls (issue nonce on entry, record
outcome on exit) and produces a pass/fail `VeryResult` — no enrollment,
no verification, no signed token.

## Install — CocoaPods (recommended)

```ruby
pod 'VeryAILiveness'           # slim — model downloads on first scan (~5–15 s)
pod 'VeryAILiveness/Bundled'   # ships ~8 MB packed_data.bin in the framework
```

## Install — Swift Package Manager

```swift
.package(url: "https://github.com/veroslabs/very-ai-liveness-ios.git", from: "1.0.65")
```

Two product names are exposed:

- `VeryAILiveness` — slim (model downloads on first scan).
- `VeryAILivenessBundled` — ships the model inside the framework.

## Install — Manual XCFramework

1. Drag both `VeryAILiveness.xcframework` and `PalmAPISaas.xcframework` into your Xcode project.
2. **General → Frameworks, Libraries, and Embedded Content** — set both to **Embed & Sign**.
3. **Build Settings → LD_RUNPATH_SEARCH_PATHS** — ensure `@executable_path/Frameworks` is present (default for new projects).
4. Add the system frameworks the SDK depends on (CocoaPods / SPM auto-link these; manual integration must add them):
   - `AVFoundation.framework`
   - `CoreImage.framework`
   - `CoreMedia.framework`
   - `CoreVideo.framework`
   - `CryptoKit.framework`
   - `QuartzCore.framework`

Manual integration is slim by default. For bundled mode, also drop
`packed_data.bin` (shipped alongside the xcframeworks) into your app
target's resources.

## Project requirements

| Setting | Value |
|---|---|
| Minimum deployment target | iOS 13.0 |
| Swift language version | 5.0+ |
| Enable Modules | Yes |
| `Info.plist` | Add `NSCameraUsageDescription` |

Liveness uses the device camera and the on-device PalmID native
library, neither of which work in the Simulator. Test on a physical
device.

## Quickstart

```swift
import VeryAILiveness

let config = VeryLivenessConfig(sdkKey: "your-sdk-key")

VeryAILiveness.check(from: viewController, config: config) { result in
    DispatchQueue.main.async {
        switch result.code {
        case "success":
            // liveness passed
            break
        case "cancelled":
            // user dismissed the page
            break
        default:
            // result.error / result.errorMessage carry the failure detail
            break
        }
    }
}
```

## Documentation

**https://very.org/docs/liveness-sdk/ios**

The full guide is the single source of truth for everything beyond the
snippet above:

- `VeryLivenessConfig` reference — theming, language, and the
  success / error pages.
- Privacy disclosure — the `privacyMessage` partner copy and its
  inline `<a href>` link.
- `VeryResult` codes and error handling.
- Presentation styles.
- Slim vs. bundled asset loading.
- Network endpoints to allowlist.

Docs track the latest release. If you are pinned to an older tag, treat
this README's install coordinates as authoritative and the docs as
describing a possibly newer API.

## Notes

- `VeryAILiveness.xcframework` depends on `PalmAPISaas.xcframework` at runtime. Both must be embedded — embedding only VeryAILiveness will crash with `dyld: Library not loaded: @rpath/PalmAPISaas.framework/PalmAPISaas`.
- Both xcframeworks include simulator slices for development. The native palm library only runs on device, so production builds can strip the simulator slice from `PalmAPISaas` if app size matters.
