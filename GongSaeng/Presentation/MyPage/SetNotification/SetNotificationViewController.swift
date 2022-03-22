//
//  SetNotificationViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/13.
//

import UIKit

class SetNotificationViewController: UIViewController {
    @IBOutlet weak var commentNotificationButton: UIButton!
    @IBOutlet weak var withNotificationButton: UIButton!
    @IBOutlet weak var proposalNotificationButton: UIButton!
    @IBOutlet weak var marketNotificationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 True 임시 초기화
        [commentNotificationButton, withNotificationButton, proposalNotificationButton, marketNotificationButton].forEach {
            $0?.setImage(UIImage(named: "on.png"), for: .normal)
            $0?.isSelected = true
        }
    }
    
    private func notificationButtonTapped(button: UIButton) {
        switch button.isSelected {
        case true:
            button.setImage(UIImage(named: "off.png"), for: .normal)
        case false:
            button.setImage(UIImage(named: "on.png"), for: .normal)
        }
        button.isSelected = !button.isSelected
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commentNotificationButtonTapped(_ sender: UIButton) {
        notificationButtonTapped(button: sender)
    }
    
    @IBAction func withNotificationButtonTapped(_ sender: UIButton) {
        notificationButtonTapped(button: sender)
    }
    
    @IBAction func proposalNotificationButtonTapped(_ sender: UIButton) {
        notificationButtonTapped(button: sender)
    }
    
    @IBAction func marketNotificationButtonTapped(_ sender: UIButton) {
        notificationButtonTapped(button: sender)
    }
}
