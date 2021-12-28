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
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Actions
    @IBAction func loginButtonHandler(_ sender: Any) {
        print("DEBUG: Did tap loginButton..")
        let storyboard = UIStoryboard.init(name: "Login", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func registerButtonHandler(_ sender: Any) {
        print("DEBUG: Did tap registerButton")
        let storyBoard = UIStoryboard(name: "Register", bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helpers
    private func configure() {
        loginButton.layer.cornerRadius = 8
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        registerButton.layer.cornerRadius = 8
    }
}
