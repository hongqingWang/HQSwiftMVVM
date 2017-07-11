//
//  HQBarButtonItem.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/7.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 标题 + target + action
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - fontSize: fontSize
    ///   - target: target
    ///   - action: action
    ///   - isBack: 是否是返回按钮,如果是就加上箭头的`icon`
    convenience init(hq_title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false) {
        
        let btn = UIButton(hq_title: hq_title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        
        if isBack {
            let imageName = "nav_back"
            btn.setImage(UIImage.init(named: imageName), for: .normal)
            btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        // self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}
