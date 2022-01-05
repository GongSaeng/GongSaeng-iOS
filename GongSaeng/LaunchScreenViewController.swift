//
//  LaunchScreenViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/03.
//

import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    
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
    
    // MARK: Helpers
    private func layout() {
        view.addSubview(splashImageView)
        splashImageView.snp.makeConstraints {
            $0.width.equalTo(171.0)
            $0.height.equalTo(33.0)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func checkOutUserData() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        if let id = UserDefaults.standard.string(forKey: "id") {
            showLoader(true)
            guard let password = UserDefaults.standard.string(forKey: "password") else {
                print("DEBUG: No password key..")
                return
            }
            AuthService.loginUserIn(withID: id, password: password) { isSucceded, error in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showLoader(false)
                    if error?.localizedDescription == "Could not connect to the server." {
                        print("DEBUG: 서버에 연결할 수 없습니다..")
                        let alert = UIAlertController(title: "Error", message: "서버에 연결할 수 없습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if isSucceded {
                        print("DEBUG: Login success..")
                        sceneDelegate.switchRootViewToMain(animated: true)
                    }
                }
            }
            print("DEBUG: Has userID key..")
        } else {
            print("DEBUG: No userID key..")
            sceneDelegate.switchRootViewToInitial()
        }
    }
}
