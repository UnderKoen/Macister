project 'Macister.xcodeproj'

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Macister' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Macister
  pod 'Alamofire', '4.7.0'
  pod 'SwiftyJSON', '4.0.0'
  pod 'RNCryptor', '5.0.2'
  pod 'HotKey', '0.1.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end