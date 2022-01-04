//
//  LaunchScreenViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/03.
//

import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        print("DEBUG: LaunchScreenViewController viewDidLoad")
        if let id = UserDefaults.standard.string(forKey: "id") {
            showLoader(true)
            guard let password = UserDefaults.standard.string(forKey: "password") else {
                print("DEBUG: No password key..")
                return
            }
            AuthService.loginUserIn(withID: id, password: password) { isSucceded in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showLoader(false)
                    if isSucceded {
                        print("DEBUG: Login success..")
                        sceneDelegate.switchRootViewToHome(animated: true)
                    }
                }
            }
            print("DEBUG: Has userID key..")
        } else {
            print("DEBUG: No userID key..")
            sceneDelegate.switchRootViewToMain()
        }
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        if let id = UserDefaults.standard.string(forKey: "id") {
            showLoader(true)
            guard let password = UserDefaults.standard.string(forKey: "password") else { return }
            AuthService.loginUserIn(withID: id, password: password) { isSucceded in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showLoader(false)
                    if isSucceded {
                        print("DEBUG: Login success..")
                        // UserDefaults ID 정보 저장
                        sceneDelegate.switchRootViewToHome(animated: true)
                    }
                }
            }
        } else {
            print("DEBUG: Else no userID")
            sceneDelegate.switchRootViewToMain(animated: true)
        }
    }
    
    private func configure() {
        view.addSubview(splashImageView)
        splashImageView.snp.makeConstraints {
            $0.width.equalTo(171.0)
            $0.height.equalTo(33.0)
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
