//
//  LaunchScreenViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/03.
//

import UIKit
import SnapKit

final class LaunchScreenViewController: UIViewController {
    
    // MARK: Properties
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        checkOutUserData()
    }
    
    // MARK: API
    private func checkOutUserData() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        guard let id = UserDefaults.standard.string(forKey: "id"), let password = UserDefaults.standard.string(forKey: "password") else {
            print("DEBUG: No userID key..") // 로컬에 유저 정보 없은 경우
            sceneDelegate.switchRootViewToInitial()
            return
        }
        print("DEBUG: Has userID key..")
        showLoader(true)
        
        AuthService.loginUserIn(withID: id, password: password) { [weak self] isSucceded, bool, error in
            print("DEBUG: AuthService.loginUserIn() called..")
            // 서버 연결 에러
            guard let self = self else { return }
            self.showLoader(false)
            if error?.localizedDescription == "Could not connect to the server." {
                print("DEBUG: 서버에 연결할 수 없습니다..")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "서버에 연결할 수 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            guard isSucceded else {
                // 유저 정보가 있는데 정보가 틀린경우
                UserDefaults.standard.removeObject(forKey: "id")
                UserDefaults.standard.removeObject(forKey: "password")
                DispatchQueue.main.async {
                    sceneDelegate.switchRootViewToInitial()
                }
                return
            }
            
            print("DEBUG: Login success..")
            guard let _ = UserDefaults.standard.object(forKey: "loginUser") else {
                print("DEBUG: UserCacheManager.shared.object -> nil")
                UserService.fetchCurrentUser { user in
                    guard let user = user else { return }
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: "loginUser")
                    print("DEBUG: Login user data -> \(user)")
                    DispatchQueue.main.async {
                        print("DEBUG: sceneDelegate.switchRootViewToMain(animated: true)")//
                        sceneDelegate.switchRootViewToMain(animated: true)
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                print("DEBUG: sceneDelegate.switchRootViewToMain(animated: true)")//
                sceneDelegate.switchRootViewToMain(animated: true)
            }
        }
        
    }
    
    // MARK: Helpers
    private func layout() {
        view.addSubview(splashImageView)
        splashImageView.snp.makeConstraints {
            $0.width.equalTo(171.0)
            $0.height.equalTo(33.0)
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
