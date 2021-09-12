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
        editProfileButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nickNameLabel.text = loginUser?.nickName
    }
    
    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EditProfile", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func myProfileAndWritingButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MyProfileAndWriting", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MyProfileAndWritingViewController") as! MyProfileAndWritingViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func requestCheckInOutButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func manageAccountInfoButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func setNotificationButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func askKakaoButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func membershipWithdrawlButtonTapped(_ sender: UIButton) {
    }
    
}
