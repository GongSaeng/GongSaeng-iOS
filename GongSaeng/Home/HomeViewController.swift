//
//  HomeViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class HomeViewController: UIViewController {
    
    var user: User? {
        didSet {
            print("DEBUG: HomeViewController get user property")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DEBUG: HomeViewController ViewDidLoad")
//        self.loginUser = LoginUser.loginUser
//        guard let tabBarController = tabBarController as? AppTabbarController else { return }
//        tabBarController.user
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG: HomeViewController viewWillAppear")
        
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
