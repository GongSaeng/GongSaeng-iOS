//
//  FirstViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 8
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        registerButton.layer.cornerRadius = 8
    }
    
    @IBAction func loginButtonHandler(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Login", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func registerButtonHandler(_ sender: Any) {
        let sb = UIStoryboard(name: "Register", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
