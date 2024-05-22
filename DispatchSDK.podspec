Pod::Spec.new do |s|
  s.name             = 'DispatchSDK'
  s.version          = '1.0.0'
  s.summary          = 'Enable Dispatch’s checkout experiences to be invoked in-app'

  s.description      = <<-DESC
  iOS SDK that allows applications to enable enable Dispatch’s checkout conversion experiences to be invoked in-app
  DESC

  s.homepage         = 'https://github.com/iex-xyz/dispatch-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dispatch Solutions, Inc' => 'stephensilber@gmail.com' }
  s.source           = { :git => 'https://github.com/iex-xyz/dispatch-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version    = '5.5'

  s.source_files = 'Sources/DispatchSDK/Sources/**/*'
  
  s.resource_bundles = {
    'DispatchSDK' => ['Sources/DispatchSDK/Resources/**/*']
  }
end

