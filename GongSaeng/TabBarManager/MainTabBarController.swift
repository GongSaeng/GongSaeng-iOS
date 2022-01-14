//
//  MainTabBarController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/09.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchUser()
        configureViewController()
    }
    
    // MARK: API
    private func fetchUser() {
        UserService.fetchCurrentUser { user in
            guard let user = user else { return }
            print("DEBUG: Login user data -> \(user)")
        }
    }
    
    // MARK: Helpers
    private func configureViewController() {
        guard let data = UserDefaults.standard.object(forKey: "loginUser") as? Data, let user = try? PropertyListDecoder().decode(User.self, from: data) else { return }
        view.backgroundColor = .white
        
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        let homeRootViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeRootViewController.user = user
        let homeViewController = templateNavigationController(tabTitle: "홈", unselectedImage: UIImage(named: "homeIcon"), selectedIamge: UIImage(named: "homeIconOn"), rootViewController: homeRootViewController)
        
        let publicViewController = templateNavigationController(tabTitle: "공용", unselectedImage: UIImage(named: "public"), selectedIamge: UIImage(named: "publicOn"), rootViewController: storyboard.instantiateViewController(withIdentifier: "PublicViewController"))
        
        let communityRootViewController = storyboard.instantiateViewController(withIdentifier: "CommunityViewController") as! CommunityViewController
        communityRootViewController.user = user
        let communityViewController = templateNavigationController(tabTitle: "커뮤니티", unselectedImage: UIImage(named: "community"), selectedIamge: UIImage(named: "communityOn"), rootViewController: communityRootViewController)
        communityViewController.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        communityViewController.navigationBar.topItem?.backButtonDisplayMode = .default
        
        let notificationViewController = templateNavigationController(tabTitle: "알림", unselectedImage: UIImage(named: "alert"), selectedIamge: UIImage(named: "alertOn"), rootViewController: storyboard.instantiateViewController(withIdentifier: "NotificationViewController"))
        
        let myPageRootViewController = MyPageViewController()
        myPageRootViewController.user = user
        let myPageViewController = templateNavigationController(tabTitle: "마이페이지", unselectedImage: UIImage(named: "mypage"), selectedIamge: UIImage(named: "mypageOn"), rootViewController: myPageRootViewController)
        myPageViewController.navigationBar.tintColor = UIColor(named: "colorBlueGreen")
        
        viewControllers = [homeViewController, publicViewController, communityViewController, notificationViewController, myPageViewController]
        
        tabBar.tintColor = .black
    }
    
    private func templateNavigationController(tabTitle: String, unselectedImage: UIImage?, selectedIamge: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = tabTitle
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedIamge
        navigationController.navigationBar.topItem?.backButtonDisplayMode = .minimal
        return navigationController
    }
}
