//
//  HQACellTopView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/8/28.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQACellTopView: UIView {

    fileprivate lazy var carveView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.hq_screenWidth(), height: 8))
        view.backgroundColor = UIColor.hq_color(withHex: 0xF2F2F2)
        return view
    }()
    /// 头像
    fileprivate lazy var avatarImageView: UIImageView = UIImageView(hq_imageName: "avatar_default_big")
    /// 姓名
    fileprivate lazy var nameLabel: UILabel = UILabel(hq_title: "王红庆", fontSize: 13, color: UIColor.hq_color(withHex: 0xFC3E00))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HQACellTopView {
    
    fileprivate func setupUI() {
        
        addSubview(carveView)
        addSubview(avatarImageView)
        addSubview(nameLabel)
        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(carveView.snp.bottom)
            make.left.equalTo(self).offset(margin)
            make.width.equalTo(AvatarImageViewWidth)
            make.height.equalTo(AvatarImageViewWidth)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView).offset(4)
            make.left.equalTo(avatarImageView.snp.right).offset(margin - 4)
        }
    }
}
