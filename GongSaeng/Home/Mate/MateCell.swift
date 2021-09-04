//
//  MateCell.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class MateCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    func updateUI(at index: Mate) {
        DispatchQueue.main.async {
            self.profileImage.image = UIImage(named: "profileImage_\(index.id).png")
            self.nickNameLabel.text = index.nickName
            self.emailLabel.text = index.email
            self.introduceLabel.text = index.introduce
            
            self.layer.cornerRadius = 10.0
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.systemGray5.cgColor
            self.layer.masksToBounds = true
        }
    }
}
