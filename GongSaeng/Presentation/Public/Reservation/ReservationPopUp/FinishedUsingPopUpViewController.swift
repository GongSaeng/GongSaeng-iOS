//
//  FinishedUsingPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/02.
//

import UIKit

class FinishedUsingPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var popUpViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 10
        checkButton.layer.cornerRadius = 10
        
        popUpViewBottomConstraint.constant -= popUpView.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.popUpView.layer.position.y -= self.popUpView.frame.height
            self.popUpViewBottomConstraint.constant = -50
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
