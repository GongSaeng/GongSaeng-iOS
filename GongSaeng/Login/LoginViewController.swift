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
    
    private lazy var loginInputAccessoryView: BannerButtonInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80.0)
        let loginInputAccessoryView = BannerButtonInputAccessoryView(frame: frame, buttonTitle: "로그인", buttonColor: .green)
        loginInputAccessoryView.isActivated = false
        loginInputAccessoryView.delegate = self
        return loginInputAccessoryView
    }()
    
    override var inputAccessoryView: UIView? {
        get { return loginInputAccessoryView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Helpers
    private func configure() {
        idTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        idTextField.tintColor = UIColor(named: "colorBlueGreen")
        passwordTextField.tintColor = UIColor(named: "colorBlueGreen")
    }
    
    private func updateButtonState() {
        
        loginInputAccessoryView.isActivated = viewModel.formIsValid
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

extension LoginViewController: BannerButtonInputAccessoryViewDelegate {
    func didTapBannerButton() {
        // To Home
        showLoader(true)
        guard let id = idTextField.text, let password = passwordTextField.text else { return }
        AuthService.loginUserIn(withID: id, password: password) { [weak self] isRight, isApproved, error in
            guard let self = self else { return }
            
            if error?.localizedDescription == "Could not connect to the server." {
                print("DEBUG: 서버에 연결할 수 없습니다..")
                DispatchQueue.main.async {
                    self.showLoader(false)
                    let alert = UIAlertController(title: "Error", message: "서버에 연결할 수 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            guard isRight else {
                print("DEBUG: Login faield..")
                DispatchQueue.main.async {
                    self.showLoader(false)
                    let popUpContents = "아이디나 비밀번호를 확인해주세요."
                    let viewController = PopUpViewController(buttonType: .cancel, contents: popUpContents)
                    viewController.modalPresentationStyle = .overCurrentContext
                    self.present(viewController, animated: false, completion: nil)
                }
                return
            }
            
            guard isApproved else {
                print("DEBUG: Not approved User..")
                DispatchQueue.main.async {
                    self.showLoader(false)
                    let popUpContents = "가입 승인 대기중이에요\n공간 관리자님께 문의해주세요."
                    let viewController = PopUpViewController(buttonType: .cancel, contents: popUpContents)
                    viewController.modalPresentationStyle = .overCurrentContext
                    self .present(viewController, animated: false, completion: nil)
                }
                return
            }
            
            print("DEBUG: Login success..")
            // UserDefaults ID 정보 저장
            UserDefaults.standard.set(id, forKey: "id")
            UserDefaults.standard.set(password, forKey: "password")
            UserService.fetchCurrentUser { user in
                guard let user = user else { return }
                UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: "loginUser")
                print("DEBUG: Login user data -> \(user)")
                DispatchQueue.main.async {
                    self.showLoader(false)
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.switchRootViewToMain(animated: true)
                }
            }
            
        }
    }
}
