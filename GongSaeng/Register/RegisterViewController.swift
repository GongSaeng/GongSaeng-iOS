//
//  RegisterViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class RegisterViewController: UIViewController {

    let colorLiteral = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
    @IBOutlet weak var allAgree: UIButton!
    @IBOutlet weak var firstAgree: UIButton!
    @IBOutlet weak var secondAgree: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    var firstViewController: TermsOfServicesViewController!
    var secondViewController: TermsOfServicesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstAgree.isSelected = TermsOfServicesViewModel.firstTermsOfServicesAgree
        secondAgree.isSelected = TermsOfServicesViewModel.secondTermsOfServicesAgree
        allAgree.isSelected = isAllCheck()
        checkboxClick(button: allAgree)
        checkboxClick(button: firstAgree)
        checkboxClick(button: secondAgree)
        nextButtonChange()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allAgreeHandler(_ sender: Any) {
        allAgree.isSelected = !allAgree.isSelected
        TermsOfServicesViewModel.firstTermsOfServicesAgree = allAgree.isSelected
        TermsOfServicesViewModel.secondTermsOfServicesAgree = allAgree.isSelected
        firstAgree.isSelected = TermsOfServicesViewModel.firstTermsOfServicesAgree
        secondAgree.isSelected = TermsOfServicesViewModel.secondTermsOfServicesAgree
        checkboxClick(button: allAgree)
        checkboxClick(button: firstAgree)
        checkboxClick(button: secondAgree)
        nextButtonChange()
    }
    
    @IBAction func firstAgreeHandler(_ sender: Any) {
        TermsOfServicesViewModel.firstTermsOfServicesAgree = !firstAgree.isSelected
        firstAgree.isSelected = TermsOfServicesViewModel.firstTermsOfServicesAgree
        allAgree.isSelected = isAllCheck()
        checkboxClick(button: allAgree)
        checkboxClick(button: firstAgree)
        checkboxClick(button: secondAgree)
        nextButtonChange()
    }
    
    @IBAction func secondAgreeHandler(_ sender: Any) {
        TermsOfServicesViewModel.secondTermsOfServicesAgree = !secondAgree.isSelected
        secondAgree.isSelected = TermsOfServicesViewModel.secondTermsOfServicesAgree
        allAgree.isSelected = isAllCheck()
        checkboxClick(button: allAgree)
        checkboxClick(button: firstAgree)
        checkboxClick(button: secondAgree)
        nextButtonChange()
    }
    
    @IBAction func firstAgreeDetailButtonHandler(_ sender: Any) {
        let sb = UIStoryboard.init(name: "TermsOfServices", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "TermsOfServicesViewController") as! TermsOfServicesViewController
        vc.viewModel.updateType(.first)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func secondAgreeDetailButtonHandler(_ sender: Any) {
        let sb = UIStoryboard.init(name: "TermsOfServices", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "TermsOfServicesViewController") as! TermsOfServicesViewController
        vc.viewModel.updateType(.second)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonHandler(_ sender: Any) {
        // 누르면 이동
        if allAgree.isSelected {
            performSegue(withIdentifier: "department", sender: nil)
        }
    }
    
    func checkboxClick(button: UIButton) {
        if button.isSelected {
            button.tintColor = self.colorLiteral
        } else {
            button.tintColor = UIColor.systemGray2
        }
    }
    
    func isAllCheck() -> Bool {
        // first, second 버튼으로 allbutton여부를 판단한다.
        if firstAgree.isSelected==true && secondAgree.isSelected==true {
            return true
        }
        return false
    }
    
    func nextButtonChange() {
        DispatchQueue.main.async {
            if self.allAgree.isSelected {
                self.nextButton.imageView?.image = UIImage(named: "nextButtonFill")
            } else {
                self.nextButton.imageView?.image = UIImage(named: "nextButton")
            }
        }
        
    }
}
