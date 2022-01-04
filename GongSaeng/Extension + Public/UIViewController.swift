//
//  UIViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/30.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
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
