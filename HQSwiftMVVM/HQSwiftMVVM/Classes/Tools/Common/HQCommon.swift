//
//  HQCommon.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/25.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

// MARK: - 全局通知定义
/// 用户需要登录通知
let HQUserShouldLoginNotification = "HQUserShouldLoginNotification"
/// 用户登录成功通知
let HQUserLoginSuccessNotification = "HQUserLoginSuccessNotification"

// MARK: - 常量
/// 边距
let margin: CGFloat = 16

// MARK: - 接口
/// 首页微博
let HQHomeUrlString = "https://api.weibo.com/2/statuses/home_timeline.json"
/// 个人信息
let HQUserInfoUrlString = "https://api.weibo.com/2/users/show.json"

// MARK: - 微博配图视图常量
// 配图视图的外侧间距
let HQStatusPictureViewOutterMargin: CGFloat = 12
// 配图视图的内侧间距
let HQStatusPictureViewInnerMargin: CGFloat = 3
// 视图的宽度
let HQStatusPictureViewWidth: CGFloat = UIScreen.hq_screenWidth() - 2 * HQStatusPictureViewOutterMargin
// 每个`Item`默认宽度
let HQStatusPictureItemWidth: CGFloat = (HQStatusPictureViewWidth - 2 * HQStatusPictureViewInnerMargin) / 3
