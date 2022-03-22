//
//  AttachedImageCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/25.
//

import UIKit
import SnapKit
import Kingfisher

final class AttachedImageCell: UICollectionViewCell {
    
    // MARK: Properties
    var imageURL: URL? {
        didSet { attachedImageView.kf.setImage(with: imageURL) }
    }
    
    private let attachedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    func updateImageHeight(_ height: CGFloat) {
        attachedImageView.snp.updateConstraints { $0.height.equalTo(height) }
    }
    
    // MARK: Helpers
    private func configure() {
        backgroundColor = .white
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowOpacity = 0.8
        contentView.layer.masksToBounds = false
    }
    
    private func layout() {
        contentView.addSubview(attachedImageView)
        attachedImageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(self.frame.height)
        }
    }
}
