# 🚀 快速开始指南

5 分钟完成 iOS 模拟器架构配置集成！

## 📋 前置要求

- ✅ 已有 iOS 项目（使用 CocoaPods）
- ✅ 已安装 CocoaPods (`sudo gem install cocoapods`)
- ✅ macOS 系统（支持 Intel 和 Apple Silicon）

## ⚡ 3 步集成

### Step 1: 复制配置助手

将 `PodfileHelper` 目录复制到你的 iOS 项目根目录：

```bash
# 假设当前在 FlutterBoostDemo_iOS 目录
cp -r PodfileHelper /path/to/your/ios/project/

# 示例:
# cp -r PodfileHelper ~/MyProjects/MyiOSApp/
```

### Step 2: 修改 Podfile

在你的 `Podfile` 开头添加一行：

```ruby
load 'PodfileHelper/simulator_arch_config.rb'
```

在 `post_install` 块中添加：

```ruby
post_install do |installer|
  # 你原有的代码...
  
  # 添加这一行（使用默认 Native 模式）
  SimulatorArchConfig.apply(installer)
end
```

**完整示例:**

```ruby
load 'PodfileHelper/simulator_arch_config.rb'  # ← 添加这行

platform :ios, '13.0'

target 'MyApp' do
  use_frameworks!
  pod 'Alamofire'
end

post_install do |installer|
  SimulatorArchConfig.apply(installer)  # ← 添加这行
end
```

### Step 3: 安装并测试

```bash
# 安装 Pods
pod install

# 打开项目
open YourApp.xcworkspace

# 在 Xcode 中选择模拟器并运行（Cmd + R）
```

## 🎉 完成！

你的项目现在已经配置为：
- ✅ 支持 arm64 模拟器（Apple Silicon 原生）
- ✅ 支持 x86_64 模拟器（Rosetta）
- ✅ 自动修复第三方插件问题

## 🔧 切换到 Rosetta 模式

如果需要强制使用 Rosetta（x86_64）：

```ruby
post_install do |installer|
  config = SimulatorArchConfig::Config.new
  config.mode = :rosetta  # ← 改为 Rosetta 模式
  SimulatorArchConfig.apply(installer, config)
end
```

然后重新安装：

```bash
pod install
```

## 📖 更多信息

查看完整文档: [README.md](README.md)

## 💡 常见问题

### Q: 我应该使用哪种模式？

**A:** 大多数情况下使用默认的 **Native 模式**（性能最佳）。只有在遇到不支持 arm64 的老旧 SDK 时才使用 Rosetta 模式。

### Q: 如何验证配置是否生效？

**A:** 运行 `pod install`，你会看到：

```
🚀 配置原生多架构模式（arm64 + x86_64）
✅ 原生模式配置完成
💡 提示: 支持 arm64 原生 + x86_64 Rosetta
```

### Q: 是否会修改第三方插件代码？

**A:** **不会！** 我们只修改生成的配置文件（`.xcconfig`），不会触碰任何插件源码。

### Q: 团队成员有 Intel Mac 怎么办？

**A:** Native 模式同时支持 Apple Silicon 和 Intel Mac，无需任何额外配置！

## 🆘 需要帮助？

查看故障排查指南: [README.md#故障排查](README.md#🐛-故障排查)

---

**Happy Coding! 🎉**
