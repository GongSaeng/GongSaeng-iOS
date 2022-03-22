//
//  LogOutPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/13.
//

import UIKit

class LogOutPopUpViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        // 로그아웃
        AuthService.logUserOut { isSucceded in
            if isSucceded {
                UserDefaults.standard.removeObject(forKey: "id")
                UserDefaults.standard.removeObject(forKey: "password")
                UserDefaults.standard.removeObject(forKey: "isVerified")
                UserDefaults.standard.removeObject(forKey: "loginUser")
                UserDefaults.standard.removeObject(forKey: "userImage")
                DispatchQueue.main.async {
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    let storyBoard = UIStoryboard.init(name: "LogOutPopUp", bundle: nil)
                    let popUpViewController = storyBoard.instantiateViewController(identifier: "LogOutCompletedPopUpViewController")
                    popUpViewController.modalPresentationStyle = .overCurrentContext
                    sceneDelegate.switchRootViewToInitial(animated: true) { viewController in
                        viewController?.present(popUpViewController, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: Helpers
    private func configure() {
        popUpView.layer.cornerRadius = 8
        [cancelButton, logOutButton].forEach {
            $0?.layer.cornerRadius = 18
            $0?.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            $0?.layer.borderWidth = 1
        }
    }
}
