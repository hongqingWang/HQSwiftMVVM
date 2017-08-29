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
