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
    
    /// 微博视图模型的懒加载
    lazy var statusList = [HQStatusViewModel]()
    
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
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        // 上拉刷新,取出数组的最后一条微博`id`
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        HQNetWorkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            // 如果网络请求失败,直接执行完成回调
            if !isSuccess {
                
                completion(false, false)
                return
            }
            
            /*
             遍历字典数组,字典转模型
             模型->视图模型
             将视图模型添加到数组
             */
            var arrayM = [HQStatusViewModel]()
            
            for dict in list ?? [] {
                
                // 创建微博模型
                let status = HQStatus()
                
                // 字典转模型
                status.yy_modelSet(with: dict)
                
                /********** 测试改变一下YYModel产生的问题 **********/
                
                /// 缩略图地址
//                var thumbnail_pic: String?
//                var pic_urls: [String : AnyObject]?
                
//                pic_urls = dict["pic_urls"] as! [String : AnyObject]
                
//                print("---\(pic_urls)")
                
                /********** 测试改变一下YYModel产生的问题 **********/
                
                // 使用`HQStatus`创建`HQStatusViewModel`
                let viewModel = HQStatusViewModel(model: status)
                
                // 添加到数组
                arrayM.append(viewModel)
            }
            
            print("刷新到 \(arrayM.count) 条数据 \(arrayM)")
            
            // 拼接数据
            if pullup {
                // 上拉刷新结束后,将数据拼接在数组的末尾
                self.statusList += arrayM
                
            } else {
                // 下拉刷新结束后,将数据拼接在数组的最前面
                self.statusList = arrayM + self.statusList
            }
            
            if pullup && arrayM.count == 0 {
                
                self.pullupErrorTimes += 1
                print("这是第 \(self.pullupErrorTimes) 次 加载到 0 条数据")
                completion(isSuccess, false)
                
            } else {
                completion(isSuccess, true)
            }
        }
    }
}
