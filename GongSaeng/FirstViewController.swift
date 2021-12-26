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
        guard let rootViewController = view.window?.rootViewController as? AppTabbarController else { return }
        let storyboard = UIStoryboard.init(name: "Login", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController.delegate = rootViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func registerButtonHandler(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Register", bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
