//
//  LogOutPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/13.
//

import UIKit

class LogOutPopUpViewController: UIViewController {
    @IBOutlet weak var logOutView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutView.layer.cornerRadius = 8
        [cancelButton, logOutButton].forEach {
            $0?.layer.cornerRadius = 18
            $0?.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            $0?.layer.borderWidth = 1
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        // 로그아웃
    }
}
