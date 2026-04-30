# 🎯 iOS Simulator Architecture Config Helper

**一行代码解决 iOS 模拟器架构配置问题！**

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](VERSION.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)

---

## 🚀 30 秒快速开始

```bash
# 1. 复制到你的项目
cp -r PodfileHelper /path/to/your/ios/project/

# 2. 在 Podfile 中添加一行
load 'PodfileHelper/simulator_arch_config.rb'

# 3. 在 post_install 中添加一行
SimulatorArchConfig.apply(installer)

# 4. 完成！
pod install
```

---

## 📚 文档导航

### 🆕 新手入门
- **[快速开始](QUICK_START.md)** - 5 分钟上手指南
- **[示例 Podfile](Podfile.example)** - 复制粘贴即用

### 📖 深入学习
- **[完整文档](README.md)** - 所有功能详解
- **[API 文档](README.md#📚-api-文档)** - 接口说明
- **[最佳实践](README.md#💡-最佳实践)** - 使用建议

### 🔧 开发参考
- **[项目结构](PROJECT_STRUCTURE.md)** - 文件说明
- **[版本历史](VERSION.md)** - 更新日志
- **[许可证](LICENSE)** - MIT

---

## ✨ 核心特性

| 特性 | 说明 |
|------|------|
| 🚀 **Native 模式** | arm64 + x86_64 双架构，性能 100% |
| ⚡ **Rosetta 模式** | 强制 x86_64，兼容老旧 SDK |
| 🔧 **自动修复** | 自动修复第三方插件配置问题 |
| 📦 **零侵入** | 不修改任何插件源码 |
| 🎯 **一行集成** | 极简 API，开箱即用 |

---

## 🎯 为什么需要它？

### 问题：架构配置复杂

```
❌ Apple Silicon Mac 上编译失败
❌ 第三方插件架构不匹配  
❌ "Unable to find module dependency" 错误
❌ 手动配置繁琐易错
```

### 解决：一行代码搞定

```ruby
SimulatorArchConfig.apply(installer)
```

```
✅ 自动配置所有 Pods
✅ 自动配置主项目
✅ 自动修复问题插件
✅ 支持 Native 和 Rosetta 模式
```

---

## 📖 使用示例

### 基础使用（推荐）

```ruby
# Podfile
load 'PodfileHelper/simulator_arch_config.rb'

platform :ios, '13.0'

target 'MyApp' do
  use_frameworks!
  pod 'Alamofire'
end

post_install do |installer|
  SimulatorArchConfig.apply(installer)  # ← 就这一行！
end
```

### 自定义配置

```ruby
post_install do |installer|
  config = SimulatorArchConfig::Config.new
  config.mode = :rosetta                    # 强制 Rosetta
  config.enable_logging = true              # 显示日志
  config.fix_third_party_plugins = true     # 自动修复
  
  SimulatorArchConfig.apply(installer, config)
end
```

---

## 🎯 两种模式对比

| 模式 | arm64 | x86_64 | 性能 | 适用场景 |
|------|-------|--------|------|---------|
| **Native** ✨ | ✅ | ✅ | 100% | 日常开发（推荐） |
| **Rosetta** | ❌ | ✅ | ~75% | 老旧 SDK 兼容 |

---

## 🔍 验证效果

```bash
# 安装后查看架构
lipo -info DerivedData/.../Debug-iphonesimulator/YourApp.app/YourApp

# Native 模式输出:
Architectures in the fat file: x86_64 arm64 ✅

# Rosetta 模式输出:
Non-fat file: x86_64 ✅
```

---

## 💡 快速选择

```
需要最佳性能? → Native 模式（默认）
有老旧 SDK?   → Rosetta 模式
不确定?       → Native 模式（推荐）
```

---

## 📦 文件清单

```
PodfileHelper/
├── simulator_arch_config.rb    ← 核心模块（必需）
├── README.md                    ← 完整文档
├── QUICK_START.md               ← 快速开始
├── Podfile.example              ← 使用示例
├── VERSION.md                   ← 版本信息
├── LICENSE                      ← MIT 许可
├── PROJECT_STRUCTURE.md         ← 项目结构
├── Podfile.test                 ← 测试配置
└── INDEX.md                     ← 本文件
```

**最小集成**: 只需 `simulator_arch_config.rb`（1 个文件）

---

## 🔥 核心优势

### 1. 极简集成
```ruby
# 一行 load + 一行 apply = 搞定！
load 'PodfileHelper/simulator_arch_config.rb'
SimulatorArchConfig.apply(installer)
```

### 2. 零侵入
- ✅ 不修改第三方插件源码
- ✅ 只修改生成的配置文件
- ✅ 随时可以移除

### 3. 智能修复
- ✅ 自动检测问题配置
- ✅ 自动修复架构冲突
- ✅ 详细日志输出

### 4. 灵活配置
- ✅ 两种模式自由切换
- ✅ 可选功能开关
- ✅ 适配各种场景

---

## 🎉 立即开始

### 选择你的起点：

1. **我想快速上手** → [QUICK_START.md](QUICK_START.md)
2. **我想了解详情** → [README.md](README.md)  
3. **我想看示例** → [Podfile.example](Podfile.example)
4. **我遇到问题** → [README.md#故障排查](README.md#🐛-故障排查)

---

## 📊 性能对比

| 场景 | Native 模式 | Rosetta 模式 |
|------|------------|-------------|
| Apple Silicon Mac | 🚀 100% (arm64) | ⚡ ~75% (Rosetta) |
| Intel Mac | 🚀 100% (x86_64) | 🚀 100% (x86_64) |
| 编译时间 | 快 | 慢约 25% |
| 运行性能 | 最佳 | 良好 |

**推荐**: 除非有明确需求，否则始终使用 Native 模式！

---

## ✅ 兼容性

- ✅ iOS 11.0+
- ✅ CocoaPods 1.10+
- ✅ Xcode 12+
- ✅ Apple Silicon Mac (M1/M2/M3/M4)
- ✅ Intel Mac
- ✅ Flutter 混合项目
- ✅ 纯原生 iOS 项目

---

## 🤝 开源协议

MIT License - 可自由使用、修改、分发

详见: [LICENSE](LICENSE)

---

## 📞 获取帮助

- 📖 查看 [完整文档](README.md)
- 🚀 查看 [快速开始](QUICK_START.md)
- 🐛 查看 [故障排查](README.md#🐛-故障排查)
- 📧 联系开发团队

---

<div align="center">

**Built with ❤️ for the iOS Community**

[快速开始](QUICK_START.md) • [完整文档](README.md) • [示例](Podfile.example) • [版本](VERSION.md)

⭐ 如果这个工具帮到了你，请给一个 Star！

</div>
