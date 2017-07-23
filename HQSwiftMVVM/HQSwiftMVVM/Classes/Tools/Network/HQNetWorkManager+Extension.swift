//
//  HQNetWorkManager+Extension.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/18.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import Foundation

extension HQNetWorkManager {
    
    /// 微博数据字典数组
    ///
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0
    ///   - completion: 微博字典数组/是否成功
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // `swift`中,`Int`可以转换成`Anybject`,但是`Int 64`不行
        let para = [
            "since_id": "\(since_id)",
            "max_id": "\(max_id > 0 ? (max_id - 1) : 0)"
        ]
        
        tokenRequest(URLString: urlString, parameters: para as [String : AnyObject]) { (json, isSuccess) in
            /*
             从`json`中获取`statuses`字典数组
             如果`as?`失败,`result = nil`
             */
            let result = (json as AnyObject)["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
    
    /// 未读微博数量
    ///
    /// - Parameter completion: unreadCount
    func unreadCount(completion: @escaping (_ count: Int)->()) {
        
        guard let uid = uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let para = ["uid": uid]
        
        tokenRequest(URLString: urlString, parameters: para as [String : AnyObject]) { (json, isSuccess) in
            
            let dict = json as? [String: AnyObject]
            let count = dict?["status"] as? Int
            
            completion(count ?? 0)
        }
    }
}
