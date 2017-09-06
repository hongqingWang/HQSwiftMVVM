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
    /// 认证图标(-1:没有认证, 0:认证用户, 2,3,5:企业认证, 220:达人)
    var vipIcon: UIImage?
    
    /// 转发
    var retweetString: String?
    /// 评论
    var commentString: String?
    /// 赞
    var likeSting: String?
    
    /// 配图视图大小
    var pictureViewSize: CGSize?
    
    init(model: HQStatus) {
        self.status = model
        
        // 会员等级
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        // 认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        // 测试数量超过`10000`的情况
//        model.reposts_count = Int(arc4random_uniform(100000))
        // 转发、评论、赞
        retweetString = countString(count: model.reposts_count, defaultString: "转发")
        commentString = countString(count: model.comments_count, defaultString: "评论")
        likeSting = countString(count: model.attitudes_count, defaultString: "赞")
        
        // 自定义配图视图的尺寸
        pictureViewSize = calculatePictureViewSize(count: model.pic_urls?.count)
    }
    
    var description: String {
        return status.description
    }
    
    /// 计算指定配图数量对应的配图视图的大小
    ///
    /// - Parameter count: 配图数量
    /// - Returns: 配图视图的大小
    fileprivate func calculatePictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            return CGSize()
        }
        
        /// 计算配图视图高度
        // 根据`count`计算行数`1~9`
        /*
         1 2 3 (-1)-> 0 1 2 (/3)-> 0 (+1)-> 1
         4 5 6 (-1)-> 3 4 5 (/3)-> 1 (+1)-> 2
         7 8 9 (-1)-> 6 7 8 (/3)-> 2 (+1)-> 3
         */
        let row = (count! - 1) / 3 + 1
        
        // 根据行数算高度
        var height = HQStatusPictureViewOutterMargin
        height += CGFloat(row) * HQStatusPictureItemWidth
        height += CGFloat(row - 1) * HQStatusPictureViewInnerMargin
        
        return CGSize(width: HQStatusPictureViewWidth, height: height)
    }
    
    /*
     如果数量 == 0,    显示默认标题
     如果数量 >= 10000,显示 x.xx 万
     如果数量 < 10000, 显示实际数字
     */
    /// 给定一个数字,返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - defaultString: 默认字符串(转发、评论、赞)
    /// - Returns: 描述结果
    fileprivate func countString(count: Int, defaultString: String) -> String {
        
        if count == 0 {
            return defaultString
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%0.2f 万", CGFloat(count) / 10000)
    }
}
