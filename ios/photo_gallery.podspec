#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint photo_gallery.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'photo_gallery'
  s.version          = '3.0.0'
  s.summary          = 'A Flutter plugin that retrieves images and videos from mobile native gallery.'
  s.description      = <<-DESC
A Flutter plugin that retrieves images and videos from mobile native gallery.
                       DESC
  s.homepage         = 'https://github.com/Firelands128/photo_gallery'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'photo_gallery' => 'https://github.com/Firelands128/photo_gallery' }
  s.source           = { :path => '.' }
  s.source_files = 'photo_gallery/Sources/photo_gallery/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
