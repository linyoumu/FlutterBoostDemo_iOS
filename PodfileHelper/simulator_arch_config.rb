# ==============================================================================
# iOS 模拟器架构配置助手
# ==============================================================================
# 用途: 统一管理 iOS 项目的模拟器架构配置
# 支持: arm64 原生模式 / 强制 Rosetta (x86_64) 模式
# ==============================================================================

module SimulatorArchConfig
  
  # 配置选项
  class Config
    attr_accessor :mode, :enable_logging, :fix_third_party_plugins
    
    # 初始化配置
    def initialize
      @mode = :native                    # 模式: :native 或 :rosetta
      @enable_logging = true             # 是否启用日志输出
      @fix_third_party_plugins = true    # 是否自动修复第三方插件
    end
  end
  
  # 应用配置到 CocoaPods 安装过程
  # @param installer [Installer] CocoaPods installer 实例
  # @param config [Config] 配置对象
  def self.apply(installer, config = Config.new)
    case config.mode
    when :rosetta
      apply_rosetta_mode(installer, config)
    when :native
      apply_native_mode(installer, config)
    else
      raise "Unknown mode: #{config.mode}. Use :native or :rosetta"
    end
  end
  
  private
  
  # 应用强制 Rosetta 模式（x86_64 only）
  def self.apply_rosetta_mode(installer, config)
    log("🔧 配置强制 Rosetta 模式（x86_64 模拟器）", config)
    
    # 配置所有 Pods
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config_obj|
        config_obj.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        config_obj.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
    end
    
    # 配置主项目
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config_obj|
          config_obj.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
          config_obj.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
      end
    end
    
    # 修复第三方插件
    fix_third_party_xcconfig(config, 'i386', 'arm64') if config.fix_third_party_plugins
    
    log("✅ Rosetta 模式配置完成", config)
    log("💡 提示: 模拟器将使用 x86_64 架构（通过 Rosetta 运行）", config)
  end
  
  # 应用原生模式（arm64 + x86_64）
  def self.apply_native_mode(installer, config)
    log("🚀 配置原生多架构模式（arm64 + x86_64）", config)
    
    # 配置所有 Pods - 只排除过时的 i386
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config_obj|
        config_obj.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386'
        config_obj.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
    end
    
    # 配置主项目
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config_obj|
          config_obj.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386'
          config_obj.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
      end
    end
    
    # 修复第三方插件 - 将错误的 arm64 排除改为 i386
    fix_third_party_xcconfig(config, 'arm64', 'i386') if config.fix_third_party_plugins
    
    log("✅ 原生模式配置完成", config)
    log("💡 提示: 支持 arm64 原生 + x86_64 Rosetta", config)
  end
  
  # 修复第三方插件的 xcconfig 文件
  def self.fix_third_party_xcconfig(config, from_arch, to_arch)
    fixed_count = 0
    
    Dir.glob('Pods/Target Support Files/**/*.xcconfig').each do |xcconfig_path|
      xcconfig_content = File.read(xcconfig_path)
      
      pattern = "EXCLUDED_ARCHS[sdk=iphonesimulator*] = #{from_arch}"
      if xcconfig_content.include?(pattern)
        new_content = xcconfig_content.gsub(
          /EXCLUDED_ARCHS\[sdk=iphonesimulator\*\] = #{from_arch}/,
          "EXCLUDED_ARCHS[sdk=iphonesimulator*] = #{to_arch}"
        )
        File.write(xcconfig_path, new_content)
        fixed_count += 1
        log("  🔧 已修复: #{File.basename(xcconfig_path)}", config)
      end
    end
    
    log("  📦 共修复 #{fixed_count} 个第三方插件配置", config) if fixed_count > 0
  end
  
  # 日志输出
  def self.log(message, config)
    puts message if config.enable_logging
  end
end
