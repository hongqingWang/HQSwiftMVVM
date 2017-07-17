//
//  HQNetWorkManager.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/14.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit
import AFNetworking

enum HQHTTPMethod {
    case GET
    case POST
}

class HQNetWorkManager: AFHTTPSessionManager {
    
    static let shared = HQNetWorkManager()
    
    /// 封装 AFN 的 GET/POST 请求
    ///
    /// - Parameters:
    ///   - method: GET/POST
    ///   - URLString: URLString
    ///   - parameters: parameters
    ///   - completion: 完成回调(json, isSuccess)
    func request(method: HQHTTPMethod = .GET, URLString: String, parameters: [String: Any], completion: @escaping (_ json: Any?, _ isSuccess: Bool)->()) {
        
        let success = { (task: URLSessionDataTask, json: Any?)->() in
            completion(json, true)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
            print("网络请求错误 \(error)")
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
    }
}
