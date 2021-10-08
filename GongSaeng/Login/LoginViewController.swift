//
//  LoginViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var idTextFieldUnderlinedView: UIView!
    @IBOutlet weak var passwordTextFieldUnderlinedView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    let userViewModel: UserViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 8
        idTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginButtonSetting(allTextFieldHasContent())
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        loginButtonSetting(allTextFieldHasContent())
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBG(_ sender: Any) {
        if idTextField.isFirstResponder {
            idTextField.resignFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func loginButtonTapHandler(_ sender: Any) {
        // id, password check
        // 두 유저가 같다는 것은 id와 비번이 모두 같은 것임을 정의했다.
        guard let loginUser = loginUserCreate(id: idTextField.text, password: passwordTextField.text) else { return }
        guard userViewModel.isCorrectUser(user: loginUser) else {
            let storyBoard = UIStoryboard.init(name: "LoginPopUp", bundle: nil)
            let popUpViewController = storyBoard.instantiateViewController(identifier: "CheckIDInfoPopUpViewController") as! CheckIDInfoPopUpViewController
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
            return
        }
        
        // permission check
        guard userViewModel.doneUser.contains(loginUser) else {
            let storyBoard = UIStoryboard.init(name: "LoginPopUp", bundle: nil)
            let popUpViewController = storyBoard.instantiateViewController(identifier: "WaitingForApprovalPopUpViewController") as! WaitingForApprovalPopUpViewController
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
            return
        }
        
        // To Home
        let sb = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "AppTabbarController") as AppTabbarController
        vc.modalPresentationStyle = .fullScreen
        vc.loginUserString = loginUser.id
        present(vc, animated: true, completion: nil)
    }
    
    func loginUserCreate(id: String?, password: String?) -> User? {
        guard let idString = id, let passwordString = password else { return nil }
        var user = User(id: "", password: "", isDone: false, name: "", dateOfBirth: "", phoneNumber: "", department: "", nickName: "")
        user.loginUserCreate(id: idString, password: passwordString)
        return user
    }
    
    private func allTextFieldHasContent() -> Bool {
        if idTextField.hasText, passwordTextField.hasText {
            return true
        } else {
            return false
        }
    }
    
    private func loginButtonSetting(_ bool: Bool) {
        if bool {
            loginButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
            loginButton.isEnabled = false
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == idTextField {
            idTextFieldUnderlinedView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        } else if textField == passwordTextField {
            passwordTextFieldUnderlinedView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        }
        loginButtonSetting(allTextFieldHasContent())
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextField {
            idTextFieldUnderlinedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        } else if textField == passwordTextField {
            passwordTextFieldUnderlinedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
        
        loginButtonSetting(allTextFieldHasContent())
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
