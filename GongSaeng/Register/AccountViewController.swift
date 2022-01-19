//
//  AccountViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/28.
//

import UIKit
import MapKit

class AccountViewController: UIViewController {
//    let viewModel: UserViewModel = UserViewModel()
    
    var register: Register?
//    var user: User?
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var idUnderlinedView: UIView!
    @IBOutlet weak var passwordUnderlinedView: UIView!
    @IBOutlet weak var passwordCheckUnderlinedView: UIView!
    @IBOutlet weak var nicknameUnderlinedView: UIView!
    
    @IBOutlet weak var idHintLabel: UILabel!
    @IBOutlet weak var passwordHintLabel: UILabel!
    @IBOutlet weak var passwordCheckHintLabel: UILabel!
    @IBOutlet weak var nicknameHintLabel: UILabel!
    
    @IBOutlet weak var idHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordCheckHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var nicknameHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var extraViewHeight: UIView!
    
    // 중복체크 Label
    @IBOutlet weak var idReduplicationHintLabel: UILabel!
    @IBOutlet weak var nicknameReduplicationHintLabel: UILabel!
    @IBOutlet weak var idReduplicationConstraint: NSLayoutConstraint!
    @IBOutlet weak var nicknameReduplicationConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var idReduplicationButton: UIButton!
    @IBOutlet weak var nicknameReduplicationButton: UIButton!
    @IBOutlet weak var passwordLookButton: UIButton!
    @IBOutlet weak var passwordCheckLookButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let grayColorLiteral = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
    let orangeColorLiteral = #colorLiteral(red: 1, green: 0.4431372549, blue: 0.2745098039, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 8
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        [idReduplicationButton, nicknameReduplicationButton].forEach {
            $0?.layer.cornerRadius = 15
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        }
        
        passwordTextField.passwordRuleAssignment()
        passwordCheckTextField.passwordRuleAssignment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passwordLookButton.isSelected = false
        passwordCheckLookButton.isSelected = false
        
        [idHintConstraint,passwordHintConstraint,passwordCheckHintConstraint,nicknameHintConstraint].forEach{
            $0?.constant = 0
        }
    }
    
    @IBAction func tapBG(_ sender: Any) {
        resignAll()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapHandler(_ sender: UIStoryboardSegue) {
        guard var register = register else { return }
        guard let nickNameString = nicknameTextField.text, !nickNameString.isEmpty, let passwordCheckString = passwordCheckTextField.text, !passwordCheckString.isEmpty, let passwordString = passwordTextField.text, !passwordString.isEmpty, let idString = idTextField.text, !idString.isEmpty, idReduplicationConstraint.constant == 0, nicknameReduplicationConstraint.constant == 0 else {
            return
        }
        
        // 여기서 정규화 검증
        var validCount: Int = 0
        if !Normalization.isValidRegEx(regExKinds: "id", objectString: idString) {
            idHintConstraint.constant = 17
            validCount += 1
        }
        if !Normalization.isValidRegEx(regExKinds: "password", objectString: passwordString) {
            passwordHintConstraint.constant = 17
            validCount += 1
        }
        if !Normalization.isValidRegEx(regExKinds: "nickName", objectString: nickNameString) {
            nicknameHintConstraint.constant = 17
            validCount += 1
        }
        if passwordString != passwordCheckString {
            passwordCheckHintConstraint.constant = 17
            validCount += 1
        }
        if validCount > 0 {
            return
        }
        
        register.updateRegister(id: idString, password: passwordString, nickname: nickNameString)
        // 회원가입 API 구현
        showLoader(true)
        print("DEBUG: 회원가입 유저정보 ->", register)
        AuthService.registerUser(registeringUser: register) { [weak self] isSucceded in
            guard let self = self else { return }
            if isSucceded {
                self.showLoader(false)
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Register", bundle: Bundle.main)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "CompletedRegisterViewController") as! CompletedRegisterViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            } else {
                print("DEBUG: 회원가입 실패..")
            }
        }
    }
    
    func changeActivationStatusOfNextButton() {
        // 중복확인 체크상태 확인
        guard idReduplicationConstraint.constant == 0, nicknameReduplicationConstraint.constant == 0 else { return }
        
        // 확률적으로 밑에가 비었을 확률이 크다. 아래부터 check하면 불필요한 연산을 하지 않는다.
        guard let nickNameString = nicknameTextField.text, !nickNameString.isEmpty, let passwordCheckString = passwordCheckTextField.text, !passwordCheckString.isEmpty, let passwordString = passwordTextField.text, !passwordString.isEmpty, let idString = idTextField.text, !idString.isEmpty else {
            DispatchQueue.main.async {
                self.nextButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.nextButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        }
    }
    
    func changeUnderlineColor(textField: UITextField, color: UIColor) {
        switch textField {
        case idTextField:
            return idUnderlinedView.backgroundColor = color
        case passwordTextField:
            return passwordUnderlinedView.backgroundColor = color
        case passwordCheckTextField:
            return passwordCheckUnderlinedView.backgroundColor = color
        case nicknameTextField:
            return nicknameUnderlinedView.backgroundColor = color
        default:
            return
        }
    }
    
    @IBAction func idReduplicationButtonHandler(_ sender: Any) {
        guard let id = idTextField.text else { return }
        AuthService.checkIdDuplicate(idToCheck: id) { [weak self] isAvailable in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isAvailable {
                    self.idReduplicationConstraint.constant = 0
                    self.changeActivationStatusOfNextButton()
                } else {
                    self.idReduplicationConstraint.constant = 17
                    let popUpContents = "중복한 아이디가 존재합니다."
                    let viewController = PopUpViewController(contents: popUpContents)
                    viewController.modalPresentationStyle = .overCurrentContext
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    @IBAction func nickNameReduplicationButtonHandler(_ sender: Any) {
        guard let nickName = nicknameTextField.text else { return }
        AuthService.checkNicknameDuplicate(nickNameToCheck: nickName) { [weak self] isAvailable in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isAvailable {
                    self.nicknameReduplicationConstraint.constant = 0
                    self.changeActivationStatusOfNextButton()
                } else {
                    self.nicknameReduplicationConstraint.constant = 17
                    let popUpContents = "중복한 닉네임이 존재합니다."
                    let viewController = PopUpViewController(contents: popUpContents)
                    viewController.modalPresentationStyle = .overCurrentContext
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
    }
    
    @IBAction func passwordLookButtonHandler(_ sender: Any) {
        self.secureTransition(textField: passwordTextField, lookButton: passwordLookButton)
        self.secureTransition(textField: passwordCheckTextField, lookButton: passwordCheckLookButton)
    }
    @IBAction func passwordCheckButtonHandler(_ sender: Any) {
        self.secureTransition(textField: passwordTextField, lookButton: passwordLookButton)
        self.secureTransition(textField: passwordCheckTextField, lookButton: passwordCheckLookButton)
    }
    
    func secureTransition(textField: UITextField, lookButton: UIButton) {
        lookButton.isSelected = !lookButton.isSelected
        if lookButton.isSelected {
            textField.isSecureTextEntry = false
        } else {
            textField.isSecureTextEntry = true
        }
    }
    
    func resignAll() {
        [idTextField,passwordTextField,passwordCheckTextField,nicknameTextField].forEach({
            $0?.resignFirstResponder()
        })
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeUnderlineColor(textField: textField, color: orangeColorLiteral)
        guard let textViewId = textField.restorationIdentifier else { return }
        switch textViewId {
        case "idTextField": idHintConstraint.constant = 17
        case "passwordTextField": passwordHintConstraint.constant = 17
        case "passwordCheckTextField": passwordCheckHintConstraint.constant = 17
        case "nickNameTextField": nicknameHintConstraint.constant = 17
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeUnderlineColor(textField: textField, color: grayColorLiteral)
        guard let textViewId = textField.restorationIdentifier else { return }
        
        switch textViewId {
        case "idTextField": idHintConstraint.constant = 0
        case "passwordTextField": passwordHintConstraint.constant = 0
        case "passwordCheckTextField": passwordCheckHintConstraint.constant = 0
        case "nickNameTextField":nicknameHintConstraint.constant = 0
        default:
            return
        }
        
        changeActivationStatusOfNextButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AccountViewController {
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height
            guard let view = (self.view.currentFirstResponder() as? UITextField)?.superview else { return }
            if view.frame.maxY > adjustmentHeight {
                scrollView.setContentOffset(CGPoint(x: 0, y: view.frame.maxY - adjustmentHeight), animated: true)
            }
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        print("---> Keyboard End Frame: \(keyboardFrame)")
    }
}
