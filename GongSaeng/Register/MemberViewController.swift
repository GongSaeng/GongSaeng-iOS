//
//  MemberViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/28.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var nameUnderlinedView: UIView!
    @IBOutlet weak var birthUnderlinedView: UIView!
    @IBOutlet weak var phoneUnderlinedView: UIView!
    
    @IBOutlet weak var nameHintLabel: UILabel!
    @IBOutlet weak var birthHintLabel: UILabel!
    @IBOutlet weak var phoneHintLabel: UILabel!
    
    @IBOutlet weak var nameHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var birthHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneHintConstraint: NSLayoutConstraint!
    @IBOutlet weak var extraViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    
    var department: String = ""
    let grayColorLiteral = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
    let orangeColorLiteral = #colorLiteral(red: 1, green: 0.4431372549, blue: 0.2745098039, alpha: 1)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "account" {
            let vc = segue.destination as? AccountViewController
            guard let user = sender as? User else { return }
            vc?.user = user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 8
        // 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameHintConstraint.constant = 0
        birthHintConstraint.constant = 0
        phoneHintConstraint.constant = 0
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapBG(_ sender: Any) {
        resignAll()
        nameHintConstraint.constant = 0
        birthHintConstraint.constant = 0
        phoneHintConstraint.constant = 0
        
    }
    
    @IBAction func nextButtonTapHandler(_ sender: Any) {
        guard let nameString = nameTextField.text, !nameString.isEmpty, let birthString = birthTextField.text, !birthString.isEmpty, let phoneString = phoneTextField.text, !phoneString.isEmpty else {
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
        if validCount > 0 {
            return
        }

        let registerUser = registerMemberUserCreate(name: nameString, birth: birthString, phone: phoneString)
        performSegue(withIdentifier: "account", sender: registerUser)
    }
    
    func changeUnderlineColor(textField: UITextField, color: UIColor) {
        switch textField {
        case nameTextField:
            return nameUnderlinedView.backgroundColor = color
        case birthTextField:
            return birthUnderlinedView.backgroundColor = color
        case phoneTextField:
            return phoneUnderlinedView.backgroundColor = color
        default:
            return
        }
    }
    
    func registerMemberUserCreate(name: String?, birth: String?, phone: String?) -> User? {
        guard let nameString = name, let birthString = birth, let phoneString = phone else { return nil }
        var user = User(id: "", password: "", isDone: false, name: "", dateOfBirth: "", phoneNumber: "", department: "", nickName: "")
        user.registerMemberUserCreate(name: nameString, dateOfBirth: birthString, phoneNumber: phoneString, department: self.department)
        return user
    }
    
    func resignAll() {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        } else if birthTextField.isFirstResponder {
            birthTextField.resignFirstResponder()
        } else if phoneTextField.isFirstResponder {
            phoneTextField.resignFirstResponder()
        }
    }
}

extension MemberViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeUnderlineColor(textField: textField, color: orangeColorLiteral)
        guard let id = textField.restorationIdentifier else { return }
        switch id {
        case "nameTextField": nameHintConstraint.constant = 17
        case "birthTextField": birthHintConstraint.constant = 17
        case "phoneTextField": phoneHintConstraint.constant = 17
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeUnderlineColor(textField: textField, color: grayColorLiteral)
        guard let id = textField.restorationIdentifier else { return }
        switch id {
        case "nameTextField": nameHintConstraint.constant = 0
        case "birthTextField": birthHintConstraint.constant = 0
        case "phoneTextField": phoneHintConstraint.constant = 0
        default:
            return
        }
        
        // 확률적으로 밑에가 비었을 확률이 크다. 아래부터 check하면 불필요한 연산을 하지 않는다.
        guard let phoneString = phoneTextField.text, !phoneString.isEmpty, let birthString = birthTextField.text, !birthString.isEmpty, let nameString = nameTextField.text, !nameString.isEmpty else {
            DispatchQueue.main.async {
                self.nextButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
            }
            return
        }
        DispatchQueue.main.async {
            self.nextButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
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
            if view.frame.maxY > adjustmentHeight {
                scrollView.setContentOffset(CGPoint(x: 0, y: view.frame.maxY - adjustmentHeight), animated: true)
            }
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        print("---> Keyboard End Frame: \(keyboardFrame)")
    }
}
