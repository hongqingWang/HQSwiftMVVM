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
    /// 提示标语
    fileprivate lazy var tipLabel: UILabel = UILabel(hq_title: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜")
    /// 注册按钮
    fileprivate lazy var registerButton: UIButton = UIButton(hq_title: "注册", color: UIColor.orange, backImageName: "common_button_white_disable")
    /// 登录按钮
    fileprivate lazy var loginButton: UIButton = UIButton(hq_title: "登录", color: UIColor.darkGray, backImageName: "common_button_white_disable")
    
}

// MARK: - 设置访客视图界面
extension HQVistorView {
    
    func setupUI() {
        backgroundColor = UIColor.white
    }
}
