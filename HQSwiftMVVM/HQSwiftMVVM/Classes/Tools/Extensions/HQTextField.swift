
//
//  HQTextField.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/25.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UITextField {
    
    /// 占位文字 + 边框样式(Optional) + 是否是密文(Optional)
    ///
    /// - Parameters:
    ///   - hq_placeholder: hq_placeholder
    ///   - border: border
    ///   - isSecureText: isSecureText
    convenience init(hq_placeholder: String, border: UITextBorderStyle = .none, isSecureText: Bool = false) {
        self.init()
        
        placeholder = hq_placeholder
        borderStyle = border
        clearButtonMode = .whileEditing
        isSecureTextEntry = isSecureText
    }
}
