# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'DrLet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DrLet
	pod 'Firebase'
        pod 'Firebase/Auth'
        pod 'Firebase/Database'
        pod 'Firebase/Core'
        pod 'Firebase/Storage'
        pod 'SVProgressHUD'
        pod 'ChameleonFramework'

  target 'DrLetTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DrLetUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
            end
        end
    end
