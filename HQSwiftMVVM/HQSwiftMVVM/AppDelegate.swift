//
//  AppDelegate.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = HQMainViewController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        setupNotification(application: application)
        
        return true
    }
}

extension AppDelegate {
    
    fileprivate func loadAppInfo() {
        
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            let data = NSData(contentsOf: url!)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (path as NSString).appendingPathComponent("main.json")
            data?.write(toFile: jsonPath, atomically: true)
        }
    }
}

extension AppDelegate {
    
    fileprivate func setupNotification(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (sucess, error) in
                print("授权" + (sucess ? "成功" : "失败"))
            }
        } else {
            // Fallback on earlier versions
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
    }
}
