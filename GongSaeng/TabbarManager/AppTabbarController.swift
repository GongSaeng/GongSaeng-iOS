//
//  AppTabbarController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/05.
//

import UIKit

class AppTabbarController: UITabBarController {

    var loginUserString: String = "gongsaeng"
    var loginUser: User = User(id: "gongsaeng", password: "1234qwer", name: "유재석", dateOfBirth: "20001225", phoneNumber: "01012345678", department: "한국장학재단", nickName: "공생개발자") // firebase에서 유저id로 부터 User를 들고와야함
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // firebase 들고오는 로직
        LoginUser.loginUserReplacement(loginUser: self.loginUser)
    }
}

