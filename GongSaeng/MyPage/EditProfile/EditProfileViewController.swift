//
//  EditProfileViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/04.
//

import UIKit
import SnapKit

class EditProfileViewController: UIViewController {
    
    // MARK: Properties
    var viewModel: EditProfileViewModel?
    
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 64.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let imageSettingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "변경", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold)]), for: .normal)
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
        showLoader(true)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .currentContext
        showLoader(false)
        present(picker, animated: true, completion: nil)
    }
    
    @objc func didTapCompleteButton() {
        guard let viewModel = viewModel,
              let nickNameText = nickNameTextField.text,
              let jobText = jobTextField.text,
              let introduceText = introduceTextView.text else { return }
        print("DEBUG: Did tap complete")
        
        let profileImage: UIImage? = viewModel.isChangedUserImage ? userImageView.image : nil
        let nickName = !nickNameText.isEmpty ? nickNameText : viewModel.nickNamePlaceholder
        let job = !jobText.isEmpty ? jobText : viewModel.user.job ?? ""
        let introduce = !introduceText.isEmpty ? introduceText : viewModel.user.introduce ?? ""
        print("DEBUG: profileImage ->", profileImage)
        print("DEBUG: nickName ->", nickName)
        print("DEBUG: job ->", job)
        print("DEBUG: introduce ->", introduce)
        
        showLoader(true)
        UserService.editProfile(nickName: nickName, job: job, introduce: introduce, profileImage: profileImage) { [weak self] isSucceded, imageUrl in
            guard let self = self else { return }
            guard isSucceded else {
                print("DEBUG: Editing failed..")
                DispatchQueue.main.async {
                    self.showLoader(false)
                    let viewController = PopUpViewController()
                    viewController.detailText = "중복한 닉네임이 존재합니다."
                    viewController.modalPresentationStyle = .overCurrentContext
                    self.present(viewController, animated: false, completion: nil)
                }
                return
            }
            print("DEBUG: Before fetchUser ->", viewModel.user)
            print("DEBUG: isSucceded ->", isSucceded)
            UserService.fetchCurrentUser { user in
                print("DEBUG: After fetchUser ->", user)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: "loginUser")
                UserDefaults.standard.removeObject(forKey: "userImage")
                if let imageUrl = imageUrl {
                    ImageCacheManager.shared.removeObject(forKey: NSString(string: imageUrl))
                }
                DispatchQueue.main.async {
                    self.showLoader(false)
                    guard let viewController = self.navigationController?.viewControllers.first as? MyPageViewController else { return }
                    viewController.user = user
                    self.navigationController?.popViewController(animated: true )
                }
            }
        }
        
    }
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
        userImageView.image = viewModel.profileImage ?? UIImage(named: "no_image")
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: viewModel.nickNamePlaceholder, attributes: [.foregroundColor: UIColor.lightGray])
        jobTextField.attributedPlaceholder = NSAttributedString(string: viewModel.jobPlaceholder, attributes: [.foregroundColor: UIColor.lightGray])
        introduceTextView.placeHolderText = viewModel.introducePlaceholder
    }
    
    private func layout() {
        [userImageView, imageSettingButton, nickNameLabel, nickNameTextField , jobLabel, jobTextField, introduceLabel, introduceTextView].forEach { contentsView.addSubview($0) }
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

        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(jobTextField.snp.bottom).offset(30.0)
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
    
    private func configureNavigationView() {
        navigationItem.title = "프로필 수정"
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

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let seledtedImage = info[.editedImage] as? UIImage else { return }
        userImageView.image = seledtedImage.withRenderingMode(.alwaysOriginal)
        viewModel?.isChangedUserImage = true
        dismiss(animated: true)
    }
}
