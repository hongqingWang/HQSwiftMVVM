//
//  HQACellPictureView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/9/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQACellPictureView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HQACellPictureView {
    
    fileprivate func setupUI() {
        
        backgroundColor = UIColor.hq_randomColor()
    }
}
