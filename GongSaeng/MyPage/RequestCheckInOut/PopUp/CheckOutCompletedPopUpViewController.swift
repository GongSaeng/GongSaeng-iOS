//
//  CheckOutCompletedPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/15.
//

import UIKit

class CheckOutCompletedPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 8
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
