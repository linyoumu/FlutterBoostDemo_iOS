# iOS 模拟器架构配置助手

一个可复用的 CocoaPods 配置模块，用于统一管理 iOS 项目的模拟器架构配置。

## ✨ 特性

- 🚀 **原生模式**: 支持 arm64 + x86_64 双架构，Apple Silicon Mac 原生性能
- ⚡ **Rosetta 模式**: 强制 x86_64，兼容老旧 SDK
- 🔧 **自动修复**: 自动修复第三方插件的架构配置问题
- 📦 **即插即用**: 一行代码集成到任何 iOS 项目
- 🎯 **零侵入**: 不修改任何第三方插件源码

## 📦 安装

### 方法 1: 复制文件（推荐）

将 `PodfileHelper` 目录复制到你的 iOS 项目根目录：

```bash
cp -r PodfileHelper /path/to/your/ios/project/
```

### 方法 2: Git Submodule

```bash
cd /path/to/your/ios/project
git submodule add <repository_url> PodfileHelper
```

## 🚀 快速开始

### 基础用法

在你的 `Podfile` 中添加：

```ruby
# 加载配置助手
load 'PodfileHelper/simulator_arch_config.rb'

platform :ios, '13.0'

target 'YourApp' do
  use_frameworks!
  
  # 你的 Pods
  pod 'Alamofire'
  pod 'SnapKit'
end

post_install do |installer|
  # 使用默认配置（原生模式）
  SimulatorArchConfig.apply(installer)
end
```

### 强制 Rosetta 模式

```ruby
post_install do |installer|
  # 配置 Rosetta 模式
  config = SimulatorArchConfig::Config.new
  config.mode = :rosetta
  
  SimulatorArchConfig.apply(installer, config)
end
```

### 自定义配置

```ruby
post_install do |installer|
  config = SimulatorArchConfig::Config.new
  config.mode = :native                     # 或 :rosetta
  config.enable_logging = true              # 是否显示日志
  config.fix_third_party_plugins = true     # 是否自动修复第三方插件
  
  SimulatorArchConfig.apply(installer, config)
end
```

## 📋 配置选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `mode` | Symbol | `:native` | 架构模式: `:native` 或 `:rosetta` |
| `enable_logging` | Boolean | `true` | 是否启用日志输出 |
| `fix_third_party_plugins` | Boolean | `true` | 是否自动修复第三方插件配置 |

## 🎯 两种模式对比

### Native 模式（推荐）✨

**架构支持:**
- ✅ arm64 模拟器（Apple Silicon 原生）
- ✅ x86_64 模拟器（Intel / Rosetta）
- ✅ arm64 真机

**特点:**
- 🚀 Apple Silicon Mac 原生性能（100%）
- 🔄 自动兼容 Rosetta
- 👥 团队协作友好
- 🛠️ 自动修复问题插件

**使用场景:**
- ✅ 日常开发（推荐）
- ✅ 团队协作（Intel + Apple Silicon Mac）
- ✅ 需要最佳性能

### Rosetta 模式

**架构支持:**
- ❌ arm64 模拟器（被排除）
- ✅ x86_64 模拟器
- ✅ arm64 真机

**特点:**
- ⚡ 性能约 70-80%（Rosetta 翻译层）
- 🎯 兼容老旧 SDK
- 🧪 适合特定测试场景

**使用场景:**
- 🔧 某些 SDK 不支持 arm64
- 🧪 需要测试 x86_64 兼容性
- 📦 CI/CD 环境要求

## 📝 完整示例

### 普通 iOS 项目

```ruby
# Podfile

load 'PodfileHelper/simulator_arch_config.rb'

platform :ios, '13.0'

target 'MyApp' do
  use_frameworks!
  
  pod 'Alamofire', '~> 5.0'
  pod 'SnapKit', '~> 5.0'
end

post_install do |installer|
  # 使用原生模式
  SimulatorArchConfig.apply(installer)
end
```

### Flutter 混合项目

```ruby
# Podfile

load 'PodfileHelper/simulator_arch_config.rb'

platform :ios, '13.0'

flutter_application_path = '../flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'FlutterApp' do
  use_frameworks!
  install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  flutter_post_install(installer)
  
  # 应用架构配置
  config = SimulatorArchConfig::Config.new
  config.mode = :native  # 或 :rosetta
  SimulatorArchConfig.apply(installer, config)
end
```

### 包含老旧 SDK 的项目

```ruby
# Podfile

load 'PodfileHelper/simulator_arch_config.rb'

platform :ios, '13.0'

target 'LegacyApp' do
  use_frameworks!
  
  pod 'SomeOldSDK'  # 不支持 arm64 模拟器
  pod 'ModernSDK'
end

post_install do |installer|
  # 强制使用 Rosetta 模式以兼容老旧 SDK
  config = SimulatorArchConfig::Config.new
  config.mode = :rosetta
  config.fix_third_party_plugins = true
  
  SimulatorArchConfig.apply(installer, config)
end
```

## 🔍 验证配置

### 检查编译产物架构

```bash
# 查看主应用架构
lipo -info ~/Library/Developer/Xcode/DerivedData/*/Build/Products/Debug-iphonesimulator/YourApp.app/YourApp

# Native 模式输出:
# Architectures in the fat file: x86_64 arm64

# Rosetta 模式输出:
# Non-fat file: x86_64
```

### 运行测试

```bash
# 清理并安装
pod install

# 编译测试
xcodebuild -workspace YourApp.xcworkspace \
  -scheme YourApp \
  -sdk iphonesimulator \
  -configuration Debug \
  build
```

## 🔄 模式切换

### 从 Rosetta 切换到 Native

```ruby
# 修改 Podfile
config.mode = :rosetta  # ❌ 删除或改为
config.mode = :native   # ✅

# 重新安装
pod install
```

### 从 Native 切换到 Rosetta

```ruby
# 修改 Podfile
config.mode = :native   # ❌ 删除或改为
config.mode = :rosetta  # ✅

# 重新安装并清理缓存
rm -rf ~/Library/Developer/Xcode/DerivedData/*
pod install
```

## 🐛 故障排查

### 问题 1: "Unable to find module dependency"

**原因**: 架构不匹配

**解决方案**:
```bash
# 清理缓存
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf Pods/
pod install
```

### 问题 2: 第三方插件仍然报错

**原因**: 插件配置未被修复

**解决方案**:
```ruby
# 确保启用自动修复
config.fix_third_party_plugins = true
```

### 问题 3: 性能下降明显

**原因**: 使用了 Rosetta 模式

**解决方案**:
```ruby
# 切换到 Native 模式
config.mode = :native
```

## 💡 最佳实践

### 1. 优先使用 Native 模式

除非有明确的兼容性需求，否则始终使用 Native 模式以获得最佳性能。

```ruby
# ✅ 推荐
config.mode = :native
```

### 2. 团队协作配置

在团队中统一配置模式，避免因架构不同导致的问题：

```ruby
# 添加到 Podfile 顶部
# Team Convention: Use Native mode for best compatibility
config.mode = :native
```

### 3. CI/CD 环境

根据 CI 环境选择合适的模式：

```ruby
# 检测 CI 环境
is_ci = ENV['CI'] == 'true'

config.mode = is_ci ? :rosetta : :native
```

### 4. 保持日志开启

在开发环境保持日志输出，方便排查问题：

```ruby
config.enable_logging = true  # 开发环境
config.enable_logging = false # 生产构建
```

## 📚 API 文档

### SimulatorArchConfig

主模块，提供架构配置功能。

#### 方法

##### `apply(installer, config = Config.new)`

应用架构配置到 CocoaPods 安装过程。

**参数:**
- `installer` (Installer): CocoaPods installer 实例
- `config` (Config, 可选): 配置对象，默认为新建的 Config

**返回值:** 无

**示例:**
```ruby
SimulatorArchConfig.apply(installer)
```

### SimulatorArchConfig::Config

配置类，用于定义架构配置选项。

#### 属性

##### `mode`
- **类型**: Symbol
- **默认值**: `:native`
- **可选值**: `:native`, `:rosetta`
- **说明**: 架构模式

##### `enable_logging`
- **类型**: Boolean
- **默认值**: `true`
- **说明**: 是否启用日志输出

##### `fix_third_party_plugins`
- **类型**: Boolean
- **默认值**: `true`
- **说明**: 是否自动修复第三方插件配置

## 🎉 总结

这个配置助手提供了：

- ✅ 简单易用的 API
- ✅ 两种架构模式自由切换
- ✅ 自动修复第三方插件问题
- ✅ 零侵入式集成
- ✅ 完整的文档和示例

**立即集成到你的项目，享受无忧的架构配置管理！** 🚀

---

**创建时间**: 2026-04-30  
**版本**: 1.0.0  
**许可**: MIT
