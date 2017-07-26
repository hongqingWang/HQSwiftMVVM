
//
//  HQTextField.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/25.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

extension UITextField {
    
    convenience init(hq_placeholder: String, border: UITextBorderStyle = .none, isSecureText: Bool = false) {
        self.init()
        
        placeholder = hq_placeholder
        borderStyle = border
        clearButtonMode = .whileEditing
        isSecureTextEntry = isSecureText
    }
}
