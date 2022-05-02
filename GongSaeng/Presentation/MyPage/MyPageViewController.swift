//
//  PageViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/04.
//

import UIKit
import SnapKit

class MyPageViewController: UITableViewController {
    
    // MARK: Properties
    var user: User? {
        didSet {
            print("DEBUG: MypageViewController user didSet..")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.configureUser()
            }
        }
    }
    var profileImage: UIImage? {
        didSet {
            print("DEBUG: MypageViewController profileImage didSet..")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.userImageView.image = self.profileImage
            }
        }
    }
    
    private let cellTitleList = ["내 프로필/작성글/댓글", "입/퇴실 신청", "계정 정보 관리", "알림 설정", "로그아웃", "회원탈퇴"]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()
    
    private lazy var profileEditButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "프로필 수정", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]), for: .normal)
        button.backgroundColor = UIColor(named: "colorBlueGreen")?.withAlphaComponent(0.1)
        button.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
        button.addTarget(self, action: #selector(didTapProfileEditButton), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "no_image")
        return imageView
    }()
    
    private let headerView = UIView()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: MyPageViewController ViewDidLoad..")
        layoutHeaderView()
        layout()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Actions
    @objc func didTapProfileEditButton() {
        print("DEBUG: Did tap profileEditButton..")
        guard let user = user else { return }
        let viewController = EditProfileViewController()
        viewController.viewModel = EditProfileViewModel(user: user)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helpers
    private func layout() {
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 204.5
    }
    
    private func configure() {
        tableView.separatorStyle = .none
    }
    
    private func configureUser() {
        print("DEBUG: MyPageViewController configure()..")
        guard let user = user else { return }
        nicknameLabel.text = user.nickname
        if let imageUrl = user.profileImageFilename {
            print("DEBUG: user.profileImageUrl ->", imageUrl)
            if let imageData = UserDefaults.standard.object(forKey: "userImage") as? Data, let image = UIImage(data: imageData) {
                profileImage = image
            } else {
                ImageCacheManager.getCachedImage(fileName: imageUrl) { [weak self] image in
                    guard let self = self, let imageData = image.jpegData(compressionQuality: 0.5) else { return }
                    UserDefaults.standard.set(imageData, forKey: "userImage")
                    self.profileImage = image
                }
            }
        }
    }
    
    private func layoutHeaderView() {
        let titleDividingView = UIView()
        let tableDividingView = UIView()
        [titleDividingView, tableDividingView].forEach {
            $0.backgroundColor = UIColor(white: 0, alpha: 0.05)
        }
        
        [titleLabel, nicknameLabel, profileEditButton, userImageView, titleDividingView, tableDividingView].forEach {
            headerView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15.0)
            $0.top.equalToSuperview().inset(16.0)
        }
        
        titleDividingView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15.5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(titleDividingView.snp.bottom).offset(30.0)
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(16.0)
            $0.leading.equalTo(nicknameLabel)
            $0.width.equalTo(158.0)
            $0.height.equalTo(40.0)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.width.height.equalTo(80.0)
        }
        
        tableDividingView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(8.0)
        }
    }
}

// MARK: UITableViewDataSource
extension MyPageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTitleList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let titleLabel = UILabel()
        titleLabel.text = cellTitleList[indexPath.row]
        titleLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        cell.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.0)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension MyPageViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: did Tap \(cellTitleList[indexPath.row])..")
        switch indexPath.row {
        case 0: // 내 프로필/작성글/댓글
//            let storyboard = UIStoryboard(name: "MyProfileAndWriting", bundle: Bundle.main)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "MyProfileAndWritingViewController") as! MyProfileAndWritingViewController
//            navigationController?.pushViewController(viewController, animated: true)
            print("DEBUG: Did tap 내 프로필/작성글/댓글..")
        case 1: // 입/퇴실 신청
//            let storyboard = UIStoryboard(name: "RequestCheckInOut", bundle: Bundle.main)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "RequestCheckInOutViewController") as! RequestCheckInOutViewController
//            viewController.modalPresentationStyle = .fullScreen
//            present(viewController, animated: true, completion: nil)
            print("DEBUG: Did tap 입/퇴실 신청..")
        case 2: // 계정 정보 관리
            guard let user = user else { return }
            let viewController = ManageAccountViewController()
            viewController.viewModel = ManageAccountViewModel(user: user)
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        case 3: // 알림 설정
//            let storyboard = UIStoryboard(name: "SetNotification", bundle: Bundle.main)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "SetNotificationViewController") as! SetNotificationViewController
//            viewController.modalPresentationStyle = .fullScreen
//            present(viewController, animated: true, completion: nil)
            print("DEBUG: Did tap 알림 설정..")
        case 4: // 로그아웃
            let storyBoard = UIStoryboard.init(name: "LogOutPopUp", bundle: Bundle.main)
            let popUpViewController = storyBoard.instantiateViewController(identifier: "LogOutPopUpViewController") as! LogOutPopUpViewController
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
        case 5: // 회원탈퇴
//            let storyBoard = UIStoryboard.init(name: "MembershipWithdrawlPopUp", bundle: Bundle.main)
//            let popUpViewController = storyBoard.instantiateViewController(identifier: "MembershipWithdrawlPopUpViewController") as! MembershipWithdrawlPopUpViewController
//            popUpViewController.modalPresentationStyle = .overCurrentContext
//            self.present(popUpViewController, animated: false, completion: nil)
            print("DEBUG: Did tap 회원탈퇴..")
        default:
            return
        }
    }
}
