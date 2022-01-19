//
//  ManageAccountViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/09.
//

import UIKit
import SnapKit

class ManageAccountViewController: UIViewController {
    
    // MARK: Properties
    var viewModel: ManageAccountViewModel?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        return textField
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 주소"
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        return textField
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "번호"
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        return textField
    }()
    
    private let passwordChangingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
//        button.setTitleColor(UIColor.gray, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "비밀번호 변경", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]), for: .normal)
        button.addTarget(self, action: #selector(didTapPasswordChangingButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        configure()
        configureNavigationBar()
    }
    
    // MARK: Actions
    @objc func didTapPasswordChangingButton() {
        print("DEBUG: Did tap passwordChangingButton..")
        let viewController = PasswordChangingViewController()
        let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapCompleteButton() {
        print("DEBUG: Did tap completeButton..")
        guard let viewModel = viewModel, let nameText = nameTextField.text, let emailText = emailTextField.text, let phoneNumberText = phoneNumberTextField.text else { return }
        let name = !nameText.isEmpty ? nameText : viewModel.previousName
        let email = !emailText.isEmpty ? emailText : viewModel.previousEmail ?? ""
        let phoneNumber = !phoneNumberText.isEmpty ? phoneNumberText : viewModel.previousPhoneNumber
        print("DEBUG: name ->", name)
        print("DEBUG: email ->", email)
        print("DEBUG: phoneNumber ->", phoneNumber)
        showLoader(true)
        UserService.editAccount(name: name, email: email, phoneNumber: phoneNumber) { [weak self] isSucceded in
            guard let self = self else { return }
            guard isSucceded else {
                print("DEBUG: Edit account failed..")
                self.showLoader(false)
                return
            }
            UserService.fetchCurrentUser { user in
                UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: "loginUser")
                DispatchQueue.main.async {
                    self.showLoader(false)
                    guard let viewController = self.navigationController?.viewControllers.first as? MyPageViewController else { return }
                    viewController.user = user
                    self.navigationController?.popViewController(animated: true )
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        view.backgroundColor = .white
        nameTextField.attributedPlaceholder = NSAttributedString(string: viewModel.namePlaceholder, attributes: [.foregroundColor: UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: viewModel.emailPlaceholder, attributes: [.foregroundColor: UIColor.lightGray])
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: viewModel.phoneNumberPlaceholder, attributes: [.foregroundColor: UIColor.lightGray])
    }
    
    private func layout() {
        [nameLabel, nameTextField, emailLabel, emailTextField, phoneNumberLabel, phoneNumberTextField, passwordChangingButton].forEach {
            view.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20.0)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nameLabel)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(30.0)
            $0.leading.equalTo(nameLabel)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nameLabel)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30.0)
            $0.leading.equalTo(nameLabel)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nameLabel)
        }
        
        passwordChangingButton.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(40.0)
            $0.leading.equalTo(nameLabel)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.title = "계정 정보 관리"
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 0.8)
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.topItem?.title = ""

        let rightBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapCompleteButton))
        rightBarButton.tintColor = UIColor(named: "colorBlueGreen")
        rightBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
