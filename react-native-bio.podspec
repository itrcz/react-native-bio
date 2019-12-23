Pod::Spec.new do |s|
  s.name          = "react-native-bio"
  s.version       = "1.0.0"
  s.source_files  = "ios/*.{h,m}"
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.authors       = { "Ilya Trikoz" => "jleed@me.com" }
  s.license       = "MIT"
  s.summary       = "Touch ID and Face ID for React Native"
  s.homepage      = "https://github.com/jleed/react-native-bio"
  s.source        = { :git => "https://github.com/jleed/react-native-bio.git" }

  s.dependency 'React'
end
