//
//  HQMainViewController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 'setupChildControllers' is inaccessible due to 'private' protection level
        setupChildControllers()
    }
}

/*
 extension 类似于 OC 中的分类,在 Swift 中还可以用来切分代码块
 可以把功能相近的函数,放在一个extension中
 */
extension HQMainViewController {
    
    
    /// 设置所有子控制器
    fileprivate func setupChildControllers() {
        
        let array = [
            ["className": "HQAViewController", "title": "首页", "imageName": ""]
        ]
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    /*
     ## 关于 fileprvita 和 private
     
     - 在`swift 3.0`，新增加了一个`fileprivate`，这个元素的访问权限为文件内私有
     - 过去的`private`相当于现在的`fileprivate`
     - 现在的`private`是真正的私有，离开了这个类或者结构体的作用域外面就无法访问了
     */
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典[className, title, imageName]
    /// - Returns: 子控制器
    private func controller(dict: [String: String]) -> UIViewController {
        
        // 1. 获取字典内容
        guard let className = dict["className"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type else {
                
                return UIViewController()
        }
        // 2. 创建视图控制器
        let vc = cls.init()
        vc.title = title
        let nav = HQNavigationController(rootViewController: vc)
        return nav
    }
}
