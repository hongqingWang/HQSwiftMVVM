//
//  HQStatusListViewModel.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/18.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import Foundation

/// 上拉刷新的最大次数
fileprivate let maxPullupTryTimes = 3

/// 微博数据列表视图模型
class HQStatusListViewModel {
    
    lazy var statusList = [HQStatus]()
    
    /// 上拉刷新错误次数
    fileprivate var pullupErrorTimes = 0
    
    /// 加载微博数据字典数组
    ///
    /// - Parameters:
    ///   - completion: 完成回调,微博字典数组/是否成功
    func loadStatus(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            
            completion(true, false)
            print("超出3次 不再走网络请求方法")
            return
        }
        
        // 取出微博中已经加载的第一条微博(最新的一条微博)的`since_id`进行比较,对下拉刷新做处理
        let since_id = pullup ? 0 : (statusList.first?.id ?? 0)
        // 上拉刷新,取出数组的最后一条微博`id`
        let max_id = !pullup ? 0 : (statusList.last?.id ?? 0)
        
        HQNetWorkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            guard let array = NSArray.yy_modelArray(with: HQStatus.classForCoder(), json: list ?? []) as? [HQStatus] else {
                
                completion(isSuccess, false)
                
                return
            }
            print("刷新到 \(array.count) 条数据")
            
            // FIXME: 拼接数据
            if pullup {
                // 上拉刷新结束后,将数据拼接在数组的末尾
                self.statusList += array
                
            } else {
                // 下拉刷新结束后,将数据拼接在数组的最前面
                self.statusList = array + self.statusList
            }
            
            if pullup && array.count == 0 {
                
                self.pullupErrorTimes += 1
                print("这是第 \(self.pullupErrorTimes) 次 加载到 0 条数据")
                completion(isSuccess, false)
                
            } else {
                completion(isSuccess, true)
            }
        }
    }
}
