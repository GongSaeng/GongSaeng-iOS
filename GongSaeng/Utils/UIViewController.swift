//
//  UIViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/30.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .extraLight)
    
    func showLoader(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.endEditing(true)
            if show {
                UIViewController.hud.show(in: self.view)
            } else {
                UIViewController.hud.dismiss()
            }
        }
    }
}
