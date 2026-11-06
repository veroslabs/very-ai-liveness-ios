Pod::Spec.new do |s|
  s.name             = 'VeryAILiveness'
  s.version          = '1.1.1'
  s.summary          = 'Palm-biometric liveness check'
  s.description      = 'Palm liveness check for iOS, evaluated by Very from evidence the device collects.'
  s.homepage         = 'https://very.org'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'Veros Inc.' => 'mail@very.org' }
  s.source           = { :git => 'https://github.com/veroslabs/very-ai-liveness-ios.git', :tag => '1.1.1' }
  s.platform         = :ios, '13.0'
  s.swift_version    = '5.0'

  s.default_subspecs = ['Core']

  s.subspec 'Core' do |core|
    core.vendored_frameworks = 'VeryAILiveness.xcframework'
    core.frameworks          = 'AVFoundation', 'UIKit', 'CoreImage'
    core.libraries           = 'c++'
  end

  # Kept so `pod 'VeryAILiveness/Bundled'` still resolves. It installs the
  # same binary as Core: the SDK downloads its models on first use.
  s.subspec 'Bundled' do |b|
    b.dependency 'VeryAILiveness/Core'
  end

  # The simulator slice is arm64 only (the linked LiteRT has no x86_64 one).
  s.pod_target_xcconfig  = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
