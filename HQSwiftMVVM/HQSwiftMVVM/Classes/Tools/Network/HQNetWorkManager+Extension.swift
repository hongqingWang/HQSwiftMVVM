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
    /// - Parameter completion: 微博字典数组/是否成功
    func statusList(completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let para = ["access_token": "2.00It5tsGQ6eDJE4ecbf2d825DCpbBD"]
        
        request(URLString: urlString, parameters: para) { (json, isSuccess) in
            /*
             从`json`中获取`statuses`字典数组
             如果`as?`失败,`result = nil`
             */
            let result = (json as AnyObject)["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
}
