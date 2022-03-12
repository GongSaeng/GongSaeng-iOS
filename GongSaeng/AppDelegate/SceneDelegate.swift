//
//  SceneDelegate.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var user: User?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.tintColor = .black
        
//        let rootViewController = InitialViewController()
        
        let rootViewController = ThunderListViewController()
        let viewController = TempNavigationViewController(rootViewController: rootViewController)
        
//        let viewController = LaunchScreenViewController()
        
//        let storyboard = UIStoryboard(name: "Temp", bundle: .main)//
//        let rootViewController = storyboard.instantiateViewController(withIdentifier: "TempViewController")//
//        let viewController = UINavigationController(rootViewController: rootViewController)//
//        viewController.navigationBar.isHidden = true//
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    func switchRootViewToInitial(animated: Bool = false, completion: ((UINavigationController?) -> Void)? = nil) {
        let naviRootViewController = InitialViewController()
        let viewController = UINavigationController(rootViewController: naviRootViewController)
        self.window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        guard let completion = completion else { return }
        completion(viewController)
        
        if animated {
            UIView.transition(with: window!,
                              duration: 0.4,
                              options: UIView.AnimationOptions.transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    func switchRootViewToMain(animated: Bool = false, completion: ((MainTabBarController?) -> Void)? = nil) {
        let viewController = MainTabBarController()
        self.window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        guard let completion = completion else { return }
        completion(viewController)
        
        if animated {
            UIView.transition(with: window!,
                              duration: 0.4,
                              options: UIView.AnimationOptions.transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}

