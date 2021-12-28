//
//  AppTabbarController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/05.
//

import UIKit

class AppTabbarController: UITabBarController {
    
    // MARK: Properties
    var user: User?
//    var loginUserString: String = "gongsaeng"
//    var loginUser: User = User(id: "gongsaeng", password: "1234qwer", name: "유재석", dateOfBirth: "20001225", phoneNumber: "01012345678", department: "한국장학재단", nickName: "공생개발자") // firebase에서 유저id로 부터 User를 들고와야함
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserDefaults 에서 로그인 상태 체크
        // 로그인 안되어있으면 메인뷰를 루트뷰로 설정
        checkIfUserIsLoggedIn()
        // fetchUser
        // fetch 안되면 메인뷰를 루트뷰로 설정
        fetchUser()
    }
    
    // MARK: Helpers
    private func checkIfUserIsLoggedIn() {
        // UserDefaults 에서 스트링 가져오기
        guard let _ = UserDefaults.standard.string(forKey: "id") else {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.switchRootViewToMain(animated: true)
            return
        }
    }
    
    private func fetchUser() {
        UserService.fetchCurrentUser { user in
            self.user = user
//            if self.user == nil {
//                DispatchQueue.main.async {
//                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
//                    sceneDelegate.switchRootViewToMain(animated: true)
//                }
//            }
        }
    }
}

//extension AppTabbarController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
//        print("DEBUG: Did Tap index ->", index)
//        switch index {
//        case 0:
//            print("DEBUG: Did Tap 1st tab")
//        case 1:
//            print("DEBUG: Did Tap 2nd tab")
//        case 2:
//            print("DEBUG: Did Tap 3rd tab")
//        case 3:
//            print("DEBUG: Did Tap 4th tab")
//        default:
//            print("DEBUG: Did Tap 5th tab")
//        }
//    }
//}
