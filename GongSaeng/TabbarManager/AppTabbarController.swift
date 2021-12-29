//
//  AppTabbarController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/05.
//

import UIKit
 
class AppTabbarController: UITabBarController {
    
    // MARK: Properties
//    var user: User?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: AppTabbarController viewDidLoad")
        
        fetchUser()
    }
    
    // MARK: Helpers
    private func fetchUser() {
        UserService.fetchCurrentUser { [weak self] user in
            guard let self = self else { return }
            LoginUser.loginUser = user
//            self.user = user
            if LoginUser.loginUser == nil {
                print("DEBUG: No userID in server..")
                DispatchQueue.main.async {
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.switchRootViewToMain(animated: true)
                }
            } else {
                print("DEBUG: Has userID in server..")
            }
        }
    }
}
