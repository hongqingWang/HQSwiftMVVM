//
//  HQBarButtonItem.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/7.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 字体+target+action
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - fontSize: fontSize
    ///   - target: target
    ///   - action: action
    convenience init(hq_title: String, fontSize: CGFloat = 16, target: Any?, action: Selector) {
        
        let btn = UIButton(hq_title: hq_title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(target, action: action, for: .touchUpInside)
        // self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}
