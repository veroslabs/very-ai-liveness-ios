# VeryAILiveness — iOS distribution

Prebuilt binary distribution of the VeryAILiveness palm-liveness SDK for iOS.
Source code lives in [veroslabs/very-mobile-sdk](https://github.com/veroslabs/very-mobile-sdk).

## Install (CocoaPods)

```ruby
pod 'VeryAILiveness'              # slim — model downloads on first scan (~5–15 s)
pod 'VeryAILiveness/Bundled'      # ships ~8 MB packed_data.bin in the SDK
```

## Install (SPM)

```swift
.package(url: "https://github.com/veroslabs/very-ai-liveness-ios.git", from: "1.0.39")
```

Use `VeryAILivenessBundled` for bundled mode.
