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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.roundCornerOfImageView()
        
        [nickNameTextField, affiliationTextField, websiteTextField].forEach { $0.underlined(viewSize: view.bounds.width, color: UIColor.systemGray) }
        
        // introductionTextView의 밑줄 구현하기
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}