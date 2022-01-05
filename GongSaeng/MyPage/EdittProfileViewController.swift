//
//  EdittProfileViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/04.
//

import UIKit
import SnapKit

class EdittProfileViewController: UIViewController {
    
    // MARK: Properties
    let scrollView = UIScrollView()
    let contentsView = UIView()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 64.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        imageView.image = UIImage(named: "no_image")
        return imageView
    }()
    
    private let imageSettingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "변경", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .bold)]), for: .normal)
        button.addTarget(self, action: #selector(didTapImageSettingButton), for: .touchUpInside)
        return button
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        textField.attributedPlaceholder = NSAttributedString(string: "공생공생메이트", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return textField
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "소속"
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let jobTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        textField.attributedPlaceholder = NSAttributedString(string: "대학생", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return textField
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "웹사이트"
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14.0)
        textField.attributedPlaceholder = NSAttributedString(string: "@gongsaeng", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return textField
    }()
    
    private let introduceLabel: UILabel = {
        let label = UILabel()
        label.text = "소개"
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let introduceTextView: PostTextView = {
        let textView = PostTextView()
        textView.placeHolderText = "301호에 새로 들어왔어요~ 잘 부탁드립니다. 현재 앱을 개발하는 일을 하고 있어요."
//        textView.font = .systemFont(ofSize: 14.0, weight: .bold)
//        textView.text = "301호에 새로 들어왔어요~ 잘 부탁드립니다. 현재 앱을 개발하는 일을 하고 있어요."
        return textView
    }()
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        configure()
        configureNavigationView()
    }
    
    // MARK: Actions
    @objc func didTapImageSettingButton() {
        print("DEBUG: Did tap imageSettingButton..")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func didTapCompleteButton() {
        print("DEBUG: Did tap complete")
        print("DEBUG: nickName", nickNameTextField.text)
        print("DEBUG: job", jobTextField.text)
        print("DEBUG: email", emailTextField.text)
        print("DEBUG: introduce", introduceTextView.text)
    }
    
    // MARK: Helpers
    private func layout() {
        [userImageView, imageSettingButton, nickNameLabel, nickNameTextField , jobLabel, jobTextField, emailLabel, emailTextField, introduceLabel, introduceTextView].forEach { contentsView.addSubview($0) }
        scrollView.addSubview(contentsView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(0)
            $0.width.equalTo(view.frame.width)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(128.0)
        }
        
        imageSettingButton.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(16.0)
            $0.centerX.equalTo(userImageView)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageSettingButton.snp.bottom).offset(40.0)
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nickNameLabel)
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        jobLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(30.0)
            $0.leading.equalTo(nickNameLabel)
        }
        
        jobTextField.snp.makeConstraints {
            $0.top.equalTo(jobLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nickNameLabel)
            $0.trailing.equalTo(nickNameTextField)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(jobTextField.snp.bottom).offset(30.0)
            $0.leading.equalTo(nickNameLabel)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nickNameLabel)
            $0.trailing.equalTo(nickNameTextField)
        }

        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30.0)
            $0.leading.equalTo(nickNameLabel)
        }
        
        introduceTextView.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nickNameLabel)
            $0.trailing.equalTo(nickNameTextField)
            $0.height.equalTo(80.0)
            
            $0.bottom.equalToSuperview().inset(400.0)
        }
    }
    
    private func configure() {
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
    }
    
    private func configureNavigationView() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "프로필 수정"
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 0.8)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.topItem?.title = ""

        let rightBarButton = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapCompleteButton))
        rightBarButton.tintColor = UIColor(named: "colorBlueGreen")
        rightBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

extension EdittProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let seledtedImage = info[.editedImage] as? UIImage else { return }
        userImageView.layer.masksToBounds = true
        userImageView.image = seledtedImage.withRenderingMode(.alwaysOriginal)

        self.dismiss(animated: true, completion: nil)
    }
}
