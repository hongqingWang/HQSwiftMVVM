//
//  HQBaseViewController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}


// MARK: - 设置界面
extension HQBaseViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.yellow
    }
}
