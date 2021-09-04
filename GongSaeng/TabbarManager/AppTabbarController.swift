//
//  AppTabbarController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/05.
//

import UIKit

class AppTabbarController: UITabBarController {

    var loginUserString: String = ""
    var loginUser: User = User(id: "jyy0223", password: "1234qwer", name: "조영우", dateOfBirth: "19950223", phoneNumber: "01027111995", department: "부산센터", nickName: "하하하하하") // firebase에서 유저id로 부터 User를 들고와야함
    
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

