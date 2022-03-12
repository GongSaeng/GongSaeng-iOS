//
//  ParticipantImageCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/26.
//

import UIKit
import SnapKit
import Kingfisher

final class ParticipantImageCell: UICollectionViewCell {
    
    // MARK: Properties
    var imageURL: URL? {
        didSet {
            participantImageView.contentMode = .scaleAspectFill
            participantImageView.kf.setImage(with: imageURL)
        }
    }
    
    private let participantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "crown")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: Properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Animations
    func addShakeAnimation() {
        var iconShake = CABasicAnimation()
        iconShake = CABasicAnimation(keyPath: "transform.rotation.z")
        iconShake.fromValue = -0.1
        iconShake.toValue = 0.1
        iconShake.autoreverses = true
        iconShake.duration = 0.2
        iconShake.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(iconShake, forKey: "iconShakeAnimation")
    }
    
    func removeAnimation() {
        self.layer.removeAllAnimations()
    }
    
    // MARK: Helpers
    func configureVacancy() {
        participantImageView.contentMode = .center
        let config = UIImage.SymbolConfiguration(pointSize: 36.0)
        participantImageView.image = UIImage(systemName: "questionmark", withConfiguration: config)
        participantImageView.tintColor = .systemGray
    }
    
    func configureHost() {
        contentView.layer.borderColor = UIColor(displayP3Red: 1, green: 208/255, blue: 101/255, alpha: 1).cgColor
        contentView.layer.borderWidth = 2.0
        crownImageView.isHidden = false
    }
    
    private func configure() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 1.0
        self.backgroundColor = .clear
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = self.frame.height / 2
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        contentView.backgroundColor = UIColor(white: 0.87, alpha: 1)
        
        /*
         CollectionView - Cell(+ Crown) - ContentView - ImageView
              false       false(shadow)   true(radius)
         */
    }
    
    private func layout() {
        contentView.addSubview(participantImageView)
        participantImageView.snp.makeConstraints { $0.edges.equalToSuperview().inset(-3.0) }
        
        self.addSubview(crownImageView)
        crownImageView.snp.makeConstraints {
            $0.centerX.equalTo(participantImageView)
            $0.width.height.equalTo(30.0)
            $0.bottom.equalTo(participantImageView.snp.top).offset(13.0)
        }
    }
}
