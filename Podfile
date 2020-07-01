platform :ios, '13.0'

target_name = 'ladder-client'

use_frameworks!
project target_name

def main_pods
  # lint
  pod 'SwiftLint'
  # font
  pod 'ionicons'
  # ui
  pod 'LGRefreshView'
  pod 'KSToastView'
  pod "Introspect"
  # json parser
  pod 'SwiftyJSON'
  # html parser
  pod "HTMLReader"
  # network
  pod 'ISHTTPOperation'
  pod 'Alamofire'
  # key chain
  pod 'KeychainAccess'
  # firebase
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
end

target target_name do
  main_pods
end

target_name = 'ladder-clientTests'

target target_name do
  main_pods
end

target_name = 'app-extension'

target target_name do
  # lint
  pod 'SwiftLint'
  # json parser
  pod 'SwiftyJSON'
  # html parser
  pod "HTMLReader"
  # key chain
  pod 'KeychainAccess'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end

