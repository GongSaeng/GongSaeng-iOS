//
//  AccountViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/28.
//

import UIKit

class AccountViewController: UIViewController {
    let viewModel: UserViewModel = UserViewModel()
    
    var user: User?
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var idHintLabel: UILabel!
    @IBOutlet weak var passwordHintLabel: UILabel!
    @IBOutlet weak var passwordCheckHintLabel: UILabel!
    @IBOutlet weak var nickNameHintLabel: UILabel!
    
    @IBOutlet weak var idHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordCheckHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var nickNameHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var extraViewHeight: UIView!
    
    // 중복체크 Label
    @IBOutlet weak var idReduplicationHintLabel: UILabel!
    @IBOutlet weak var nickNameReduplicationHintLabel: UILabel!
    @IBOutlet weak var idReduplicationConstraint: NSLayoutConstraint!
    @IBOutlet weak var nickNameReduplicationConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordLookButton: UIButton!
    @IBOutlet weak var passwordCheckLookButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        passwordTextField.passwordRuleAssignment()
        passwordCheckTextField.passwordRuleAssignment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passwordLookButton.isSelected = false
        passwordCheckLookButton.isSelected = false
        
//        idTextField.underlined(viewSize: view.bounds.width, color: UIColor.systemGray)
//        passwordTextField.underlined(viewSize: view.bounds.width, color: UIColor.systemGray)
//        passwordCheckTextField.underlined(viewSize: view.bounds.width, color: UIColor.systemGray)
//        nickNameTextField.underlined(viewSize: view.bounds.width, color: UIColor.systemGray)
        
        [idTextField,passwordTextField,passwordCheckTextField,nickNameTextField].forEach{
            $0?.underlined(viewSize: view.bounds.width, color: UIColor.systemGray)
        }
        
//        idHintConstraint.constant = 0
//        passwordHintConstraint.constant = 0
//        passwordCheckHintConstraint.constant = 0
//        nickNameHintConstraint.constant = 0
        
        [idHintConstraint,passwordHintConstraint,passwordCheckHintConstraint,nickNameHintConstraint].forEach{
            $0?.constant = 0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completedRegister" {
            let vc = segue.destination as? CompletedRegisterViewController
            if let user = sender as? User {
                vc?.user = user
            }
        }
    }
    
    @IBAction func tapBG(_ sender: Any) {
        resignAll()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapHandler(_ sender: UIStoryboardSegue) {
        guard let nickNameString = nickNameTextField.text, !nickNameString.isEmpty, let passwordCheckString = passwordCheckTextField.text, !passwordCheckString.isEmpty, let passwordString = passwordTextField.text, !passwordString.isEmpty, let idString = idTextField.text, !idString.isEmpty else {
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
            nickNameHintConstraint.constant = 17
            validCount += 1
        }
        if passwordString != passwordCheckString {
            passwordCheckHintConstraint.constant = 17
            validCount += 1
        }
        if validCount > 0 {
            return
        }
        
        guard let user = registerAccountUserCreate(memberUser: self.user, id: idString, password: passwordString, nickName: nickNameString) else { return }
        performSegue(withIdentifier: "completedRegister", sender: user)
    }
    
    func registerAccountUserCreate(memberUser: User?, id: String?, password: String?, nickName: String?) -> User? {
        guard let idString = id, let passwordString = password, let nickNameString = nickName else { return nil }
        guard let nameString = memberUser?.name, let birthString = memberUser?.dateOfBirth, let phoneString = memberUser?.phoneNumber, let departmentString = memberUser?.department else { return nil }
        var user = User(id: "", password: "", isDone: false, name: "", dateOfBirth: "", phoneNumber: "", department: "", nickName: "")
        user.update(id: idString, password: passwordString, name: nameString , dateOfBirth: birthString, phoneNumber: phoneString, department: departmentString, nickName: nickNameString)
        return user
    }
    
    @IBAction func idReduplicationButtonHandler(_ sender: Any) {
        guard let text = idTextField.text else { return }
        if !viewModel.idReduplicationCheck(id: text) {
            idReduplicationConstraint.constant = 0
        } else {
            idReduplicationHintLabel.text = "중복한 아이디가 존재합니다."
            idReduplicationConstraint.constant = 17
        }
    }
    
    @IBAction func nickNameReduplicationButtonHandler(_ sender: Any) {
        guard let text = nickNameTextField.text else { return }
        if !viewModel.nickNameReduplicationCheck(nickName: text) {
            nickNameReduplicationConstraint.constant = 0
        } else {
            nickNameReduplicationHintLabel.text = "중복한 닉네임이 존재합니다."
            nickNameReduplicationConstraint.constant = 17
        }
    }
    
    @IBAction func passwordLookButtonHandler(_ sender: Any) {
        self.secureTransition(textField: passwordTextField, lookButton: passwordLookButton)
    }
    @IBAction func passwordCheckButtonHandler(_ sender: Any) {
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
        [idTextField,passwordTextField,passwordCheckTextField,nickNameTextField].forEach({
            $0?.resignFirstResponder()
        })
        
//        idTextField.resignFirstResponder()
//        passwordTextField.resignFirstResponder()
//        passwordCheckTextField.resignFirstResponder()
//        nickNameTextField.resignFirstResponder()
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.underlined(viewSize: view.bounds.width, color: UIColor.systemOrange)
        guard let textViewId = textField.restorationIdentifier else { return }
        switch textViewId {
        case "idTextField": idHintConstraint.constant = 17
        case "passwordTextField": passwordHintConstraint.constant = 17
        case "passwordCheckTextField": passwordCheckHintConstraint.constant = 17
        case "nickNameTextField": nickNameHintConstraint.constant = 17
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.underlined(viewSize: view.bounds.width, color: UIColor.systemGray)
        guard let textViewId = textField.restorationIdentifier else { return }
        
        switch textViewId {
        case "idTextField": idHintConstraint.constant = 0
        case "passwordTextField": passwordHintConstraint.constant = 0
        case "passwordCheckTextField": passwordCheckHintConstraint.constant = 0
        case "nickNameTextField":nickNameHintConstraint.constant = 0
        default:
            return
        }
        
        // 확률적으로 밑에가 비었을 확률이 크다. 아래부터 check하면 불필요한 연산을 하지 않는다.
        guard let nickNameString = nickNameTextField.text, !nickNameString.isEmpty, let passwordCheckString = passwordCheckTextField.text, !passwordCheckString.isEmpty, let passwordString = passwordTextField.text, !passwordString.isEmpty, let idString = idTextField.text, !idString.isEmpty else {
            DispatchQueue.main.async {
                self.nextButton.imageView?.image = UIImage(named: "nextButton")
            }
            return
        }
        DispatchQueue.main.async {
            self.nextButton.imageView?.image = UIImage(named: "nextButtonFill")
        }
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
