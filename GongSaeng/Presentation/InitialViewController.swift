//
//  MainViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/03.
//

import UIKit
import SnapKit

final class InitialViewController: UIViewController {
    
    // MARK: Properties
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainImage")
        return imageView
    }()
    
    private let loginButton: BannerButton = {
        let button = BannerButton(title: "로그인", backgroundColor: .white)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let registerButton: BannerButton = {
        let button = BannerButton(title: "회원가입", backgroundColor: .green)
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        TermsOfServicesViewModel.firstTermsOfServicesAgree = false
        TermsOfServicesViewModel.secondTermsOfServicesAgree = false
    }
    
    // MARK: Actions
    @objc func didTapLoginButton() {
        print("DEBUG: Did tap loginButton..")
        let storyboard = UIStoryboard.init(name: "Login", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapRegisterButton() {
        print("DEBUG: Did tap registerButton")
        let storyBoard = UIStoryboard(name: "Register", bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helpers
    private func layout() {
        [logoImage, loginButton, registerButton].forEach {
            view.addSubview($0)
        }
        
        logoImage.snp.makeConstraints {
            $0.width.equalTo(165.0)
            $0.height.equalTo(184.0)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-92.0)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(88.0)
            $0.leading.equalToSuperview().inset(15.0)
            $0.trailing.equalToSuperview().inset(17.0)
            $0.height.equalTo(48.0)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(12.0)
            $0.leading.trailing.equalTo(loginButton)
            $0.height.equalTo(48.0)
        }
    }
}
