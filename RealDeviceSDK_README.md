# 真机专用 SDK 配置说明

## 📋 概述

本项目配置了对"只支持真机运行"SDK 的支持方案。通过 Podfile 条件配置，可以让项目在模拟器和真机环境下都能正常编译和运行。

## 🔧 配置方法

### 1. 在 Podfile 中添加真机专用 SDK

在 `target` 块中添加你的 SDK：

```ruby
target 'FlutterBoostDemo_iOS' do
  use_frameworks!
  install_all_flutter_pods(flutter_application_path)
  
  # 添加真机专用 SDK
  pod 'YourRealDeviceSDK'
end
```

### 2. 在 real_device_only_pods 列表中注册

在 `post_install` 中找到这个数组，添加 SDK 名称：

```ruby
real_device_only_pods = [
  'YourRealDeviceSDK',     # 添加你的 SDK 名称
  'AnotherRealDeviceSDK',  # 可以添加多个
]
```

### 3. 执行 pod install

```bash
pod install
```

## 💻 代码中使用

### Swift 代码示例

在代码中检查 SDK 是否可用：

```swift
import UIKit

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(simulator)
        // 模拟器环境
        print("⚠️ 运行在模拟器，使用 Mock 实现")
        useMockSDK()
        #else
        // 真机环境
        import YourRealDeviceSDK
        YourRealDeviceSDK.initialize()
        #endif
    }
    
    func useMockSDK() {
        // Mock 实现
        print("使用模拟数据")
    }
}
```

### 运行时检查（可选）

```swift
// 检查类是否存在
if NSClassFromString("YourSDKClassName") != nil {
    // SDK 可用（真机）
    initializeRealSDK()
} else {
    // SDK 不可用（模拟器）
    useMockImplementation()
}
```

## 📱 测试

### 模拟器测试
```bash
# 编译模拟器版本
xcodebuild -workspace FlutterBoostDemo_iOS.xcworkspace \
  -scheme FlutterBoostDemo_iOS \
  -configuration Debug \
  -sdk iphonesimulator \
  build
```

### 真机测试
```bash
# 编译真机版本
xcodebuild -workspace FlutterBoostDemo_iOS.xcworkspace \
  -scheme FlutterBoostDemo_iOS \
  -configuration Release \
  -sdk iphoneos \
  build
```

## ⚠️ 注意事项

1. **模拟器环境**：
   - 真机专用 SDK 不会被链接
   - 需要使用 Mock 或条件编译
   - 不会影响编译

2. **真机环境**：
   - SDK 正常工作
   - 所有功能可用

3. **发布版本**：
   - Release 配置会包含所有 SDK
   - 确保在真机上测试完整功能

## 🔍 调试

如果遇到问题，检查以下内容：

1. **编译输出**：查看是否有 "⚠️ 配置真机专用 Pod" 的日志
2. **架构设置**：确认 EXCLUDED_ARCHS 正确设置
3. **弱链接**：检查 OTHER_LDFLAGS 是否包含弱链接标志

## 📝 示例 SDK 列表

常见只支持真机的 SDK：
- 某些支付 SDK（如银联、支付宝特定版本）
- 部分硬件相关 SDK（蓝牙、NFC）
- 某些安全 SDK
- 特定的直播/音视频 SDK

## 🚀 最佳实践

1. **开发阶段**：使用模拟器 + Mock，快速迭代
2. **功能测试**：使用真机测试完整功能
3. **发布前**：真机上完整测试所有 SDK 功能
