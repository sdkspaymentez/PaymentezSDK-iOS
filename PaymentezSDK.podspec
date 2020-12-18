#
# Be sure to run `pod lib lint PaymentezSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PaymentezSDK'
  s.version          = '0.3.1'
  s.summary          = 'Paymentez Order Ahead SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'Paymentez Order Ahead SDK'
                       DESC

  s.homepage         = 'https://github.com/paymentez/order_ahead_sdk_ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sdkspaymentez' => 'sdks@paymentez.com' }
  s.source           = { :git => 'https://github.com/paymentez/order_ahead_sdk_ios', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.4'

  s.source_files = 'Source/**/*.{swift,xib,xcassets}'
  s.resources = "Source/Controllers/Resources/**/*.xcassets"
  s.swift_version = '5.0'
  # s.resource_bundles = {
  #   'PaymentezSDK' => ['PaymentezSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AlamofireImage', '~> 4.1'
  s.dependency 'XLPagerTabStrip', '~> 9.0'
end
