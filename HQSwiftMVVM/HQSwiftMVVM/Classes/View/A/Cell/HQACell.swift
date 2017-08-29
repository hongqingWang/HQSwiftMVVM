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

    fileprivate lazy var topView: HQACellTopView = HQACellTopView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
    }
}
