//
//  CheckInRequestPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/16.
//

import UIKit

class CheckInRequestPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 8
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
