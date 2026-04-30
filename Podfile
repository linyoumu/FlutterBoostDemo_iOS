# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

flutter_application_path = '../flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'FlutterBoostDemo_iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FlutterBoostDemo_iOS
  install_all_flutter_pods(flutter_application_path)
  
  # ========================================
  # 只在真机上安装的 Pods（示例）
  # ========================================
  # 取消下面的注释并替换为实际的 Pod 名称
  # pod 'OnlyRealDeviceSDK', :configurations => ['Release']
  # pod 'AnotherRealDeviceSDK'

end

#bitcode disable
post_install do |installer|
  #flutter
  flutter_post_install(installer)
  
  # ========================================
  # 配置只支持真机的 SDK
  # ========================================
  
  # 定义只支持真机的 Pod 名称列表
  real_device_only_pods = [
    # 'OnlyRealDeviceSDK',
    # 'AnotherRealDeviceSDK',
    # 在这里添加你的真机专用 SDK
  ]
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      
      # ========================================
      # 【强制 Rosetta 模式】
      # 所有 Pods 在模拟器上排除 arm64，只使用 x86_64
      # ========================================
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      
      # 对于只支持真机的 Pod，配置模拟器环境
      if real_device_only_pods.include?(target.name)
        puts "⚠️  配置真机专用 Pod: #{target.name}"
        
        # Debug 配置（通常用于模拟器）
        if config.name == 'Debug'
          # 【推荐】只排除 arm64，保留 x86_64（通过 Rosetta 运行）
          # 适用于在 Apple Silicon Mac 上使用 Rosetta 模拟器
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
          
          # 如果 SDK 完全不支持模拟器，使用下面的配置
          # config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64 x86_64'
          # config.build_settings['VALID_ARCHS'] = 'arm64'  # 只保留真机架构
          
          # 使用弱链接允许编译通过
          config.build_settings['OTHER_LDFLAGS'] ||= ['$(inherited)']
          config.build_settings['OTHER_LDFLAGS'] << "-weak_framework #{target.name}"
          
          # 允许编译警告但不失败
          config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
          config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
      end
      
      # ========================================
      # 修复第三方插件的架构配置问题
      # ========================================
      # 如果插件配置了 EXCLUDED_ARCHS = 'arm64'（老旧配置），在这里覆盖
      # 这样不需要修改插件源码
      if target.name == 'flutter_plugin_test' ||
         target.name.start_with?('flutter_') # 可以匹配其他有问题的 Flutter 插件
        
        # 检查是否有错误的 arm64 排除配置
        excluded_archs = config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]']
        if excluded_archs == 'arm64'
          puts "⚠️  修复插件 #{target.name} 的架构配置"
          puts "   原配置: EXCLUDED_ARCHS = 'arm64' (不兼容 Apple Silicon)"
          puts "   新配置: EXCLUDED_ARCHS = 'i386' (标准配置)"
          
          # 覆盖为正确的配置
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386'
        end
      end
      
      # 通用配置：允许模拟器编译通过
      config.build_settings['VALIDATE_WORKSPACE'] = 'NO'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
    end
  end
  
  # 配置主项目
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        # 确保主项目能处理弱链接的框架
        config.build_settings['OTHER_LDFLAGS'] ||= ['$(inherited)']
        
        # 为真机专用的框架添加弱链接
        real_device_only_pods.each do |pod_name|
          unless config.build_settings['OTHER_LDFLAGS'].include?("-weak_framework #{pod_name}")
            config.build_settings['OTHER_LDFLAGS'] << "-weak_framework #{pod_name}"
          end
        end
      end
    end
  end
  
  # ========================================
  # 修复第三方插件的 xcconfig 文件中的架构配置
  # ========================================
  # 这个方法不修改插件源码，只修改生成的配置文件
  Dir.glob('Pods/Target Support Files/**/*.xcconfig').each do |xcconfig_path|
    xcconfig_content = File.read(xcconfig_path)
    
    # 查找并替换错误的 arm64 排除配置
    if xcconfig_content.include?("EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64")
      puts "⚠️  修复配置文件: #{File.basename(xcconfig_path)}"
      puts "   原配置: EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64"
      puts "   新配置: EXCLUDED_ARCHS[sdk=iphonesimulator*] = i386"
      
      # 替换配置
      new_content = xcconfig_content.gsub(
        /EXCLUDED_ARCHS\[sdk=iphonesimulator\*\] = arm64/,
        'EXCLUDED_ARCHS[sdk=iphonesimulator*] = i386'
      )
      
      File.write(xcconfig_path, new_content)
    end
  end
  
  puts "✅ Pod 配置完成"
end
