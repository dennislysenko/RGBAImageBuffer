Pod::Spec.new do |s|
  s.name             = "RGBAImageBuffer"
  s.version          = "1.0.0"
  s.summary          = "Access UIColor and RGBA data from a UIImage painlessly in Swift"

  s.description      = <<-DESC
Get the UIColor of any pixel in a UIImage or CGImage relatively painlessly in Swift. Normally you have to interface with raw memory to accomplish this, and no one wants to do that. This makes it a (relatively) safe nullable subscript, rather than (relatively) unsafe pointer math.
                       DESC

  s.homepage         = "https://github.com/dennislysenko/RGBAImageBuffer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Dennis Lysenko" => "dennis.s.lysenko@gmail.com" }
  s.source           = { :git => "https://github.com/dennislysenko/RGBAImageBuffer.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dennis_lysenko'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RGBAImageBuffer/Classes/**/*'
  s.resource_bundles = {
    'RGBAImageBuffer' => ['RGBAImageBuffer/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
