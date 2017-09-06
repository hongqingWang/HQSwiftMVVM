//
//  HQStatusPicture.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/9/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

/// 微博配图模型
class HQStatusPicture: NSObject {

    /// 缩略图地址
    var thumbnail_pic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    /****************** 没走此方法 ******************/
    /*
     告诉第三方框架`YYModel`,如果遇到数组类型的属性,数组中存放的对象是什么类
     NSArray 中保存对象的类型通常是`id`类型
     OC 中的泛型是 Swift 推出后,苹果为了兼容给 OC 增加的
     从运行时的角度,仍然不知道数组中应该存放什么类型的对象
     */
    class func modelContainerPropertyGenericClass() -> [String : AnyClass] {
        return ["pic_urls" : HQStatusPicture.classForCoder()]
    }
}
