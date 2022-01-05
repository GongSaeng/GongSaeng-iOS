//
//  MainTabBarController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/04.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        configureViewController()
    }
    
    // MARK: API
    private func fetchUser() {
        UserService.fetchCurrentUser { user in
            LoginUser.loginUser = user
            if LoginUser.loginUser == nil {
                print("DEBUG: No userID in server..")
                DispatchQueue.main.async {
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.switchRootViewToInitial(animated: true)
                }
            } else {
                print("DEBUG: Has userID in server..")
            }
        }
    }
    
    // MARK: Helpers
    private func configureViewController() {
        view.backgroundColor = .white
        
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        let homeViewController = templateNavigationController(tabTitle: "홈", unselectedImage: UIImage(named: "homeIcon"), selectedIamge: UIImage(named: "homeIconOn"), rootViewController: storyboard.instantiateViewController(withIdentifier: "HomeViewController"))
        
        let publicViewController = templateNavigationController(tabTitle: "공용", unselectedImage: UIImage(named: "public"), selectedIamge: UIImage(named: "publicOn"), rootViewController: storyboard.instantiateViewController(withIdentifier: "PublicViewController"))
        
        let communityViewController = templateNavigationController(tabTitle: "커뮤니티", unselectedImage: UIImage(named: "community"), selectedIamge: UIImage(named: "communityOn"), rootViewController: storyboard.instantiateViewController(withIdentifier: "CommunityViewController"))
        
        let notificationViewController = templateNavigationController(tabTitle: "알림", unselectedImage: UIImage(named: "alert"), selectedIamge: UIImage(named: "alertOn"), rootViewController: storyboard.instantiateViewController(withIdentifier: "NotificationViewController"))
        
//        let myPageViewController = templateNavigationController(tabTitle: "마이페이지", unselectedImage: UIImage(named: "mypage"), selectedIamge: UIImage(named: "mypageOn"), rootViewController: storyboard.instantiateViewController(withIdentifier: "MyPageViewController"))
        let myPageViewController = templateNavigationController(tabTitle: "마이페이지", unselectedImage: UIImage(named: "mypage"), selectedIamge: UIImage(named: "mypageOn"), rootViewController: MyPageViewController())
        
        viewControllers = [homeViewController, publicViewController, communityViewController, notificationViewController, myPageViewController]
        
        tabBar.tintColor = .black
    }
    
    private func templateNavigationController(tabTitle: String, unselectedImage: UIImage?, selectedIamge: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = tabTitle
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedIamge
        navigationController.navigationBar.tintColor = .black
        return navigationController
    }
}
