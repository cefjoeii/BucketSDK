#
# Be sure to run `pod lib lint BucketSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BucketSDK'
  s.version          = '1.0'
  s.summary          = 'This is the SDK for Bucket Technologies. This is used for integrations for various different POS Systems.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This is the Bucket SDK. This is where you will be able to create your transactions easier, login with the retailer account easier, and save Bucket Credentials.'

  s.homepage         = 'https://github.com/buckettech/BucketSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ryan' => 'ryan@buckettechnologies.com' }
  s.source           = { :git => 'https://github.com/buckettech/BucketSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  # s.source_files = '*.{swift}'
  s.source_files = 'BucketSDK/Classes/**/*'
  s.swift_version = '4.1'
  
  # s.resource_bundles = {
  #   'BucketSDK' => ['BucketSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'Foundation'
   s.dependency 'KeychainSwift'
   
end
