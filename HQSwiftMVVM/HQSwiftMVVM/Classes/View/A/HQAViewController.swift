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
    
    @objc fileprivate func showFriends() {
        print(#function)
        let vc = HQDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HQAViewController {
    
    
    /// 重写父类的方法
    override func setupUI() {
        super.setupUI()
        
        let btn = UIButton(hq_title: "好友", normalColor: UIColor.lightGray, highlightedColor: UIColor.orange)
        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
    }
}
