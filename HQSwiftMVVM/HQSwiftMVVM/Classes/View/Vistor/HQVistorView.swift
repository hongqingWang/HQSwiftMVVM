//
//  HQVistorView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/11.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQVistorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 私有控件
    
    /// 图像视图
    fileprivate lazy var iconImageView: UIImageView = UIImageView(hq_imageName: "visitordiscover_feed_image_smallicon")
    /// 小房子
    fileprivate lazy var houseImageView: UIImageView = UIImageView(hq_imageName: "visitordiscover_feed_image_house")
    /// 提示标签
    fileprivate lazy var tipLabel: UILabel = UILabel(hq_title: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜")
    /// 注册按钮
    fileprivate lazy var registerButton: UIButton = UIButton(hq_title: "注册", color: UIColor.orange, backImageName: "common_button_white_disable")
    /// 登录按钮
    fileprivate lazy var loginButton: UIButton = UIButton(hq_title: "登录", color: UIColor.darkGray, backImageName: "common_button_white_disable")
    
}

// MARK: - 设置访客视图界面
extension HQVistorView {
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        
        addSubview(iconImageView)
        addSubview(houseImageView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 取消 autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        /*
         利用原生自动布局代码进行自动布局
         自动布局本质公式:
         firstItem.firstAttribute {==,<=,>=} secondItem.secondAttribute * multiplier + constant
         */
        let margin: CGFloat = 20.0
        
        /// 图像视图
        addConstraint(NSLayoutConstraint(item: iconImageView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        /// 小房子
        addConstraint(NSLayoutConstraint(item: houseImageView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconImageView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseImageView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconImageView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        /// 提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconImageView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconImageView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 236))
        /// 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        /// 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
    }
}
