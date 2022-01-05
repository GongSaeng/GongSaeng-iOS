//
//  LoginViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    private var viewModel = LoginViewModel()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var idTextFieldUnderlinedView: UIView!
    @IBOutlet weak var passwordTextFieldUnderlinedView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Actions
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == idTextField {
            viewModel.id = textField.text
        } else if textField == passwordTextField {
            viewModel.password = textField.text
        }
        updateButtonState()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        showLoader(true)
        guard let id = idTextField.text, let password = passwordTextField.text else { return }
        AuthService.loginUserIn(withID: id, password: password) { isSucceded, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showLoader(false)
                if error?.localizedDescription == "Could not connect to the server." {
                    print("DEBUG: 서버에 연결할 수 없습니다..")
                    let alert = UIAlertController(title: "Error", message: "서버에 연결할 수 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if isSucceded {
                    print("DEBUG: Login success..")
                    // UserDefaults ID 정보 저장
                    UserDefaults.standard.set(id, forKey: "id")
                    UserDefaults.standard.set(password, forKey: "password")
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.switchRootViewToMain(animated: true)
                } else {
                    print("DEBUG: Login faield..")
                }
            }
        }
    }
    
    // MARK: Helpers
    private func configure() {
        loginButton.layer.cornerRadius = 8
        idTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        idTextField.tintColor = UIColor(named: "colorBlueGreen")
        passwordTextField.tintColor = UIColor(named: "colorBlueGreen")
    }
    
    private func updateButtonState() {
        loginButton.backgroundColor = viewModel.buttonBackgoundColor
        loginButton.isEnabled = viewModel.formIsValid
    }
    
    private func updateUnderlinColor() {
        idTextFieldUnderlinedView.backgroundColor = viewModel.idUnderlineColor
        passwordTextFieldUnderlinedView.backgroundColor = viewModel.passwordUnderlineColor
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == idTextField {
            viewModel.isEditingId = true
        } else if textField == passwordTextField {
            viewModel.isEditingPassword = true
        }
        updateUnderlinColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextField {
            viewModel.isEditingId = false
        } else if textField == passwordTextField {
            viewModel.isEditingPassword = false
        }
        updateUnderlinColor()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
