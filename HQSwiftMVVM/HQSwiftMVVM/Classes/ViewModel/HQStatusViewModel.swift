//
//  HQStatusViewModel.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/8/30.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQStatusViewModel: CustomStringConvertible {
    
    var status: HQStatus
    
    /// 会员图标
    var memberIcon: UIImage?
    
    init(model: HQStatus) {
        self.status = model
        
        // 会员等级
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
    }
    
    var description: String {
        return status.description
    }
}
