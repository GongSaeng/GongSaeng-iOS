//
//  EditProfileViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/12.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var affiliationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var completeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
// MARK:- 키보드 보일 때 함수
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let scrollContentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
            scrollView.contentInset = scrollContentInset
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height)
        }
    }
// MARK:- 키보드 내릴 때 함수
    @objc func keyboardHideShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })

        let scrollContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = scrollContentInset
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    
    
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

private extension EditProfileViewController {
    func setupView() {
        userImageView.roundCornerOfImageView()
        
        [nickNameTextField, affiliationTextField, websiteTextField].forEach { $0.underlined(viewSize: view.bounds.width, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)) }
        
        let size = CGSize(width: introductionTextView.frame.width, height: .infinity)
        let estimatedSize = introductionTextView.sizeThatFits(size)
        
        introductionTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}


// MARK:- 텍스트뷰 델리게이트
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
