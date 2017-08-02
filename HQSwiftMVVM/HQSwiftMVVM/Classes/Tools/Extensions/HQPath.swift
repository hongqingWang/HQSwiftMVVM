//
//  HQPath.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/8/2.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension String {
    
    /// DocumentDirectory 路径
    ///
    /// - Parameter fileName: fileName
    /// - Returns: DocumentDirectory 内文件路径
    static func hq_appendDocmentDirectory(fileName: String) -> String? {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return (path as NSString).appendingPathComponent(fileName)
    }
    
    /// Caches 路径
    ///
    /// - Parameter fileName: fileName
    /// - Returns: Cacher 内文件路径
    static func hq_appendCachesDirectory(fileName: String) -> String? {
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return (path as NSString).appendingPathComponent(fileName)
    }
    
    /// Tmp 路径
    ///
    /// - Parameter fileName: fileName
    /// - Returns: Tmp 内文件路径
    static func hq_appendTmpDirectory(fileName: String) -> String? {
        
        let path = NSTemporaryDirectory()
        return (path as NSString).appendingPathComponent(fileName)
    }
}
