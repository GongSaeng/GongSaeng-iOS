//
//  LoginViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var idTextFieldUnderlinedView: UIView!
    @IBOutlet weak var passwordTextFieldUnderlinedView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
//    let userViewModel: UserViewModel = UserViewModel()
    
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
        self.navigationController?.popViewController(animated: true)
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
//        guard let loginUser = loginUserCreate(id: idTextField.text, password: passwordTextField.text) else { return }
//        guard userViewModel.isCorrectUser(user: loginUser) else {
//            let storyBoard = UIStoryboard.init(name: "LoginPopUp", bundle: nil)
//            let popUpViewController = storyBoard.instantiateViewController(identifier: "CheckIDInfoPopUpViewController") as! CheckIDInfoPopUpViewController
//            popUpViewController.modalPresentationStyle = .overCurrentContext
//            self.present(popUpViewController, animated: false, completion: nil)
//            return
//        }
//
//        // permission check
//        guard userViewModel.doneUser.contains(loginUser) else {
//            let storyBoard = UIStoryboard.init(name: "LoginPopUp", bundle: nil)
//            let popUpViewController = storyBoard.instantiateViewController(identifier: "WaitingForApprovalPopUpViewController") as! WaitingForApprovalPopUpViewController
//            popUpViewController.modalPresentationStyle = .overCurrentContext
//            self.present(popUpViewController, animated: false, completion: nil)
//            return
//        }
        
        // To Home
        guard let id = idTextField.text, let password = passwordTextField.text else { return }
        AuthService.loginUserIn(withID: id, password: password) { isSucceded in
            DispatchQueue.main.async {
                if isSucceded {
                    print("DEBUG: Login success..")
                    // UserDefaults ID 정보 저장
                    UserDefaults.standard.set(id, forKey: "id")
                    UserDefaults.standard.set(password, forKey: "password")
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.switchRootViewToHome(animated: true)
                } else {
                    print("DEBUG: Login faield..")
                }
            }
        }
    }
    
//    func loginUserCreate(id: String?, password: String?) -> User? {
//        guard let idString = id, let passwordString = password else { return nil }
//        var user = User(id: "", password: "", isDone: false, name: "", dateOfBirth: "", phoneNumber: "", department: "", nickName: "")
//        user.loginUserCreate(id: idString, password: passwordString)
//        return user
//    }
    
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
