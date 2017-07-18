//
//  HQStatusListViewModel.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/18.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import Foundation

/// 微博数据列表视图模型
class HQStatusListViewModel {
    
    lazy var statusList = [HQStatus]()
    
    func loadStatus(completion: @escaping (_ isSuccess: Bool)->()) {
        
        HQNetWorkManager.shared.statusList { (list, isSuccess) in
            
            guard let array = NSArray.yy_modelArray(with: HQStatus.classForCoder(), json: list ?? []) as? [HQStatus] else {
                
                completion(isSuccess)
                
                return
            }
            
            self.statusList += array
            
            completion(isSuccess)
        }
    }
}
