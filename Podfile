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

#bitcode disable
post_install do |installer|
    #flutter
    flutter_post_install(installer)

    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
end
