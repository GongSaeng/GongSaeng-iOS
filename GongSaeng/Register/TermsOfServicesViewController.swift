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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func isAgreeButtonClicked(_ sender: Any) {
        if viewModel.type == .first {
            TermsOfServicesViewModel.firstTermsOfServicesAgree = true
            dismiss(animated: true, completion: nil)
        } else {
            TermsOfServicesViewModel.secondTermsOfServicesAgree = true
            dismiss(animated: true, completion: nil)
        }
    }
}

