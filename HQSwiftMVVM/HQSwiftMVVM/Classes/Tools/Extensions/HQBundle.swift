//
//  HQBundle.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/7.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension Bundle {
    
    // 计算型属性类似于函数,没有参数,有返回值
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
