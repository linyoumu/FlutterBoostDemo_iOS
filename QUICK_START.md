# 🚀 快速开始：真机专用 SDK 配置

## 第一步：添加你的真机专用 SDK

### 1. 编辑 Podfile

找到 `target 'FlutterBoostDemo_iOS' do` 块，取消注释并添加你的 SDK：

```ruby
target 'FlutterBoostDemo_iOS' do
  use_frameworks!
  install_all_flutter_pods(flutter_application_path)
  
  # 添加真机专用 SDK（替换为你的实际 Pod 名称）
  pod 'YourRealDeviceSDK'
  # 或者只在 Release 配置中添加
  # pod 'YourRealDeviceSDK', :configurations => ['Release']
end
```

### 2. 注册 SDK 名称

在 `post_install` 中找到 `real_device_only_pods` 数组，添加 SDK 名称：

```ruby
real_device_only_pods = [
  'YourRealDeviceSDK',  # 改为你的 SDK 名称
]
```

### 3. 执行安装

```bash
cd /Users/linyoumu/Desktop/GitProject/Flutter/FlutterBoostDemo_iOS
pod install
```

## 第二步：代码中使用

### 方式 A：使用提供的 Helper 类（推荐）

1. 将 `RealDeviceSDKHelper.swift` 添加到项目
2. 根据你的 SDK 修改实现
3. 在代码中使用：

```swift
// AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 初始化
    RealDeviceSDKHelper.initialize()
    
    // 检查环境
    print("当前环境：\(RealDeviceSDKHelper.checkEnvironment())")
    
    return true
}

// 使用 SDK
RealDeviceSDKHelper.shared.performAction { result in
    switch result {
    case .success(let data):
        print("✅ 成功：\(data)")
    case .failure(let error):
        print("❌ 失败：\(error)")
    }
}
```

### 方式 B：直接条件编译

```swift
import UIKit

#if targetEnvironment(simulator)
// 模拟器代码
func initializeSDK() {
    print("⚠️ 模拟器：使用 Mock")
}
#else
// 真机代码
import YourRealDeviceSDK
func initializeSDK() {
    YourRealDeviceSDK.setup()
}
#endif
```

### 方式 C：运行时检查

```swift
if NSClassFromString("YourSDKClassName") != nil {
    // 真机：SDK 可用
    initializeRealSDK()
} else {
    // 模拟器：使用 Mock
    useMockSDK()
}
```

## 第三步：测试

### 模拟器测试
```bash
# 在 Xcode 中选择任意模拟器，然后 Cmd+R 运行
# 或命令行：
xcodebuild -workspace FlutterBoostDemo_iOS.xcworkspace \
  -scheme FlutterBoostDemo_iOS \
  -sdk iphonesimulator \
  build
```

### 真机测试
```bash
# 连接真机，在 Xcode 中选择设备，然后 Cmd+R 运行
# 或命令行：
xcodebuild -workspace FlutterBoostDemo_iOS.xcworkspace \
  -scheme FlutterBoostDemo_iOS \
  -sdk iphoneos \
  -destination 'platform=iOS,name=Your iPhone' \
  build
```

## 常见问题

### Q1: Pod install 后还是报错？
**A:** 检查以下内容：
1. SDK 名称是否正确（区分大小写）
2. 是否在 `real_device_only_pods` 数组中添加
3. 清理 DerivedData：`rm -rf ~/Library/Developer/Xcode/DerivedData`
4. 重新 `pod install`

### Q2: 模拟器运行时崩溃？
**A:** 确保代码中使用了条件编译或运行时检查，不要直接调用真机 SDK

### Q3: 真机上 SDK 不工作？
**A:** 
1. 检查是否在真机上测试（不是模拟器）
2. 确认 SDK 正确初始化
3. 查看 SDK 的官方文档

### Q4: 如何添加多个真机专用 SDK？
**A:** 在数组中添加多个：
```ruby
real_device_only_pods = [
  'SDK1',
  'SDK2',
  'SDK3',
]
```

## 示例：真实 SDK 配置

### 例子 1：支付 SDK
```ruby
# Podfile
pod 'AlipaySDK-iOS'

# post_install
real_device_only_pods = [
  'AlipaySDK-iOS',
]
```

### 例子 2：蓝牙 SDK
```ruby
# Podfile
pod 'SomeBluetoothSDK'

# post_install
real_device_only_pods = [
  'SomeBluetoothSDK',
]
```

## 下一步

1. ✅ 完成基础配置
2. ✅ 在模拟器上测试 Mock 功能
3. ✅ 在真机上测试完整功能
4. ✅ 提交代码前确保两个环境都能编译

## 需要帮助？

查看详细文档：`RealDeviceSDK_README.md`
