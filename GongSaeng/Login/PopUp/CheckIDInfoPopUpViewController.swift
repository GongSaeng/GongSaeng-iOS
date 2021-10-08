//
//  CheckIDInfoPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/08.
//

import UIKit

class CheckIDInfoPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 8
        confirmButton.layer.cornerRadius = 18
        confirmButton.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        confirmButton.layer.borderWidth = 1
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
}
