//
//  FullImageCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/15.
//

import UIKit
import SnapKit
import Kingfisher

final class FullImageCell: UICollectionViewCell {
    
    // MARK: Properties
    var imageUrl: URL? {
        didSet { fullImageView.kf.setImage(with: imageUrl) }
    }
    
    private let fullImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func layout() {
        addSubview(fullImageView)
        fullImageView.snp.makeConstraints { $0.edges.equalTo(0) }
    }
}
