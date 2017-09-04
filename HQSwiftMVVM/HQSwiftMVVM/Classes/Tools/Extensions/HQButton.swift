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

/// 文字在左、图片在右的 Button
class HQTitleButton: UIButton {
    
    /// 重载构造函数
    ///
    /// - Parameter title: title 如果是 nil,就显示首页
    /// - Parameter title: title 如果不是 nil,显示 title 和 箭头
    init(title: String?) {
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle(title! + " ", for: .normal)
            setImage(UIImage(named: "nav_arrow_down"), for: .normal)
            setImage(UIImage(named: "nav_arrow_up"), for: .selected)
        }
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        
        // 设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 判断`label`和`imageView`是否同时存在
        guard let titleLabel = titleLabel,
            let imageView = imageView
            else {
                return
        }
        
        // 将`titleLabel`的`x`向左移动`imageView`的`width`,值得注意的是,这里我们需要将`width / 2`
        titleEdgeInsets = UIEdgeInsetsMake(0, -imageView.bounds.width, 0, imageView.bounds.width)
        // 将`imageView`的`x`向右移动`titleLabel`的`width`,值得注意的是,这里我们需要将`width / 2`
        imageEdgeInsets = UIEdgeInsetsMake(0, titleLabel.bounds.width, 0, -titleLabel.bounds.width)
        /********** 下面这种做法不推荐 **********/
        // 会有问题
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
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
        setBackgroundImage(UIImage(named: backImageName), for: .normal)
        
        sizeToFit()
    }
    
    /// 标题 + 字号 + 文字颜色 + 图片
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - fontSize: fontSize
    ///   - color: color
    ///   - backImageName: backImageName
    convenience init(hq_title: String, fontSize: CGFloat, color: UIColor, imageName: String, backImage: String) {
        self.init()
        
        setTitle(hq_title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setTitleColor(color, for: .normal)
        setImage(UIImage(named: imageName), for: .normal)
        
        setBackgroundImage(UIImage(named: backImage), for: .normal)
        
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
