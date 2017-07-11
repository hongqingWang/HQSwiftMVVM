//
//  HQImageView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/11.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 图片名称
    ///
    /// - Parameter hq_imageName: imageName
    convenience init(hq_imageName: String) {
        self.init(image: UIImage.init(named: hq_imageName))
    }
}
