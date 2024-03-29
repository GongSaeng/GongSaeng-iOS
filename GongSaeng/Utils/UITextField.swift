//
//  UITextField.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/29.
//

import UIKit

extension UITextField {
    func underlined(viewSize: CGFloat, color: UIColor){
        let border = CALayer()
        let width = CGFloat(1)
//        border.borderColor = UIColor.gray.cgColor
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height + 10, width: viewSize - 48, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
    }
    
    func passwordRuleAssignment() {
        self.textContentType = .newPassword
        self.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; max-consecutive: 20; minlength: 0; maxlength: 22")
    }
    
    // TextField의 Text에 패딩넣기
//    func addLeftPadding(paddingWidth: CGFloat) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: self.frame.height))
//        self.leftView = paddingView
//        self.leftViewMode = ViewMode.always
//      }
}
