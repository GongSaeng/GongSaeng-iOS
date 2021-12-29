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
        print("DEBUG: scene(_, willConnctoTo, Options)")

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        
        if let id = UserDefaults.standard.string(forKey: "id") {
            print("DEBUG: Has userID")
            guard let password = UserDefaults.standard.string(forKey: "password") else { return }
            AuthService.loginUserIn(withID: id, password: password) { [weak self] isSucceded in
                guard let self = self else { return }
                guard isSucceded else { return }
                DispatchQueue.main.async {
                    self.switchRootViewToHome()
                }
            }
        } else {
            print("DEBUG: No userID")
            switchRootViewToMain()
        }
        
//        UserService.fetchCurrentUser { user in
//            DispatchQueue.main.async {
//                if user == nil {
//                    print("DEBUG: Not logged in..")
//                    self.switchRootViewToMain()
//                } else {
//                    print("DEBUG: logged in..")
//                    self.switchRootViewToHome()
//                }
//            }
//        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("DEBUG: sceneDidBecomeActive(_ scene: UIScene)")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("DEBUG: sceneDidDisconnect(_ scene: UIScene)")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("DEBUG: sceneWillResignActive(_ scene: UIScene)")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("DEBUG: sceneDidEnterBackground(_ scene: UIScene)")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("DEBUG: sceneWillEnterForeground(_ scene: UIScene)")
    }
    
    func switchRootViewToMain(animated: Bool = false, completion: ((UIViewController?) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let naviRootViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
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
            print("DEBUG: animated")
        }
    }
    
    func switchRootViewToHome(animated: Bool = false, completion: ((UIViewController?) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AppTabbarController") as! AppTabbarController
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
            print("DEBUG: animated")
        }
    }
}

