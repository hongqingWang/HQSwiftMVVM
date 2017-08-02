//
//  HQUserAccount.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/31.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

fileprivate let fileName = "useraccount.json"

class HQUserAccount: NSObject {
    
    /// Token
    var token: String? //= "2.00It5tsGKXtWQEfb6d3a2738ImMUAD"
    /// 用户代号
    var uid: String?
    /// `Token`的生命周期,单位是`秒`
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expiresDate: Date?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        
        guard let path = String.hq_appendDocmentDirectory(fileName: fileName),
            let data = NSData(contentsOfFile: path),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject]
            else {
            return
        }
        
        yy_modelSet(with: dict ?? [:])
    }
    
    /*
     数据存储方式:
     - 1.偏好设置
     - 2.沙盒-归档/`plist`/`json`
     - 3.数据库(`FMDB`/CoreData)
     - 4.钥匙串访问(存储小类型数据,存储时会自动加密,需要使用框架`SSKeyChain`)
     */
    func saveAccount() {

        // 1.模型转字典
        var dict = self.yy_modelToJSONObject() as? [String: AnyObject] ?? [:]
        // 删除`expires_in`值
        dict.removeValue(forKey: "expires_in")
        
        // 2.字典序列化`data`
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let filePath = String.hq_appendDocmentDirectory(fileName: fileName)
            else {
                return
        }
        
        // 3.写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
    }
}
