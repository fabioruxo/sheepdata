#
# Be sure to run `pod lib lint SheepData.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SheepData"
  s.version          = "0.3.0"
  s.summary          = "SheepData is a core data framework with ActiveRecord like syntax and lots of sugar"

  s.homepage         = "https://github.com/objectivesheep/SheepData"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'BSD'
  s.author           = { "Fabio Russo" => "fabio@objectivesheep.com" }
  s.source           = { :git => "https://github.com/objectivesheep/SheepData.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/objectivesheep'

  s.platform     = :ios, '7.0'
  s.platform     = :osx, '10.8'
  s.requires_arc = true

  s.source_files = 'SheepData'
  #s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreData'
  # s.dependency 'AFNetworking', '~> 2.3'
end
