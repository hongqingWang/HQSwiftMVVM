//
//  HQLable.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/11.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 标题 + 字体 + 字体颜色
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - fontSize: fontSize 默认 14
    ///   - color: color
    convenience init(hq_title: String, fontSize: CGFloat = 14, color: UIColor = UIColor.darkGray) {
        self.init()
        
        text = hq_title
        font = UIFont.systemFont(ofSize: fontSize)
        textColor = color
        numberOfLines = 0
    }
    
    /// 可更改行间距的 Label
    ///
    /// - Parameters:
    ///   - hq_spaceText: 文字
    ///   - fontSize: fontSize = 16
    ///   - color: color = darkGray
    ///   - lineSpace: 行间距 = 6
    convenience init(hq_spaceText: String, fontSize: CGFloat = 16, color: UIColor = UIColor.darkGray, lineSpace: CGFloat = 6) {
        self.init()
        
        attributedText = getAttributeStringWithString(string: hq_spaceText, lineSpace: lineSpace)
        font = UIFont.systemFont(ofSize: fontSize)
        textColor = color
        numberOfLines = 0
    }
}

// MARK: - 调整行间距
extension UILabel {
    
    /// 通过文字获取带行间距的富文本
    ///
    /// - Parameters:
    ///   - string: string
    ///   - lineSpace: 行间距
    /// - Returns: 返回带行间距的服富文本
    fileprivate func getAttributeStringWithString (string: String, lineSpace: CGFloat) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string)
        
        // 通过富文本设置行间距
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 调整行间距
        paragraphStyle.lineSpacing = lineSpace
        
        let rang = NSMakeRange(0, CFStringGetLength(string as CFString!))
        
        attributedString .addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: rang)
        
        return attributedString
    }
}
