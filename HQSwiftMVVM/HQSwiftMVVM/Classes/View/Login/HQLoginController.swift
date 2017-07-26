//
//  HQLoginController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/25.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let margin: CGFloat = 16.0
fileprivate let buttonHeight: CGFloat = 40.0

class HQLoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        title = "登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(hq_title: "关闭", target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(hq_title: "注册", target: self, action: #selector(registe))
        
        setupUI()
    }
    
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func registe() {
        print("注册")
    }
    
    // MARK: - 私有控件
    fileprivate lazy var logoImageView: UIImageView = UIImageView(hq_imageName: "logo")
    fileprivate lazy var accountTextField: UITextField = UITextField(hq_placeholder: "13122223333")
    fileprivate lazy var carve01: UIView = {
        let carve = UIView()
        carve.backgroundColor = UIColor.lightGray
        return carve
    } ()
    lazy var passwordTextField: UITextField = UITextField(hq_placeholder: "123456", isSecureText: true)
    fileprivate lazy var carve02: UIView = {
        let carve = UIView()
        carve.backgroundColor = UIColor.lightGray
        return carve
    }()
    fileprivate lazy var loginButton: UIButton = UIButton(hq_title: "登录", normalBackColor: UIColor.orange, highBackColor: UIColor.hq_color(withHex: 0xB5751F), size: CGSize(width: UIScreen.hq_screenWidth() - (margin * 2), height: buttonHeight))
}

// MARK: - 设置登录控制器界面
extension HQLoginController {
    
    fileprivate func setupUI() {
        
        view.addSubview(logoImageView)
        view.addSubview(accountTextField)
        view.addSubview(carve01)
        view.addSubview(passwordTextField)
        view.addSubview(carve02)
        view.addSubview(loginButton)
        
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(margin * 7)
            make.centerX.equalTo(view)
        }
        accountTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(margin * 2)
            make.left.equalTo(view).offset(margin)
            make.right.equalTo(view).offset(-margin)
            make.height.equalTo(buttonHeight)
        }
        carve01.snp.makeConstraints { (make) in
            make.left.equalTo(accountTextField)
            make.bottom.equalTo(accountTextField)
            make.right.equalTo(view)
            make.height.equalTo(0.5)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(accountTextField.snp.bottom)
            make.left.equalTo(accountTextField)
            make.right.equalTo(accountTextField)
            make.height.equalTo(accountTextField)
        }
        carve02.snp.makeConstraints { (make) in
            make.left.equalTo(carve01)
            make.bottom.equalTo(passwordTextField)
            make.right.equalTo(carve01)
            make.height.equalTo(carve01)
        }
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(margin * 2)
            make.left.equalTo(passwordTextField)
            make.right.equalTo(passwordTextField)
            make.height.equalTo(passwordTextField)
        }
    }
}
