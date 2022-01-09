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
    
    private let passwordLookingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noLookIcon"), for: .normal)
        button.setImage(UIImage(named: "lookIcon"), for: .selected)
        button.addTarget(self, action: #selector(changeTextSecure), for: .touchUpInside)
        return button
    }()
    
    private let passwordCheckLookingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noLookIcon"), for: .normal)
        button.setImage(UIImage(named: "lookIcon"), for: .selected)
        button.addTarget(self, action: #selector(changeTextSecure), for: .touchUpInside)
        return button
    }()
    
    private let passwordChangingButton: BannerButton = {
        let button = BannerButton(title: "비밀번호 변경하기", backgroundColor: .green)
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        configureNotificationObservers()
        updateSecureMode()
        updateButtonActivation()
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
    
    @objc func changePassword() {
        print("DEBUG: Did tap passwordChangingButton..")
        guard viewModel.password == viewModel.passwordCheck else {
            let viewController = PopUpViewController()
            viewController.detailText = "비밀번호가 일치하지 않습니다."
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: false, completion: nil)
            return
        }
        print("DEBUG: 비밀번호가 일치합니다.")
    }
    
    // MARK: Helpers
    private func updateSecureMode() {
        [passwordLookingButton, passwordCheckLookingButton].forEach { $0.isSelected = !viewModel.isSecureMode }
        [passwordTextField, passwordCheckTextField].forEach { $0.isSecureTextEntry = viewModel.isSecureMode }
        
    }
    
    private func updateButtonActivation() {
        passwordChangingButton.isActivated = viewModel.formIsValid
    }
    
    private func configureNotificationObservers() {
        [passwordTextField, passwordCheckTextField].forEach {
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
    }
    
    private func layout() {
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        let contentView = UIView()
        contentView.backgroundColor = .white
        [dividingView, passwordChangingButton].forEach { contentView.addSubview($0) }
        
        dividingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        passwordChangingButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        [changingPasswordLabel, passwordLabel, passwordTextField, passwordCheckLabel, passwordCheckTextField, passwordLookingButton, passwordCheckLookingButton, contentView].forEach { view.addSubview($0) }
        
        changingPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30.0)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20.0)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(changingPasswordLabel.snp.bottom).offset(34.0)
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
        
        contentView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80.0)
        }
    }
}
