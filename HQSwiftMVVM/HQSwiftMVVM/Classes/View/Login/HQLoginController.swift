//
//  HQLoginController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/25.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQLoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        title = "登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(hq_title: "返回", target: self, action: #selector(close), isBack: true)
    }
    
    @objc fileprivate func close() {
        
        dismiss(animated: true, completion: nil)
    }
}
