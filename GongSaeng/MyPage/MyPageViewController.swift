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
    
    
    
    
}
