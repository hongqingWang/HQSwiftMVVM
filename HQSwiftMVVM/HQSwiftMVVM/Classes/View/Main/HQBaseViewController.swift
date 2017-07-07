//
//  HQBaseViewController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQBaseViewController: UIViewController {
    
    /// 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.hq_screenWidth(), height: 64))
    /// 自定义导航条目 - 以后设置导航栏内容,统一使用`navItem`
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
}

// MARK: - 设置界面
extension HQBaseViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.hq_randomColor()
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
        // 设置`navigationBar`的渲染颜色
        navigationBar.barTintColor = UIColor.hq_color(withHex: 0xF6F6F6)
    }
}
