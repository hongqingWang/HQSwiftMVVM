//
//  HQACellTopView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/8/28.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQACellTopView: UIView {

    var viewModel: HQStatusViewModel? {
        didSet {
            avatarImageView.hq_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon?.hq_rectImage(size: CGSize(width: 17, height: 17))
            vipIconImageView.image = viewModel?.vipIcon
        }
    }
    
    fileprivate lazy var carveView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.hq_screenWidth(), height: 8))
        view.backgroundColor = UIColor.hq_color(withHex: 0xF2F2F2)
        return view
    }()
    /// 头像
    fileprivate lazy var avatarImageView: UIImageView = UIImageView(hq_imageName: "avatar_default_big")
    /// 姓名
    fileprivate lazy var nameLabel: UILabel = UILabel(hq_title: "吴彦祖", fontSize: 14, color: UIColor.hq_color(withHex: 0xFC3E00))
    /// 会员
    fileprivate lazy var memberIconView: UIImageView = UIImageView(hq_imageName: "common_icon_membership_level1")
    /// 时间
    fileprivate lazy var timeLabel: UILabel = UILabel(hq_title: "现在", fontSize: 11, color: UIColor.hq_color(withHex: 0xFF6C00))
    /// 来源
    fileprivate lazy var sourceLabel: UILabel = UILabel(hq_title: "来源", fontSize: 11, color: UIColor.hq_color(withHex: 0x828282))
    /// 认证
    fileprivate lazy var vipIconImageView: UIImageView = UIImageView(hq_imageName: "avatar_vip")
    
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
        addSubview(memberIconView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(vipIconImageView)
        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(carveView.snp.bottom).offset(margin)
            make.left.equalTo(self).offset(margin)
            make.width.equalTo(AvatarImageViewWidth)
            make.height.equalTo(AvatarImageViewWidth)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView).offset(4)
            make.left.equalTo(avatarImageView.snp.right).offset(margin - 4)
        }
        memberIconView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(margin / 2)
            make.centerY.equalTo(nameLabel)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(avatarImageView)
        }
        sourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(margin / 2)
            make.centerY.equalTo(timeLabel)
        }
        vipIconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatarImageView.snp.right).offset(-4)
            make.centerY.equalTo(avatarImageView.snp.bottom).offset(-4)
        }
    }
}
