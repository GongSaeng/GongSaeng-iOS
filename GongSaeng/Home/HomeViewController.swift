//
//  HomeViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class HomeViewController: UIViewController {
    
    var loginUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginUser = LoginUser.loginUser
    }
}
