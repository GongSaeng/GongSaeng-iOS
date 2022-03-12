//
//  MembershipWithdrawlPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/13.
//

import UIKit

class MembershipWithdrawlPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var withdrawlButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 8
        [cancelButton, withdrawlButton].forEach {
            $0?.layer.cornerRadius = 18
            $0?.layer.borderWidth = 1
        }
        cancelButton.layer.borderColor = #colorLiteral(red: 0.03701767698, green: 0.4746149778, blue: 0.4563334584, alpha: 1)
        withdrawlButton.layer.borderColor = #colorLiteral(red: 1, green: 0.5287927985, blue: 0.3420431912, alpha: 1)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func withdrawlButtonTapped(_ sender: UIButton) {
        // 회원탈퇴
        guard let rootViewController = self.view.window?.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let naviRootViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
        let viewController = UINavigationController(rootViewController: naviRootViewController)
        viewController.modalPresentationStyle = .fullScreen
        viewController.navigationBar.isHidden = true
        dismiss(animated: false) {
            rootViewController.present(viewController, animated: true) {
                let storyBoard = UIStoryboard.init(name: "MembershipWithdrawlPopUp", bundle: Bundle.main)
                let popUpViewController = storyBoard.instantiateViewController(identifier: "MembershipWithdrawlCompletedPopUpViewController")
                popUpViewController.modalPresentationStyle = .overCurrentContext
                viewController.present(popUpViewController, animated: false)
            }
        }
    }
}
