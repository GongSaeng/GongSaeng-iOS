//
//  UIImageView.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/13.
//

import UIKit

extension UIImageView {
    func roundCornerOfImageView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
}
