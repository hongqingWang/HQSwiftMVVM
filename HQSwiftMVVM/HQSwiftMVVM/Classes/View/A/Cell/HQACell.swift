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
            
            contentLabel.text = viewModel?.status.text
            topView.viewModel = viewModel
        }
    }
    
    /// 顶部视图
    fileprivate lazy var topView: HQACellTopView = HQACellTopView()
    /// 正文
    fileprivate lazy var contentLabel: UILabel = UILabel(hq_title: "正文", fontSize: 15, color: UIColor.darkGray)
    
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
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(margin * 2 + AvatarImageViewWidth)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(margin / 2)
            make.left.equalTo(self).offset(margin)
            make.right.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(-margin / 2)
        }
    }
}
