//
//  TermsOfServicesViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/22.
//

import UIKit

class TermsOfServicesViewController: UIViewController {
    
    let viewModel = TermsOfServicesViewModel()
    var detailTitle: String = "오류"
    var detail: String = "오류"
    
    @IBOutlet weak var termsOfServicesTitleLabel: UILabel!
    @IBOutlet weak var termsOfServicesTextView: UITextView!
    @IBOutlet weak var isAgreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTitle = viewModel.type.title
        detail = viewModel.type.detail
        isAgreeButton.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        termsOfServicesTitleLabel.text = detailTitle
        termsOfServicesTextView.text = detail
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func isAgreeButtonClicked(_ sender: Any) {
        if viewModel.type == .first {
            TermsOfServicesViewModel.firstTermsOfServicesAgree = true
        } else {
            TermsOfServicesViewModel.secondTermsOfServicesAgree = true
        }
        
        let mainViewController = self.view.window?.rootViewController as! FirstViewController
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: {
            let storyBoard = UIStoryboard(name: "Register", bundle: nil)
            let rootViewController = storyBoard.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.navigationBar.isHidden = true
            navigationController.modalPresentationStyle = .fullScreen
            mainViewController.present(navigationController, animated: false, completion: nil)
        })
    }
}

