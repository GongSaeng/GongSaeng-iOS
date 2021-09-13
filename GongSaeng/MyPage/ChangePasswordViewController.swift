//
//  ChangePasswordViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/13.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var lookPasswordButton: UIButton!
    @IBOutlet weak var lookPasswordCheckButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changePasswordButton.layer.cornerRadius = 10
        
        passwordTextField.underlined(viewSize: view.bounds.width, color: UIColor.systemGray)
        passwordCheckTextField.underlined(viewSize: view.bounds.width, color: UIColor.systemGray)
        
        [lookPasswordButton, lookPasswordCheckButton].forEach {
            $0?.isSelected = false
        }
        
        [passwordTextField, passwordCheckTextField].forEach {
            $0?.isSecureTextEntry = true
        }
    }
    
    private func lookButtonTapped(button: UIButton) {
        switch button.isSelected {
        case true:
            [lookPasswordButton, lookPasswordCheckButton].forEach {
                $0?.setImage(UIImage(named: "lookIcon.png"), for: .normal)
                $0?.isSelected = !button.isSelected
            }
            [passwordTextField, passwordCheckTextField].forEach {
                $0?.isSecureTextEntry = true
            }
        case false:
            [lookPasswordButton, lookPasswordCheckButton].forEach {
                $0?.setImage(UIImage(named: "noLookIcon.png"), for: .normal)
                $0?.isSelected = !button.isSelected
            }
            [passwordTextField, passwordCheckTextField].forEach {
                $0?.isSecureTextEntry = false
            }
        }
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lookPasswordButtonTapped(_ sender: UIButton) {
        lookButtonTapped(button: sender)
    }
    
    @IBAction func lookPasswordCheckButtonTapped(_ sender: UIButton) {
        lookButtonTapped(button: sender)
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        print("changePasswordButtonTapped")
    }
    
}
