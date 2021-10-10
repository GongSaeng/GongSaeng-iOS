//
//  MyPageViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/12.
//

import UIKit

class MyPageViewController: UIViewController {
    var loginUser: User?
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginUser = LoginUser.loginUser
        editProfileButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nickNameLabel.text = loginUser?.nickName
    }
    // 프로필 수정 버튼
    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EditProfile", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    // 내 프로필/작성글/댓글 버튼
    @IBAction func myProfileAndWritingButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MyProfileAndWriting", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MyProfileAndWritingViewController") as! MyProfileAndWritingViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    // 입/퇴실 신청
    @IBAction func requestCheckInOutButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RequestCheckInOut", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RequestCheckInOutViewController") as! RequestCheckInOutViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    // 계정 정보 관리
    @IBAction func manageAccountInfoButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ManageAccountInfo", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ManageAccountInfoViewController") as! ManageAccountInfoViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    // 알림 설정
    @IBAction func setNotificationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SetNotification", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SetNotificationViewController") as! SetNotificationViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    // 로그아웃
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "LogOutPopUp", bundle: nil)
        let popUpViewController = storyBoard.instantiateViewController(identifier: "LogOutPopUpViewController") as! LogOutPopUpViewController
        popUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(popUpViewController, animated: false, completion: nil)
    }
    // 회원탈퇴
    @IBAction func membershipWithdrawlButtonTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "MembershipWithdrawlPopUp", bundle: nil)
        let popUpViewController = storyBoard.instantiateViewController(identifier: "MembershipWithdrawlPopUpViewController") as! MembershipWithdrawlPopUpViewController
        popUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(popUpViewController, animated: false, completion: nil)
    }
}
