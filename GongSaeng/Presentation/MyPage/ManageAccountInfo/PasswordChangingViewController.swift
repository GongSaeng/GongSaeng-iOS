//
//  ChaangeViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/09.
//

import UIKit
import SnapKit

final class PasswordChangingViewController: UIViewController {
    
    // MARK: Properties
    private var viewModel = PasswordChangingViewModel()
    
    private let changingPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 변경"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    private let oldPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 비밀번호"
        label.textColor = UIColor.gray
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    private let oldPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        textField.placeholder = "현재 비밀번호를 입력해 주세요."
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = UIColor.gray
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        textField.placeholder = "8~22자리의 영문,숫자로 입력해주세요."
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let passwordCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = UIColor.gray
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    private let passwordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        textField.placeholder = "8~22자리의 영문,숫자로 입력해주세요."
        return textField
    }()
    
    private lazy var oldPasswordLookingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noLookIcon"), for: .normal)
        button.setImage(UIImage(named: "lookIcon"), for: .selected)
        button.addTarget(self, action: #selector(changeTextSecure), for: .touchUpInside)
        return button
    }()
    
    private lazy var passwordLookingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noLookIcon"), for: .normal)
        button.setImage(UIImage(named: "lookIcon"), for: .selected)
        button.addTarget(self, action: #selector(changeTextSecure), for: .touchUpInside)
        return button
    }()
    
    private lazy var passwordCheckLookingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noLookIcon"), for: .normal)
        button.setImage(UIImage(named: "lookIcon"), for: .selected)
        button.addTarget(self, action: #selector(changeTextSecure), for: .touchUpInside)
        return button
    }()
    
    private lazy var passwordInputAccessoryView: BannerButtonInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80.0)
        let passwordInputAccessoryView = BannerButtonInputAccessoryView(frame: frame, buttonTitle: "비밀번호 변경하기", buttonColor: .green)
        passwordInputAccessoryView.delegate = self
        return passwordInputAccessoryView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
        configureNotificationObservers()
        updateSecureMode()
        updateButtonActivation()
    }
    
    override var inputAccessoryView: UIView? {
        get { return passwordInputAccessoryView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Actions
    @objc func textDidChange(_ sender: UITextField) {
        if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == passwordCheckTextField {
            viewModel.passwordCheck = sender.text
        }
        updateButtonActivation()
    }
    
    @objc func changeTextSecure() {
        print("DEBUG: Did tap passwordLookingButton")
        viewModel.isSecureMode = !viewModel.isSecureMode
        updateSecureMode()
    }
    
    // MARK: Helpers
    private func updateSecureMode() {
        [oldPasswordLookingButton, passwordLookingButton, passwordCheckLookingButton].forEach { $0.isSelected = !viewModel.isSecureMode }
        [oldPasswordTextField, passwordTextField, passwordCheckTextField].forEach { $0.isSecureTextEntry = viewModel.isSecureMode }
        
    }
    
    private func updateButtonActivation() {
        passwordInputAccessoryView.isActivated = viewModel.formIsValid
    }
    
    private func configureNotificationObservers() {
        [oldPasswordTextField, passwordTextField, passwordCheckTextField].forEach {
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        [oldPasswordLabel, oldPasswordTextField, oldPasswordLookingButton, changingPasswordLabel, passwordLabel, passwordTextField, passwordCheckLabel, passwordCheckTextField, passwordLookingButton, passwordCheckLookingButton].forEach { view.addSubview($0) }
        
        changingPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30.0)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20.0)
        }
        
        oldPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(changingPasswordLabel.snp.bottom).offset(34.0)
            $0.leading.equalTo(changingPasswordLabel)
        }
        
        oldPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(oldPasswordLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(changingPasswordLabel)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-50.0)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(oldPasswordTextField.snp.bottom).offset(34.0)
            $0.leading.equalTo(changingPasswordLabel)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(changingPasswordLabel)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-50.0)
        }
        
        passwordCheckLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(34.0)
            $0.leading.equalTo(changingPasswordLabel)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordCheckLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(changingPasswordLabel)
            $0.trailing.equalTo(passwordTextField)
        }
        
        oldPasswordLookingButton.snp.makeConstraints {
            $0.centerY.equalTo(oldPasswordTextField)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-14.0)
            $0.width.height.equalTo(40.0)
        }
        
        passwordLookingButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordTextField)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-14.0)
            $0.width.height.equalTo(40.0)
        }
        
        passwordCheckLookingButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordCheckTextField)
            $0.trailing.equalTo(passwordLookingButton)
            $0.width.height.equalTo(40.0)
        }
    }
}

// MARK: BannerButtonInputAccessoryViewDelegate
extension PasswordChangingViewController: BannerButtonInputAccessoryViewDelegate {
    func didTapBannerButton() {
        print("DEBUG: Did tap passwordChangingButton..")
        guard let password = viewModel.password else { return }
        guard viewModel.password == viewModel.passwordCheck else {
            let popUpContents = "비밀번호가 일치하지 않습니다."
            let viewController = PopUpViewController(contents: popUpContents)
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: false, completion: nil)
            return
        }
        
        guard Normalization.isValidRegEx(regExKinds: "password", objectString: viewModel.password) else {
            let popUpContents = "8~22자리의 영문, 숫자로 입력해주세요."
            let viewController = PopUpViewController(contents: popUpContents)
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: false, completion: nil)
            return
        }
        
        UserService.editPassword(password: password) { [weak self] isSucceded in
            guard let self = self, isSucceded else {
                print("DEBUG: 비밀번호 변경 실패")
                return
            }
            UserDefaults.standard.set(password, forKey: "password")
            DispatchQueue.main.async {
                let popUpTitle = "비밀번호가 변경되었어요."
                let popUpViewController = PopUpViewController(contents: popUpTitle)
                popUpViewController.modalPresentationStyle = .overCurrentContext
                let rootViewController = self.navigationController?.viewControllers.first
                self.navigationController?.popToRootViewController(animated: true)
                rootViewController?.present(popUpViewController, animated: false, completion: nil)
            }
        }
        print("DEBUG: 비밀번호 변경 완료")
    }
}
