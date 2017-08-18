//
//  HQWelcomeView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/8/17.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQWelcomeView: UIView {

    fileprivate lazy var backImageView: UIImageView = UIImageView(hq_imageName: "ad_background")
    /// 头像
    fileprivate lazy var avatarImageView: UIImageView = {
        
        let iv = UIImageView(hq_imageName: "avatar_default_big")
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    fileprivate lazy var welcomeLabel: UILabel = {
       
        let label = UILabel(hq_title: "欢迎归来", fontSize: 18, color: UIColor.hq_titleTextColor)
        label.alpha = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Animation
extension HQWelcomeView {
    
    /// 视图被添加到`window`上,表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 将代码布局的约束都创建好并显示出来，然后再进行下一步的更新动画
        layoutIfNeeded()
        
        /// 设置头像
        setAvatar()
        
        avatarImageView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self).offset(-bounds.size.height + 200)
        }

        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: { 
                        self.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: 1.0,
                           animations: { 
                            self.welcomeLabel.alpha = 1
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
    
    /// 设置头像
    fileprivate func setAvatar() {
        
        guard let urlString = HQNetWorkManager.shared.userAccount.avatar_large else {
            return
        }
        avatarImageView.hq_setImage(urlString: urlString, placeholderImage: UIImage(named: "avatar_default_big"))
    }
}

// MARK: - UI
extension HQWelcomeView {
    
    fileprivate func setupUI() {
        
        addSubview(backImageView)
        addSubview(avatarImageView)
        addSubview(welcomeLabel)
        
        backImageView.frame = self.bounds
        avatarImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-200)
            make.centerX.equalTo(self)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.centerX.equalTo(avatarImageView)
        }
    }
}
