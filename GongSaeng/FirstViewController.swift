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
