#
# Be sure to run `pod lib lint BT-Timer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BT-Timer'
  s.version          = '0.1.3'
  s.summary          = 'An off-the-shelf timer/stopwatch to use in your iOS apps'
  
  s.description      = <<-DESC
  'Very easy to use timer/stopwatch to use in iOS apps with any label, All you have to do to link it with a UILabel and fire it'
  DESC
  
  s.homepage         = 'https://github.com/O-labib/BT-Timer'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Omar Labib' => 'o.labib1995@gmail.com' }
  s.source           = { :git => 'https://github.com/O-labib/BT-Timer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  
  s.source_files = 'BT-Timer/Classes/**/*'
  s.frameworks = 'UIKit'
end
