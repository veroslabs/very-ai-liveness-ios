# VeryAILiveness — iOS distribution

Prebuilt binary distribution of the VeryAILiveness palm-liveness SDK for iOS.

A check opens a palm scan, collects evidence on the device and submits it to
Very, which decides. Your backend creates each liveness session — the server
secret never ships in the app — and the SDK returns a `VeryLivenessResult` carrying
Very's signed decision.

## Install — CocoaPods

```ruby
pod 'VeryAILiveness', '~> 1.1.2', :source => 'https://github.com/veroslabs/very-cocoapods-specs.git'
```

CocoaPods trunk accepts no new versions, so VeryAILiveness is published to
its own spec repository. `:source` applies to this pod only: your other pods
keep resolving from the sources your Podfile already lists. Without it,
CocoaPods finds nothing newer than 1.1.1.

## Install — Swift Package Manager

```swift
.package(url: "https://github.com/veroslabs/very-ai-liveness-ios.git", from: "1.1.2")
```

Product: `VeryAILiveness`.

`pod 'VeryAILiveness/Bundled'` and the `VeryAILivenessBundled` product still
resolve, to the same binary. The models (about 9.5 MB) are not in the framework:
the SDK downloads them on first use, checks their SHA-256 and keeps them on the
device. Call `VeryAILiveness.prefetch()` early (for example at app start) so the
first scan does not wait for the download.

## Install — manual XCFramework

1. Drag `VeryAILiveness.xcframework` into your Xcode project.
2. **General → Frameworks, Libraries, and Embedded Content** — set it to **Embed & Sign**.
3. Link `AVFoundation`, `CoreImage` and `libc++`.

## Project requirements

| Setting | Value |
|---|---|
| Minimum deployment target | iOS 13.0 |
| `Info.plist` | `NSCameraUsageDescription` |
| Simulator | arm64 and x86_64. Your app builds and runs there, but `isSupported()` is `false` and `check` returns error 6102: the check needs a camera, so test it on a device |

## Quickstart

```swift
import VeryAILiveness

let config = VeryLivenessConfig(sdkKey: "your-sdk-key")
config.sessionProvider = { request, completion in
    // Your backend creates the session with Very (server secret) and returns
    // the response body unchanged.
    myBackend.createLivenessSession(request.body) { data, error in completion(data, error) }
}

VeryAILiveness.check(from: viewController, config: config) { result in
    // result.isSuccess only when Very's signed decision passed;
    // result.signedToken is the receipt for your backend.
}
```

## Upgrading from 1.0.x

1.1.0 evaluates the check on Very's servers: your backend must create each
session (`sessionProvider` is required, or every check fails with 5002) and
verify `result.signedToken`. `scanTimeoutSeconds` is gone and
`touchPolicyVersion` became `multiPointTouch`.
`VeryResult` became `VeryLivenessResult` (`errorType` is a
`VeryLivenessErrorType`), `VeryPresentationStyle` became
`VeryLivenessPresentationStyle` (`.fullScreen`, `.modal`), and
`sdkKey` is set only at initialization. Remove
`PalmAPISaas.xcframework`. Details: `CHANGELOG.md`.

## Documentation

**https://very.org/docs/liveness-sdk/ios**

## Licenses

Proprietary — see `LICENSE`. Third-party components: `THIRD_PARTY_NOTICES.md`.
Changes by version: `CHANGELOG.md`.
