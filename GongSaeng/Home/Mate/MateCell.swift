//
//  MateCell.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class MateCell: UICollectionViewCell {
    
    // MARK: Properties
    var viewModel: MateCellViewModel? {
        didSet { fetchMate() }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = CGColor(gray: 0, alpha: 0.1)
        
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.masksToBounds = true
    }
    
    func fetchMate() {
        guard let viewModel = viewModel else { return }
        
        profileImage.image = UIImage(named: "profileImage_0")
        nicknameLabel.text = viewModel.nickname
        jobLabel.text = viewModel.job
        emailLabel.text = viewModel.email
        introduceLabel.text = viewModel.introduce
    }
    
//    func updateUI(at index: Mate) {
//        DispatchQueue.main.async {
//
//            self.profileImage.image = UIImage(named: "profileImage_\(index.id).png")
//            self.nickNameLabel.text = index.nickName
//            self.emailLabel.text = index.email
//            self.introduceLabel.text = index.introduce
//        }
//    }
}
