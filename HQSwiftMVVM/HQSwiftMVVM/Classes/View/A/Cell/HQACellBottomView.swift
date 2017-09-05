//
//  HQACellBottomView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/9/4.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQACellBottomView: UIView {

    var viewModel: HQStatusViewModel? {
        didSet {
            retweetedButton.setTitle(viewModel?.retweetString, for: .normal)
            commentButton.setTitle(viewModel?.commentString, for: .normal)
            likeButton.setTitle(viewModel?.likeSting, for: .normal)
        }
    }
    
    /// 转发
    fileprivate lazy var retweetedButton: UIButton = UIButton(hq_title: " 转发", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_retweet", backImage: "timeline_card_bottom_background", titleEdge: 5)
    /// 评论
    fileprivate lazy var commentButton: UIButton = UIButton(hq_title: " 评论", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_comment", backImage: "timeline_card_bottom_background", titleEdge: 5)
    /// 赞
    fileprivate lazy var likeButton: UIButton = UIButton(hq_title: " 赞", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_unlike", backImage: "timeline_card_bottom_background", titleEdge: 5)
    /// 分割线
    fileprivate lazy var sepView01: UIImageView = UIImageView(hq_imageName: "timeline_card_bottom_line_highlighted")
    /// 分割线
    fileprivate lazy var sepView02: UIImageView = UIImageView(hq_imageName: "timeline_card_bottom_line_highlighted")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HQACellBottomView {
    
    fileprivate func setupUI() {
        
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        addSubview(retweetedButton)
        addSubview(commentButton)
        addSubview(likeButton)
        addSubview(sepView01)
        addSubview(sepView02)
        
        retweetedButton.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
        }
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedButton)
            make.left.equalTo(retweetedButton.snp.right)
            make.width.equalTo(retweetedButton)
            make.height.equalTo(retweetedButton)
        }
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentButton)
            make.left.equalTo(commentButton.snp.right)
            make.width.equalTo(commentButton)
            make.height.equalTo(commentButton)
            make.right.equalTo(self)
        }
        sepView01.snp.makeConstraints { (make) in
            make.right.equalTo(retweetedButton)
            make.centerY.equalTo(retweetedButton)
        }
        sepView02.snp.makeConstraints { (make) in
            make.right.equalTo(commentButton)
            make.centerY.equalTo(commentButton)
        }
    }
}
