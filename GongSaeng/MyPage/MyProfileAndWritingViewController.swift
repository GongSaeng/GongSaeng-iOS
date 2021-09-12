//
//  MyProfileAndWriting.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/12.
//

import UIKit

class MyProfileAndWritingViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var introductionLabel: UITextView!
    @IBOutlet weak var writtenTextButton: UIButton!
    @IBOutlet weak var writtrnCommentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.roundCornerOfImageView()
        
        writtenTextButton.isEnabled = false
        inactivateButton(button: writtrnCommentButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func activateButton(button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87), for: .normal)
    }
    
    private func inactivateButton(button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), for: .normal)
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func writtenTextButtonTapped(_ sender: UIButton) {
        activateButton(button: writtenTextButton)
        inactivateButton(button: writtrnCommentButton)
        viewWillAppear(true)
    }
    
    @IBAction func writtenCommentButtonTapped(_ sender: UIButton) {
        activateButton(button: writtrnCommentButton)
        inactivateButton(button: writtenTextButton)
        viewWillAppear(true)
    }
    
}
