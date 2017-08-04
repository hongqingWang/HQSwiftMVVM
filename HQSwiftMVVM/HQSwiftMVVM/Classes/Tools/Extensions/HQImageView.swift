//
//  HQImageView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/11.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    /// 图片名称
    ///
    /// - Parameter hq_imageName: imageName
    convenience init(hq_imageName: String) {
        self.init(image: UIImage.init(named: hq_imageName))
    }
}

// MARK: - 隔离`SDWebImage框架`
extension UIImageView {
    
    /// 隔离`SDWebImage`设置图像函数
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholderImage: placeholderImage
    ///   - isAvatar: 是否是头像(圆角)
    func hq_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        guard let urlString = urlString,
            let url = URL(string: urlString)
            else {
                
                image = placeholderImage
                return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { [weak self] (image, _, _, _) in
            
            if isAvatar {
                self?.image = image?.hq_avatarImage(size: self?.bounds.size)
            }
        }
    }
}
