//
//  HQLable.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/11.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 标题 + 字体 + 字体颜色
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - fontSize: fontSize 默认 14
    ///   - color: color
    convenience init(hq_title: String, fontSize: CGFloat = 14, color: UIColor = UIColor.darkGray) {
        self.init()
        
        text = hq_title
        font = UIFont.systemFont(ofSize: fontSize)
        textColor = color
        numberOfLines = 0
    }
}
