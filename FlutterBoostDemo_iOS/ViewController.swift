//
//  ViewController.swift
//  FlutterBoostDemo_iOS
//
//  Created by linyoumu on 2026/4/29.
//

import UIKit
import flutter_boost

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // 设置背景色
        
        // 初始化并添加按钮
        setupOpenFlutterButton()
    }
    
    // MARK: - 创建打开Flutter模块的按钮
    private func setupOpenFlutterButton() {
        // 1. 创建按钮
        let button = UIButton(type: .system)
        // 2. 按钮文字
        button.setTitle("打开 Flutter 模块", for: .normal)
        // 3. 文字大小
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        // 4. 按钮颜色
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        // 5. 圆角
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        // 6. 绑定点击事件
        button.addTarget(self, action: #selector(openFlutterModule), for: .touchUpInside)
        
        // 7. 布局（禁用自动约束）
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        // 8. 自动布局：屏幕居中，宽250，高50
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 250),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - 按钮点击事件（后续在这里写跳转 Flutter 的代码）
    @objc private func openFlutterModule() {
        print("✅ 按钮点击成功！准备打开 Flutter 页面")
        //        //创建options，进行open操作的构建
        //        let options = FlutterBoostRouteOptions()
        //        options.pageName = "/mainPage"
        //        options.arguments = ["data" : "123456"]
        //
        //        //这个是push操作完成的回调，而不是页面关闭的回调！！！！
        //        options.completion = { completion in
        //            print("open operation is completed")
        //        }
        //
        //        //这个是页面关闭并且返回数据的回调，回调实际需要根据您的Delegate中的popRoute来调用
        //        options.onPageFinished = {[weak self] dic in
        //            if let data = dic?["data"] as? String{
        //            }
        //        }
        //
        //        FlutterBoost.instance().open(options)
        
        
        
        FlutterBoost.instance().open(
            "flutter://second",
            arguments: [
                "from": "NativeMainPage",
                "message": "Hello from Native!",
                "timestamp": Date().timeIntervalSince1970
            ],
            completion: { result in
                print("Flutter Second Page 返回结果: \(result)")
                
            }
        )
    }
}

