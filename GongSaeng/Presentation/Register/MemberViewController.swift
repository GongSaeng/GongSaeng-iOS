//
//  MemberViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/28.
//

import UIKit
import Firebase
import FirebaseAuth

class MemberViewController: UIViewController {
    
    private let domainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .clear
        label.isUserInteractionEnabled = true
        return label
    }()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var nameUnderlinedView: UIView!
    @IBOutlet weak var birthUnderlinedView: UIView!
    @IBOutlet weak var phoneUnderlinedView: UIView!
    @IBOutlet weak var emailUnderlinedView: UIView!
    
    @IBOutlet weak var nameHintLabel: UILabel!
    @IBOutlet weak var birthHintLabel: UILabel!
    @IBOutlet weak var phoneHintLabel: UILabel!
    @IBOutlet weak var emailHintLabel: UILabel!
    
    @IBOutlet weak var nameHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var birthHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var extraViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    
    var popUpViewController: PopUpViewController?
    
    var register: Register?
    let grayColorLiteral = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
    let orangeColorLiteral = #colorLiteral(red: 1, green: 0.4431372549, blue: 0.2745098039, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideHint()
    }
    @objc
    private func textFieldEditingHandler() {
        // 확률적으로 밑에가 비었을 확률이 크다. 아래부터 check하면 불필요한 연산을 하지 않는다.
        guard let phoneString = phoneTextField.text, !phoneString.isEmpty,
              let birthString = birthTextField.text, !birthString.isEmpty,
              let nameString = nameTextField.text, !nameString.isEmpty,
              let emailString = emailTextField.text, !emailString.isEmpty else {
                  nextButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                  return
            }
        nextButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
    }
    
    @objc
    private func emailEdittingHandler(_ sender: UITextField) {
        guard let text = sender.text else { return }
        emptyLabel.text = text
        domainLabel.isHidden = text.isEmpty
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapBG(_ sender: Any) {
        view.endEditing(true)
        hideHint()
    }
    
    @IBAction func nextButtonTapHandler(_ sender: Any) {
        guard var register = register, let university = register.university else { return }
        guard let nameString = nameTextField.text, !nameString.isEmpty,
              let birthString = birthTextField.text, !birthString.isEmpty,
              let phoneString = phoneTextField.text, !phoneString.isEmpty,
              let emailString = emailTextField.text
                .flatMap({ "\($0)@\(university.domain)" }), !emailString.isEmpty else {
            return
        }
        
        var validCount: Int = 0
        // 여기서 정규화 검증
        if !Normalization.isValidRegEx(regExKinds: "name", objectString: nameString) {
            nameHintConstraint.constant = 17
            validCount += 1
        }
        if !Normalization.isValidRegEx(regExKinds: "birth", objectString: birthString) {
            birthHintConstraint.constant = 17
            validCount += 1
        }
        if !Normalization.isValidRegEx(regExKinds: "phone", objectString: phoneString) {
            phoneHintConstraint.constant = 17
            validCount += 1
        }
        if !Normalization.isValidRegEx(regExKinds: "email", objectString: emailString) {
            emailHintConstraint.constant = 17
            validCount += 1
        }
        
        if validCount > 0 {
            return
        }
        
        register.updateRegister(name: nameString, dateOfBirth: birthString, phoneNumber: phoneString, email: emailString)
        print("DEBUG: 회원가입 유저정보 ->", register)
        
        guard let password = register.password else { return }
        
        // 웹메일 사용가능 여부 확인 (Firebase)
        showLoader(true)
        Auth.auth().createUser(withEmail: emailString, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            guard error == nil else {
                self.showLoader(false)
                if let errorCode: AuthErrorCode = AuthErrorCode(rawValue: error!._code) {
                    var errorMessage: String = ""
                    switch errorCode.rawValue {
                    case 17007:
                        errorMessage = "이미 사용중인 이메일입니다."
                    case 17008:
                        errorMessage = "올바르지 않은 이메일 형식입니다."
                    default:
                        errorMessage = "\(error?.localizedDescription ?? "")"
                    }
                    
                    DispatchQueue.main.async {
                        let viewController = PopUpViewController(contents: errorMessage)
                        viewController.modalPresentationStyle = .overCurrentContext
                        self.present(viewController, animated: false, completion: nil)
                    }

                    print("DEBUG: errorCode -> \(errorCode.rawValue)")
                    print("DEBUG: \(error?.localizedDescription ?? "")")
                }
                return
            }
            
            // 회원가입 API 구현
            AuthService.registerUser(registeringUser: register) { isSucceded in
                if isSucceded {
                    // 인증 메일 전송
                    Auth.auth().currentUser?.sendEmailVerification { error in
                        guard error == nil else {
                            DispatchQueue.main.async {
                                self.showLoader(false)
                                let viewController = PopUpViewController(contents: error!.localizedDescription)
                                viewController.modalPresentationStyle = .overCurrentContext
                                self.present(viewController, animated: false, completion: nil)
                            }
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.showLoader(false)
                            let storyboard = UIStoryboard(name: "Register", bundle: .main)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "CompletedRegisterViewController") as! CompletedRegisterViewController
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                } else {
                    print("DEBUG: 회원가입 실패..")
                    self.showLoader(false)
                    Auth.auth().currentUser?.delete()
                }
            }
        }
    }
    
    private func configure() {
        guard let register = register, let university = register.university else { return }
        domainLabel.text = "@\(university.domain)"
        emailTextField.addTarget(self, action: #selector(emailEdittingHandler), for: .editingChanged)
        
        [nameTextField, birthTextField, phoneTextField, emailTextField].forEach {
                $0?.addTarget(self, action: #selector(textFieldEditingHandler), for: .editingChanged)
            }
        
        nextButton.layer.cornerRadius = 8
        
        [domainLabel, emptyLabel].forEach { emailTextField.addSubview($0) }
        emptyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(20.0)
        }
        
        domainLabel.snp.makeConstraints {
            $0.leading.equalTo(emptyLabel.snp.trailing)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func hideHint() {
        nameHintConstraint.constant = 0
        birthHintConstraint.constant = 0
        phoneHintConstraint.constant = 0
        emailHintConstraint.constant = 0
    }
    
    func changeUnderlineColor(textField: UITextField, color: UIColor) {
        switch textField {
        case nameTextField:
            return nameUnderlinedView.backgroundColor = color
        case birthTextField:
            return birthUnderlinedView.backgroundColor = color
        case phoneTextField:
            return phoneUnderlinedView.backgroundColor = color
        case emailTextField:
            return emailUnderlinedView.backgroundColor = color
        default:
            return
        }
    }
}

extension MemberViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeUnderlineColor(textField: textField, color: orangeColorLiteral)
        switch textField {
        case nameTextField: nameHintConstraint.constant = 17
        case birthTextField: birthHintConstraint.constant = 17
        case phoneTextField: phoneHintConstraint.constant = 17
        case emailTextField: emailHintConstraint.constant = 17
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeUnderlineColor(textField: textField, color: grayColorLiteral)
        switch textField {
        case nameTextField: nameHintConstraint.constant = 0
        case birthTextField: birthHintConstraint.constant = 0
        case phoneTextField: phoneHintConstraint.constant = 0
        case emailTextField: emailHintConstraint.constant = 0
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MemberViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height
            guard let view = (self.view.currentFirstResponder() as? UITextField)?.superview else { return }
            print("DEBUG: \(view.frame.maxY)")
            if view.frame.maxY > adjustmentHeight {
                scrollView.setContentOffset(CGPoint(x: 0, y: view.frame.maxY - adjustmentHeight), animated: true)
            }
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        print("---> Keyboard End Frame: \(keyboardFrame)")
    }
}
