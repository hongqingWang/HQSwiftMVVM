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
    
    fileprivate lazy var listViewModel = HQStatusListViewModel()

    /// 加载数据
    override func loadData() {
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            print("最后一条微博数据是 \(self.listViewModel.statusList.last?.text ?? "")")
            
            self.refreshControl?.endRefreshing()
            self.isPullup = false
            
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc fileprivate func showFriends() {
        
        HQNetWorkManager.shared.userAccount.token = "aaa"
        
//        let vc = HQDemoViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - tableViewDataSource
extension HQAViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text
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
        
        setupNavTitle()
    }
    
    /// 设置导航栏标题演示
    fileprivate func setupNavTitle() {
        
        let btn = UIButton(hq_title: "王红庆", fontSize: 17, normalColor: UIColor.darkGray, highlightedColor: UIColor.red)
        btn.setImage(UIImage(named: "nav_arrow_down"), for: .normal)
        btn.setImage(UIImage(named: "nav_arrow_up"), for: .selected)
        navItem.titleView = btn
        
        btn.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
    }
    
    @objc fileprivate func clickTitleButton(btn: UIButton) {
    
        btn.isSelected = !btn.isSelected
    }
}
