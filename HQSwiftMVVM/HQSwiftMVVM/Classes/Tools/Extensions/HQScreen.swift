//
//  HQScreen.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/7.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UIScreen {
    
    /// 屏幕的宽度
    ///
    /// - Returns: ScreenWidth
    class func hq_screenWidth() -> CGFloat {
        
        return UIScreen.main.bounds.size.width
    }
    
    /// 屏幕的高度
    ///
    /// - Returns: ScreenHeight
    class func hq_screenHeight() -> CGFloat {
        
        return UIScreen.main.bounds.size.height
    }
    
    /// 屏幕宽高比
    ///
    /// - Returns: ScreenWidth / ScreenHeight
    class func hq_scale() -> CGFloat {
        
        let w = CGFloat(UIScreen.hq_screenWidth())
        let h = CGFloat(UIScreen.hq_screenHeight())
        
        return w / h
    }
}
