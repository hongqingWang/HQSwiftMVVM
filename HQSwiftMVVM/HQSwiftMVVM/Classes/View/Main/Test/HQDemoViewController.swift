//
//  HQDemoViewController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/7.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQDemoViewController: HQBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    @objc fileprivate func showNext() {
        
        let vc = HQDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HQDemoViewController {
    
    override func setupTableView() {
        /// 重新父类的方法是因为父类的方法不能满足我们的需求,但是一定要调用一下父类的方法`super.setupTableView()`
        super.setupTableView()
        
        navItem.rightBarButtonItem = UIBarButtonItem(hq_title: "下一个", target: self, action: #selector(showNext))
    }
}
