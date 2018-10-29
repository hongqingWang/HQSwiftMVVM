//
//  HQACellPictureView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/9/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQACellPictureView: UIView {
    
    /// 配图视图的数组
    var urls: [HQStatusPicture]? {
        didSet {
            
            // 隐藏所有的`ImageView`
            for v in subviews {
                v.isHidden = true
            }
            
            // 遍历`urls`数组,顺序设置图像
            var index = 0
            
            
//            for url in urls ?? [] {
//                
//                // 获得对应索引的`ImageView`
//                let iv = subviews[index] as! UIImageView
//                
//                // 设置图像
////                iv.hq_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
////                
////                // 显示图像
////                iv.isHidden = false
//                
//                index += 1
//            }
        }
    }
    
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
        
        // 超出边界不显示
        clipsToBounds = true
        
        backgroundColor = UIColor.hq_randomColor()
        /*
         - `cell`中所有的控件都是提前准备好
         - 设置的时候,根据数据决定是否显示
         - 不要动态创建控件
         */
        
        let count = 3
        
        let rect = CGRect(x: 0,
                          y: HQStatusPictureViewOutterMargin,
                          width: HQStatusPictureItemWidth,
                          height: HQStatusPictureItemWidth)
        
        
        for i in 0..<count * count {
            
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.red
            
            // 行 -> Y
            let row = CGFloat(i / count)
            // 列 -> X
            let col = CGFloat(i % count)
            
            let xOffset = col * (HQStatusPictureItemWidth + HQStatusPictureViewInnerMargin)
            let yOffset = row * (HQStatusPictureItemWidth + HQStatusPictureViewInnerMargin)
            
            imageView.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(imageView)
        }
    }
}
