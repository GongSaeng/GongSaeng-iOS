//
//  NotCloseCellTappedPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/02.
//

import UIKit

class NotCloseCellTappedPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 8
        checkButton.layer.cornerRadius = 18
        checkButton.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        checkButton.layer.borderWidth = 1
    }
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
}
