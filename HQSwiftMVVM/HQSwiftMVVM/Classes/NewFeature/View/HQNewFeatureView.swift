//
//  HQNewFeatureView.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/8/17.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQNewFeatureView: UIView {

    /// 开始体验按钮
    fileprivate lazy var startButton: UIButton = UIButton(hq_title: "开始体验", color: UIColor.white, backImageName: "new_feature_finish_button")
    /// pageControl
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Target Action
extension HQNewFeatureView {
    
    @objc fileprivate func enter() {
        removeFromSuperview()
    }
}

// MARK: - UIScrollViewDelegate
extension HQNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 滚动到最后一个空白页面,将新特性页面从父视图移除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        // 如果不是倒数第二页,那么就隐藏`startButton`按钮
        startButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 一旦滚动,隐藏按钮
        startButton.isHidden = true
        
        // 设置当前的偏移量,+0.5是为了处理`scrollView`滚动超过屏幕一半的时候,`pageControl`也滚动到下一页
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        // 设置分页控件
        pageControl.currentPage = page
        
        // 分页控件的隐藏,滚动到最后一页的时候
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}

// MARK: - UI
extension HQNewFeatureView {
    
    /// setupUI
    fileprivate func setupUI() {
        
        addSubview(scrollView)
        addSubview(startButton)
        addSubview(pageControl)
        
        startButton.isHidden = true
        startButton.addTarget(self, action: #selector(enter), for: .touchUpInside)
        
        setupScrollView()
        
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).multipliedBy(0.7)
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(startButton)
            make.top.equalTo(startButton.snp.bottom).offset(16)
        }
    }
    
    /// setupImageViewFrame
    fileprivate func setupScrollView() {
        
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            
            let imageName = "new_feature_\(i + 1)"
            let iv = UIImageView(hq_imageName: imageName)
            
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        
        /// 设置`scrollView`的属性
        // 这里加`1`是为了让`scrollView`可以多滚动一屏
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
    }
}
