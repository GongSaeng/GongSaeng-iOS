//
//  AppTabbarController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/05.
//

import UIKit

class AppTabbarController: UITabBarController {
    
    // MARK: Properties
    var user: User? {
        didSet {
            print("DEBUG: AppTabbarController get user property..")
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let viewController = self.viewControllers?.first else { return }
                viewController.viewWillAppear(true)
            }
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: AppTabbarController viewDidLoad")
        
        if let id = UserDefaults.standard.string(forKey: "id"), let password = UserDefaults.standard.string(forKey: "password") {
            AuthService.loginUserIn(withID: id, password: password) { [weak self] isSucceded in
                guard let self = self else { return }
                guard isSucceded else { return }
                DispatchQueue.main.async {
                    self.fetchUser()
                }
            }
        }
        // UserDefaults 에서 로그인 상태 체크
        // 로그인 안되어있으면 메인뷰를 루트뷰로 설정
//        checkIfUserIsLoggedIn()
        // fetchUser
        // fetch 안되면 메인뷰를 루트뷰로 설정
//        fetchUser()
    }
    
    // MARK: Helpers
//    private func checkIfUserIsLoggedIn() {
//        // UserDefaults 에서 스트링 가져오기
//        guard let _ = UserDefaults.standard.string(forKey: "id") else {
//            print("DEBUG: No userID in local..")
//            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
//            sceneDelegate.switchRootViewToMain(animated: true)
//            return
//        }
//        print("DEBUG: Has userID in local..")
//    }
    
    private func fetchUser() {
        UserService.fetchCurrentUser { [weak self] user in
            guard let self = self else { return }
            self.user = user
            if self.user == nil {
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
