#
# Be sure to run `pod lib lint LinioPayTokenizer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LinioPayTokenizer'
  s.version          = '0.1.0'
  s.summary          = 'LinioPay Tokenizer is the IOS library interface to get customer’s credit card information in a secure way.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
LinioPay Tokenizer is the IOS library interface to get customer’s credit card information in a secure way. It allows you to set a predetermined
                       DESC

  s.homepage         = 'https://github.com/LinioIT/pay-tokenizer-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'omargon' => 'omargon@gmail.com' }
  s.source           = { :git => 'https://github.com/linioIT/pay-tokenizer-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  # s.ios.deployment_target = '8.0'

  s.source_files = 'LinioPayTokenizer/Classes/**/*'

  # s.resource_bundles = {
  #   'LinioPayTokenizer' => ['LinioPayTokenizer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
