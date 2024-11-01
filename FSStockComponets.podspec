#
# Be sure to run `pod lib lint FSStockComponets.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FSStockComponets'
  s.version          = '0.1.0'
  s.summary          = 'A short description of FSStockComponets.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhangzhongyan/FSStockComponets'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '张忠燕' => '749994100@qq.com' }
  s.source           = { :git => 'https://github.com/zhangzhongyan/FSStockComponets.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FSStockComponets/Classes/**/*'
  
  s.resource = 'FSStockComponets/Assets/FSStockComponents.bundle'
  s.requires_arc = true

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Masonry'
  s.dependency 'YYCategories'
  s.dependency 'MJExtension'
  s.dependency 'FSOCCategories/NSString+FSSize'
  s.dependency 'FSOCUtils/SizeScalieUtils'
  s.dependency 'FSOCUtils/DeviceUtils'

end
