//
//  HQACell.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/8/28.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

/// 头像的宽度
let AvatarImageViewWidth: CGFloat = 35

class HQACell: UITableViewCell {

    var viewModel: HQStatusViewModel? {
        didSet {
            
            topView.viewModel = viewModel
            contentLabel.text = viewModel?.status.text
            bottomView.viewModel = viewModel
            
            pictureView.snp.updateConstraints { (make) in
                make.height.equalTo(10)
            }
        }
    }
    
    /// 顶部视图
    fileprivate lazy var topView: HQACellTopView = HQACellTopView()
    /// 正文
    fileprivate lazy var contentLabel: UILabel = UILabel(hq_title: "正文", fontSize: 15, color: UIColor.darkGray)
    /// 配图视图
    fileprivate lazy var pictureView: HQACellPictureView = HQACellPictureView()
    /// 底部视图
    fileprivate lazy var bottomView: HQACellBottomView = HQACellBottomView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HQACell {
    
    fileprivate func setupUI() {
        
        addSubview(topView)
        addSubview(contentLabel)
        addSubview(pictureView)
        addSubview(bottomView)
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(margin * 2 + AvatarImageViewWidth)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(margin / 2)
            make.left.equalTo(self).offset(margin)
            make.right.equalTo(self).offset(-12)
        }
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom)
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
            make.bottom.equalTo(bottomView.snp.top).offset(-12)
            make.height.equalTo(300)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(44)
            make.bottom.equalTo(self)
        }
    }
}
