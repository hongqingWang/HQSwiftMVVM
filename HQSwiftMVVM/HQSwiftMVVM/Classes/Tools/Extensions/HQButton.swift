//
//  HQButton.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/7.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 图片+背景图片
    ///
    /// - Parameters:
    ///   - imageName: 图像名称
    ///   - backImageName: 背景图像名称
    convenience init(hq_imageName: String, backImageName: String?) {
        self.init()
        
        setImage(UIImage(named: hq_imageName), for: .normal)
        setImage(UIImage(named: hq_imageName + "_highlighted"), for: .highlighted)
        
        if let backImageName = backImageName {
            setBackgroundImage(UIImage(named: backImageName), for: .normal)
            setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: .highlighted)
        }
        
        // 根据背景图片大小调整尺寸
        sizeToFit()
    }
    
    
    /// 标题+字体颜色
    ///
    /// - Parameters:
    ///   - hq_title: 标题
    ///   - fontSize: 字号(optional)
    ///   - normalColor: normalColor
    ///   - highlightedColor: highlightedColor
    convenience init(hq_title: String, fontSize: CGFloat = 16, normalColor: UIColor, highlightedColor: UIColor) {
        self.init()
        
        setTitle(hq_title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setTitleColor(normalColor, for: .normal)
        setTitleColor(highlightedColor, for: .highlighted)
        
        // 注意: 这里不写`sizeToFit()`那么`Button`就显示不出来
        sizeToFit()
    }
    
    //    /// 便利构造函数
    //    ///
    //    /// - parameter title:          title
    //    /// - parameter color:          color
    //    /// - parameter backImageName:  背景图像
    //    ///
    //    /// - returns: UIButton
    //    convenience init(title: String, color: UIColor, backImageName: String) {
    //        self.init()
    //
    //        setTitle(title, forState: .Normal)
    //        setTitleColor(color, forState: .Normal)
    //
    //        setBackgroundImage(UIImage(named: backImageName), forState: .Normal)
    //
    //        sizeToFit()
    //    }
    //
    //    /// 便利构造函数
    //    ///
    //    /// - parameter title:     title
    //    /// - parameter color:     color
    //    /// - parameter fontSize:  字体大小
    //    /// - parameter imageName: 图像名称
    //    /// - parameter backColor: 背景颜色（默认为nil）
    //    ///
    //    /// - returns: UIButton
    //    convenience init(title: String, fontSize: CGFloat, color: UIColor, imageName: String?, backColor: UIColor? = nil) {
    //        self.init()
    //
    //        setTitle(title, forState: .Normal)
    //        setTitleColor(color, forState: .Normal)
    //
    //        if let imageName = imageName {
    //            setImage(UIImage(named: imageName), forState: .Normal)
    //        }
    //
    //        // 设置背景颜色
    //        backgroundColor = backColor
    //
    //        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    //
    //        sizeToFit()
    //    }
}

