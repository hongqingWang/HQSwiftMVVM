//
//  HQAViewController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

fileprivate let cellId = "cellId"

class HQAViewController: HQBaseViewController {

    fileprivate lazy var statusList = [String]()
    
    /// 加载数据
    override func loadData() {
        
        HQNetWorkManager.shared.statusList { (list, isSuccess) in
            print(list ?? "")
        }
        //        print("开始加载数据 \(HQNetWorkManager.shared)")
        
        // 模拟`延时`加载数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            for i in 0..<15 {
                
                if self.isPullup {
                    self.statusList.append("上拉 \(i)")
                } else {
                    self.statusList.insert(i.description, at: 0)
                }
            }
            self.refreshControl?.endRefreshing()
            self.isPullup = false
            self.tableView?.reloadData()
        }
    }
     
    @objc fileprivate func showFriends() {
        
        let vc = HQDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - tableViewDataSource
extension HQAViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = statusList[indexPath.row]
        return cell
    }
}

// MARK: - 设置界面
extension HQAViewController {
    
    /// 重写父类的方法
    override func setupTableView() {
        super.setupTableView()
        
        navItem.leftBarButtonItem = UIBarButtonItem(hq_title: "好友", target: self, action: #selector(showFriends))
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellId)
    }
}
