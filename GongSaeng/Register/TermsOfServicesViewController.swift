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
        
        let naviController = self.presentingViewController as! UINavigationController
        let registerViewController = naviController.viewControllers.last as! RegisterViewController
        registerViewController.viewWillAppear(false)
        dismiss(animated: true)
    }
}

