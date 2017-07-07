//
//  HQAViewController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQAViewController: HQBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func showFriends() {
        let vc = HQDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HQAViewController {
    
    override func setupUI() {
        super.setupUI()
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
    }
}
