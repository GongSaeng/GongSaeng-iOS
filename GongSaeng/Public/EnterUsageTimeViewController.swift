//
//  EnterUsageTimeViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/07/09.
//

import UIKit

class EnterUsageTimeViewController: UIViewController {
    var loginUser: User?
    var selectedPublic: Public?
    var usingTime: Int = 10

    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemTimeTextField: UITextField!
    @IBOutlet weak var maxTimeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var minute5Button: UIButton!
    @IBOutlet weak var minute10Button: UIButton!
    @IBOutlet weak var minute15Button: UIButton!
    @IBOutlet weak var usingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginUser = LoginUser.loginUser
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: itemTimeTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.itemTimeTextField.becomeFirstResponder()
        self.updateUI()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func minute5ButtonHandler(_ sender: Any) {
        self.timeUpByButton(time: 5)
    }
    @IBAction func minute10ButtonHandler(_ sender: Any) {
        self.timeUpByButton(time: 10)
    }
    @IBAction func minute15ButtonHandler(_ sender: Any) {
        self.timeUpByButton(time: 15)
    }
    
    func timeUpByButton(time: Int) {
        if usingTime + time <= selectedPublic?.maxTime ?? 10 {
            self.usingTime += time
            self.updateUI()
        }
    }
    
    @IBAction func usingButtonHandler(_ sender: Any) {
        
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.itemTitleLabel.text = self.selectedPublic?.title
            self.maxTimeLabel.text = "최대 이용 가능 시간: \(self.selectedPublic?.maxTime ?? 10)분"
            self.maxTimeLabel.textColor = .systemRed
            self.itemTimeTextField.text = "\(self.usingTime)"
            self.timeView.layer.cornerRadius = 10
            self.minute5Button.layer.borderColor = UIColor.systemGray2.cgColor
            self.minute5Button.layer.borderWidth = 1
            self.minute5Button.layer.cornerRadius = 10
            self.minute10Button.layer.borderColor = UIColor.systemGray2.cgColor
            self.minute10Button.layer.borderWidth = 1
            self.minute10Button.layer.cornerRadius = 10
            self.minute15Button.layer.borderColor = UIColor.systemGray2.cgColor
            self.minute15Button.layer.borderWidth = 1
            self.minute15Button.layer.cornerRadius = 10
            self.usingButton.layer.cornerRadius = 10
        }
    }
}

extension EnterUsageTimeViewController {
    @objc private func textDidChange(_ notification: Notification) {
        // 글자수 제한
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                let maxLength = "\(self.selectedPublic?.maxTime ?? 10)".count
                // 초과되는 텍스트 제거
                if text.count >= maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
            }
        }
    }
}

extension EnterUsageTimeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
        let maxLength = 3
        if text.count >= maxLength && range.length == 0 && range.location < maxLength {
            return false
        }
        return true
    }
}
