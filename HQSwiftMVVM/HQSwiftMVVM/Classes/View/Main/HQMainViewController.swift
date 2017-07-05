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

        setupChildControllers()
    }
}

/*
 extension 类似于 OC 中的分类,在 Swift 中还可以用来切分代码块
 可以把功能相近的函数,放在一个extension中
 */
extension HQMainViewController {
    
    
    /// 设置所有子控制器
    func setupChildControllers() {
        
    }
    
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典[className, title, imageName]
    /// - Returns: 子控制器
//    func controller(dict: [String: String]) -> UIViewController {
//        
//        // 1. 获取字典内容
//        guard let className = dict["className"],
//            let title = dict["title"],
//            let imageName = dict["imageName"] else {
//                
//                return UIViewController()
//        }
//        // 2. 创建视图控制器
//        
//    }
}
