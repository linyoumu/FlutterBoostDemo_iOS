# Podfile 配置说明

本项目包含两种 Podfile 配置，可根据需求切换使用。

## 📋 配置文件列表

| 文件名 | 说明 | 架构支持 | 适用场景 |
|--------|------|---------|---------|
| `Podfile` | 当前使用的配置 | 当前: x86_64 only | 当前模式 |
| `Podfile.with_rosetta` | 强制 Rosetta 模式 | x86_64 only | 需要 Rosetta 环境 |
| `Podfile.without_rosetta` | 原生多架构支持 | arm64 + x86_64 | **推荐**：最佳兼容性 |

## 🎯 两种配置对比

### 配置 1：无 Rosetta（推荐）✨

**文件：** `Podfile.without_rosetta`

**架构支持：**
- ✅ arm64 模拟器（Apple Silicon 原生）
- ✅ x86_64 模拟器（Rosetta）
- ✅ 真机（arm64）

**特点：**
- 🚀 Apple Silicon Mac 上性能最佳（100% 原生）
- 🔄 自动兼容 Rosetta 模式
- 👥 团队协作友好（Intel Mac 也能用）
- 🛠️ 包含第三方插件自动修复功能

**配置要点：**
```ruby
# 只排除过时的 i386
EXCLUDED_ARCHS[sdk=iphonesimulator*] = i386

# 自动修复有问题的第三方插件
Dir.glob('Pods/Target Support Files/**/*.xcconfig').each do |xcconfig_path|
  # 将错误的 arm64 排除改为 i386
  ...
end
```

### 配置 2：强制 Rosetta

**文件：** `Podfile.with_rosetta`

**架构支持：**
- ❌ arm64 模拟器（被排除）
- ✅ x86_64 模拟器（Rosetta）
- ✅ 真机（arm64）

**特点：**
- 🔧 强制使用 x86_64 架构
- ⚡ 性能约 70-80%（Rosetta 翻译开销）
- 🎯 适用于特定 SDK 需求
- 🧪 CI/CD 环境兼容

**配置要点：**
```ruby
# 所有组件排除 arm64 模拟器
config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
```

## 🔄 如何切换配置

### 切换到无 Rosetta 模式（推荐）

```bash
cd /Users/linyoumu/Desktop/GitProject/Flutter/FlutterBoostDemo_iOS
cp Podfile.without_rosetta Podfile
pod install
```

### 切换到强制 Rosetta 模式

```bash
cd /Users/linyoumu/Desktop/GitProject/Flutter/FlutterBoostDemo_iOS
cp Podfile.with_rosetta Podfile
pod install
```

## 📊 性能对比

| 配置 | Apple Silicon Mac | Intel Mac | 性能 |
|------|------------------|-----------|------|
| **无 Rosetta** | arm64 原生 ✅ | x86_64 原生 ✅ | 100% 🚀 |
| **强制 Rosetta** | x86_64 Rosetta | x86_64 原生 ✅ | ~75% ⚡ |

## 💡 使用建议

### 推荐使用：无 Rosetta 模式

**除非你遇到以下情况：**

1. ❌ 某些老旧 SDK 明确不支持 arm64 模拟器
2. 🧪 需要测试 x86_64 环境的兼容性
3. 🔧 CI/CD 环境只有 x86_64
4. 📦 第三方库强制要求 x86_64

**否则，始终使用无 Rosetta 模式以获得最佳性能！**

## 🔍 验证当前配置

### 检查编译架构

```bash
# 查看主项目架构
lipo -info ~/Library/Developer/Xcode/DerivedData/*/Build/Products/Debug-iphonesimulator/FlutterBoostDemo_iOS.app/FlutterBoostDemo_iOS

# 输出示例：
# 无 Rosetta: Architectures in the fat file: x86_64 arm64
# 强制 Rosetta: Non-fat file: x86_64
```

### 检查 Podfile 配置

```bash
# 查看当前使用的配置
grep "EXCLUDED_ARCHS" Podfile

# 无 Rosetta 输出: i386 或自动修复逻辑
# 强制 Rosetta 输出: arm64
```

## 📝 快速参考

### 我应该用哪个配置？

```
是否有老旧 SDK 不支持 arm64？
    ├─ 否 → 使用 Podfile.without_rosetta ✅ (推荐)
    └─ 是 → 使用 Podfile.with_rosetta
```

### 出现编译错误时

如果看到 "Unable to find module dependency" 错误：

1. 检查架构是否匹配
2. 尝试切换配置
3. 清理并重新编译：
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/*
   pod install
   ```

## 🎉 总结

- **日常开发**：使用 `Podfile.without_rosetta` 获得最佳性能
- **特殊需求**：使用 `Podfile.with_rosetta` 解决兼容性问题
- **随时切换**：两个配置文件随时可切换，互不影响

---

**创建时间：** 2026-04-30  
**项目：** FlutterBoostDemo_iOS
