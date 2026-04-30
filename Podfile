# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

flutter_application_path = '../flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'FlutterBoostDemo_iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FlutterBoostDemo_iOS
  install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  # Flutter 默认的 post_install 配置
  flutter_post_install(installer)
  
  # 确保所有 Pod 都支持 iOS 13.0
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end