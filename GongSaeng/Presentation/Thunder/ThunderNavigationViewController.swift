//
//  ThunderNavigationViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/28.
//

import UIKit

final class ThunderNavigationViewController: UINavigationController {
    var statusBarStyle: UIStatusBarStyle = .darkContent {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
