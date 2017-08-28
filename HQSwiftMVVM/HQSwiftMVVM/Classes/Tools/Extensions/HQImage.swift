//
//  HQImage.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/25.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 根据(颜色 + 尺寸)快速创建图片
    ///
    /// - Parameters:
    ///   - hq_color: color
    ///   - size: size
    convenience init?(hq_color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        hq_color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

// MARK: - 创建图像的自定义方法
extension UIImage {
    
    /// 创建圆角图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景色(默认`white`)
    ///   - lineColor: 线的颜色(默认`lightGray`)
    /// - Returns: 裁切后的图像
    func hq_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 1.图像的上下文-内存中开辟一个地址,跟屏幕无关
        /**
         * 1.绘图的尺寸
         * 2.不透明:false(透明) / true(不透明)
         * 3.scale:屏幕分辨率,默认情况下生成的图像使用'1.0'的分辨率,图像质量不好
         *         可以指定'0',会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        // 背景填充(在裁切之前做填充)
        backColor.setFill()
        UIRectFill(rect)
        
        // 1> 实例化一个圆形的路径
        let path = UIBezierPath(ovalIn: rect)
        // 2> 进行路径裁切 - 后续的绘图,都会出现在圆形路径内部,外部的全部干掉
        path.addClip()
        
        // 2.绘图'drawInRect'就是在指定区域内拉伸屏幕
        draw(in: rect)
        
        // 3.绘制内切的圆形
        UIColor.darkGray.setStroke()
        path.lineWidth = 1      // 默认是'1'
        path.stroke()
        
        // 4.取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        
        // 6.返回结果
        return result
    }
    
    /// 创建矩形图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景色(默认`white`)
    ///   - lineColor: 线的颜色(默认`lightGray`)
    /// - Returns: 裁切后的图像
    func hq_rectImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 1.图像的上下文-内存中开辟一个地址,跟屏幕无关
        /**
         * 1.绘图的尺寸
         * 2.不透明:false(透明) / true(不透明)
         * 3.scale:屏幕分辨率,默认情况下生成的图像使用'1.0'的分辨率,图像质量不好
         *         可以指定'0',会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        // 2.绘图'drawInRect'就是在指定区域内拉伸屏幕
        draw(in: rect)
        
        // 3.取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4.关闭上下文
        UIGraphicsEndImageContext()
        
        // 5.返回结果
        return result
    }
}
