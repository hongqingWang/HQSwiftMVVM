//
//  HQButton.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/7.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

/// 获取验证码按钮
class HQButton: UIButton {
    
    fileprivate var hq_timer: Timer?
    fileprivate var hq_remindTime: NSInteger?
    
    func timeDown(time: NSInteger) {
        
        isEnabled = false
        
        if #available(iOS 10.0, *) {
            hq_timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                
                self.timeFire()
            })
        } else {
            // Fallback on earlier versions
            hq_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeFire), userInfo: nil, repeats: true)
        }
        hq_remindTime = time
    }
    
    @objc fileprivate func timeFire() {
        
        if hq_remindTime! > 1 {
            
            hq_remindTime! -= 1
            setTitle("\(hq_remindTime!)s后重新获取", for: .disabled)
            print("\(hq_remindTime!)s后重新获取")
        } else {
            
            isEnabled = true
            hq_timer?.invalidate()
            hq_timer = nil
            setTitle("获取验证码", for: .normal)
        }
    }
}

extension UIButton {
    
    /// 图片 + 背景图片
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
    
    /// 标题 + 字体颜色
    ///
    /// - Parameters:
    ///   - hq_title: 标题
    ///   - fontSize: 字号(默认 16 号)
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
    
    /// 标题 + 文字颜色 + 背景图片
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - color: color
    ///   - backImageName: backImageName
    convenience init(hq_title: String, color: UIColor, backImageName: String) {
        self.init()
        
        setTitle(hq_title, for: .normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage.init(named: backImageName), for: .normal)
        
        sizeToFit()
    }
    
    /// 标题 + 字号 + 背景色 + 高亮背景色
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - fontSize: fontSize
    ///   - normalBackColor: normalBackColor
    ///   - highBackColor: highBackColor
    ///   - size: size
    convenience init(hq_title: String, fontSize: CGFloat = 16, normalBackColor: UIColor, highBackColor: UIColor, size: CGSize) {
        self.init()
        
        setTitle(hq_title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        let normalIamge = UIImage(hq_color: normalBackColor, size: CGSize(width: size.width, height: size.height))
        let hightImage = UIImage(hq_color: highBackColor, size: CGSize(width: size.width, height: size.height))
        
        setBackgroundImage(normalIamge, for: .normal)
        setBackgroundImage(hightImage, for: .highlighted)

        layer.cornerRadius = 3
        clipsToBounds = true
        
        // 注意: 这里不写`sizeToFit()`那么`Button`就显示不出来
        sizeToFit()
    }
}

// MARK: - 创建`Button`的扩展方法
extension UIButton {
    
    /// 通过颜色创建图片
    ///
    /// - Parameters:
    ///   - color: color
    ///   - size: size
    /// - Returns: 固定颜色和尺寸的图片
    fileprivate func creatImageWithColor(color: UIColor, size: CGSize) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
