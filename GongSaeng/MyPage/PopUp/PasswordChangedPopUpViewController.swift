//
//  PasswordChangedPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/13.
//

import UIKit

class PasswordChangedPopUpViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 8
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
