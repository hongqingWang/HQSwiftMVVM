//
//  HQUserAccount.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/31.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQUserAccount: NSObject {
    
    /// Token
    var token: String? //= "2.00It5tsGKXtWQEfb6d3a2738ImMUAD"
    /// 用户代号
    var uid: String?
    /// `Token`的生命周期,单位是`秒`
    var expires_in: TimeInterval = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
