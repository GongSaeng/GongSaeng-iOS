//
//  NotificationViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/02.
//

import UIKit

class NotificationViewController: UIViewController {
    @IBOutlet weak var notificationCollectionView: UICollectionView!
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var allButtonUnderlinedView: UIView!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var noticeButtonUnderlinedView: UIView!
    @IBOutlet weak var publicButton: UIButton!
    @IBOutlet weak var publicButtonUnderlinedView: UIView!
    @IBOutlet weak var emergencyButton: UIButton!
    @IBOutlet weak var emergencyButtonUnderlinedView: UIView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var joinButtonUnderlinedView: UIView!
    @IBOutlet weak var suggestButton: UIButton!
    @IBOutlet weak var suggestButtonUnderlinedView: UIView!
    @IBOutlet weak var marketButton: UIButton!
    @IBOutlet weak var marketButtonUnderlinedView: UIView!
    
    @IBOutlet weak var notificationSettingImageView: UIImageView!
    @IBOutlet weak var deleteNotificationButton: UIButton!
    @IBOutlet weak var deleteNotificationButtonHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func buttonTapped(button: UIButton) {
        let buttonList: [UIButton] = [allButton, noticeButton, publicButton, emergencyButton, joinButton, suggestButton, marketButton]
        let buttonUnderlinedViewList: [UIView] = [allButtonUnderlinedView, noticeButtonUnderlinedView, publicButtonUnderlinedView, emergencyButtonUnderlinedView, joinButtonUnderlinedView, suggestButtonUnderlinedView, marketButtonUnderlinedView]
        let selectedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87)
        let notSelectedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        for index in 0..<buttonList.count {
            if buttonList[index] == button {
                buttonList[index].isSelected = true
                buttonList[index].isEnabled = false
                buttonList[index].setTitleColor(selectedColor, for: .normal)
                buttonUnderlinedViewList[index].isHidden = false
            } else {
                buttonList[index].isSelected = false
                buttonList[index].isEnabled = true
                buttonList[index].setTitleColor(notSelectedColor, for: .normal)
                buttonUnderlinedViewList[index].isHidden = true
            }
        }
    }
    
    private func buttonSetUp() {
        buttonTapped(button: allButton)
        deleteNotificationButton.isSelected = false
        deleteNotificationButton.setImage(UIImage(systemName: "checkmark"), for: .selected)
    }
    
    @IBAction func allButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func noticeButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func publicButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func emergencyButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func suggestButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func marketButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func deleteNotificationButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.isSelected {
        case true:
            self.deleteNotificationButtonHeightConstraint.constant = 15
            self.notificationSettingImageView.alpha = 0.3
        case false:
            self.deleteNotificationButtonHeightConstraint.constant = 24
            self.notificationSettingImageView.alpha = 1
        }
        
        notificationCollectionView.reloadData()
    }
    
}

extension NotificationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCollectionViewCell", for: indexPath) as? NotificationCollectionViewCell else { return UICollectionViewCell() }
        if deleteNotificationButton.isSelected {
            cell.deleteCellButton.isHidden = false
        } else {
            cell.deleteCellButton.isHidden = true
        }
    
        return cell
    }
}

extension NotificationViewController: UICollectionViewDelegate {
    
}

extension NotificationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return CGSize(width: width, height: 90)
    }
    

}

class NotificationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var deleteCellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.notificationImageView.layer.cornerRadius = self.notificationImageView.frame.height / 2
    }
}
