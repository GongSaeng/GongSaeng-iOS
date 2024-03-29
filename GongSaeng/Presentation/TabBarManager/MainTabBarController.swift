//
//  MainTabBarController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/09.
//

import UIKit

final class MainTabBarController: UITabBarController {
    var user: User?
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
        self.user = user
        
        view.backgroundColor = .white
        
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        let homeRootViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeRootViewController.user = user
        let homeViewController = templateNavigationController(tabTitle: "홈", unselectedImage: UIImage(named: "homeIcon"), selectedIamge: UIImage(named: "homeIconOn"), rootViewController: homeRootViewController)
        
        let thunderRootViewController = ThunderListViewController(user: user)
        let publicViewController = templateNavigationController(tabTitle: "번개", unselectedImage: UIImage(named: "public"), selectedIamge: UIImage(named: "publicOn"), rootViewController: thunderRootViewController)
        
        let communityRootViewController = storyboard.instantiateViewController(withIdentifier: "CommunityViewController") as! CommunityViewController
        communityRootViewController.user = user
        let communityViewController = templateNavigationController(tabTitle: "커뮤니티", unselectedImage: UIImage(named: "community"), selectedIamge: UIImage(named: "communityOn"), rootViewController: communityRootViewController)
        communityViewController.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        communityViewController.navigationBar.topItem?.backButtonDisplayMode = .default
        
        let myPageRootViewController = MyPageViewController()
        myPageRootViewController.delegate = self
        myPageRootViewController.user = user
        let myPageViewController = templateNavigationController(tabTitle: "마이페이지", unselectedImage: UIImage(named: "mypage"), selectedIamge: UIImage(named: "mypageOn"), rootViewController: myPageRootViewController)
        myPageViewController.navigationBar.tintColor = UIColor(named: "colorBlueGreen")
        
        viewControllers = [homeViewController, publicViewController, communityViewController, myPageViewController]
        
        tabBar.tintColor = .black
    }
    
    private func templateNavigationController(tabTitle: String, unselectedImage: UIImage?, selectedIamge: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = (tabTitle == "번개") ?
        ThunderNavigationViewController(rootViewController: rootViewController) :
        UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = tabTitle
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedIamge
        navigationController.navigationBar.topItem?.backButtonDisplayMode = .minimal
        return navigationController
    }
}

// MARK: MyPageViewControllerDelegate
extension MainTabBarController: MyPageViewControllerDelegate {
    func presentThunderView(index: Int) {
        self.selectedIndex = 1 // 번개
        guard let navigationViewController = self.selectedViewController as? ThunderNavigationViewController, let user = user else { return }
        let viewController = ThunderDetailViewController(user: user, index: index)
        viewController.modalPresentationStyle = .fullScreen
        navigationViewController.pushViewController(viewController, animated: true)
    }
}
