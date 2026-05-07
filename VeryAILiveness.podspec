Pod::Spec.new do |s|
  s.name             = 'VeryAILiveness'
  s.version          = '1.0.42'
  s.summary          = 'Palm-biometric liveness check'
  s.description      = 'Single-shot palm liveness check for iOS — no API calls.'
  s.homepage         = 'https://very.org'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'Very Mobile Inc.' => 'mail@very.org' }
  s.source           = { :git => 'https://github.com/veroslabs/very-ai-liveness-ios.git', :tag => '1.0.42' }
  s.platform         = :ios, '13.0'
  s.swift_version    = '5.0'

  s.default_subspecs = ['Core']  # slim by default — model downloads on first scan

  s.subspec 'Core' do |core|
    core.vendored_frameworks = 'VeryAILiveness.xcframework', 'PalmAPISaas.xcframework'
  end

  s.subspec 'Bundled' do |b|
    b.dependency 'VeryAILiveness/Core'
    b.source_files    = 'BundledModel/*.swift'
    # Must match the lookup hardcoded in BundleAccessor.swift
    # ('VerySDK_BundledModel'); using a different name silently
    # disables bundled mode.
    b.resource_bundle = { 'VerySDK_BundledModel' => ['BundledModel/packed_data.bin'] }
  end
end
