//
//  RegisterViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var allAgree: UIButton!
    @IBOutlet weak var firstAgree: UIButton!
    @IBOutlet weak var secondAgree: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    var firstViewController: TermsOfServicesViewController!
    var secondViewController: TermsOfServicesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allAgree.setImage(UIImage(named: "termAllOn"), for: .selected)
        firstAgree.setImage(UIImage(named: "termOn"), for: .selected)
        secondAgree.setImage(UIImage(named: "termOn"), for: .selected)
        nextButton.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstAgree.isSelected = TermsOfServicesViewModel.firstTermsOfServicesAgree
        secondAgree.isSelected = TermsOfServicesViewModel.secondTermsOfServicesAgree
        allAgree.isSelected = isAllCheck()
        nextButtonChange()
    }
    
    @IBAction func close(_ sender: Any) {
        TermsOfServicesViewModel.firstTermsOfServicesAgree = false
        TermsOfServicesViewModel.secondTermsOfServicesAgree = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allAgreeHandler(_ sender: Any) {
        allAgree.isSelected = !allAgree.isSelected
        TermsOfServicesViewModel.firstTermsOfServicesAgree = allAgree.isSelected
        TermsOfServicesViewModel.secondTermsOfServicesAgree = allAgree.isSelected
        firstAgree.isSelected = TermsOfServicesViewModel.firstTermsOfServicesAgree
        secondAgree.isSelected = TermsOfServicesViewModel.secondTermsOfServicesAgree
        nextButtonChange()
    }
    
    @IBAction func firstAgreeHandler(_ sender: Any) {
        TermsOfServicesViewModel.firstTermsOfServicesAgree = !firstAgree.isSelected
        firstAgree.isSelected = TermsOfServicesViewModel.firstTermsOfServicesAgree
        allAgree.isSelected = isAllCheck()
        nextButtonChange()
    }
    
    @IBAction func secondAgreeHandler(_ sender: Any) {
        TermsOfServicesViewModel.secondTermsOfServicesAgree = !secondAgree.isSelected
        secondAgree.isSelected = TermsOfServicesViewModel.secondTermsOfServicesAgree
        allAgree.isSelected = isAllCheck()
        nextButtonChange()
    }
    
    @IBAction func firstAgreeDetailButtonHandler(_ sender: Any) {
        let sb = UIStoryboard.init(name: "TermsOfServices", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "TermsOfServicesViewController") as! TermsOfServicesViewController
        vc.viewModel.updateType(.first)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func secondAgreeDetailButtonHandler(_ sender: Any) {
        let sb = UIStoryboard.init(name: "TermsOfServices", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "TermsOfServicesViewController") as! TermsOfServicesViewController
        vc.viewModel.updateType(.second)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonHandler(_ sender: Any) {
        // 누르면 이동
        if allAgree.isSelected {
            let storyboard = UIStoryboard(name: "Register", bundle: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "UniversityViewController") as! UniversityViewController
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func isAllCheck() -> Bool {
        // first, second 버튼으로 allbutton여부를 판단한다.
        if firstAgree.isSelected == true && secondAgree.isSelected == true {
            return true
        }
        return false
    }
    
    func nextButtonChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.allAgree.isSelected {
                self.nextButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            } else {
                self.nextButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
            }
        }
    }
}
