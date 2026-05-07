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
.package(url: "https://github.com/veroslabs/very-ai-liveness-ios.git", from: "1.0.42")
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

## Usage

```swift
import VeryAILiveness

// Optional — kicks off the model prefetch and verifies camera/RAM.
guard VeryAILiveness.isSupported() else {
    // device unsupported, fall back
    return
}

let config = VeryLivenessConfig(
    sdkKey: "your-sdk-key",       // required — issued by Very
    themeMode: "dark",            // "light" or "dark"
    language: "en",               // optional — ISO 639-1, defaults to system locale
    livenessMode: .touch,         // .touch (default) or .gesture
    debugLogging: true            // recommended during integration
)

VeryAILiveness.check(
    from: viewController,
    config: config,
    presentationStyle: .modal     // .modal (default) or .push
) { result in
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

`VeryLivenessConfig` is a slim subset of the full SDK's `VeryConfig` —
no `userId` because liveness binds no user identity, but `sdkKey` is
required to authenticate the backend session calls.

`VeryResult.code` is one of `"success"`, `"cancelled"`, or `"error"`.
On non-success, `result.error` carries an SDK error code and
`result.errorMessage` carries a localized human-readable message.

## Asset loading

This distribution ships in **slim mode** by default — `packed_data.bin`
(~8 MB) is downloaded from CDN on first scan and cached under
`Application Support/`; subsequent launches use the cache. Plan for a
loading state on the first scan (5–15 s on typical networks).

Use `pod 'VeryAILiveness/Bundled'` (CocoaPods) or
`VeryAILivenessBundled` (SPM) to bundle the model in your binary
instead — first scan is instant, app size grows by ~8 MB.

## Network endpoints

If your network restricts egress, allowlist the following:

| Purpose | URL |
|---|---|
| Liveness session create | `https://api.very.org/v1/sdk/liveness-sessions` |
| Liveness result POST | `https://api.very.org/v1/sdk/liveness-sessions/{id}/result` |
| Model download (primary) | `https://assets.very.org/sdk/v2/packed_data.bin` |
| Model download (backup) | `https://r2.assets.very.org/sdk/packed_data.bin` |

The result POST is fire-and-forget — it doesn't block the host
completion. The model download path is unused in bundled mode after
the first install.

## Notes

- `VeryAILiveness.xcframework` depends on `PalmAPISaas.xcframework` at runtime. Both must be embedded — embedding only VeryAILiveness will crash with `dyld: Library not loaded: @rpath/PalmAPISaas.framework/PalmAPISaas`.
- Both xcframeworks include simulator slices for development. The native palm library only runs on device, so production builds can strip the simulator slice from `PalmAPISaas` if app size matters.
