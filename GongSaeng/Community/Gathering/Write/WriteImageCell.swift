//
//  WriteImageCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/11.
//

import UIKit
import SnapKit

protocol WriteImageCellDelegate: AnyObject {
    func subtractImage(indexPath: IndexPath)
}

class WriteImageCell: UICollectionViewCell {
    
    // MARK: Properties
    var indexPath: IndexPath?
    weak var delegate: WriteImageCellDelegate?
    
    var image: UIImage? {
        didSet { attachedimageView.image = image }
    }
    
    private let attachedimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "3")
        return imageView
    }()
    
    private lazy var deleteImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deleteIcon"), for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc private func didTapDeleteButton() {
        guard let indexPath = indexPath else { return }
        delegate?.subtractImage(indexPath: indexPath)
    }
    
    // MARK: Helpers
    private func layout() {
        [attachedimageView, deleteImageButton].forEach { addSubview($0) }
        attachedimageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(102.0)
            $0.height.equalTo(68.0)
        }
        
        deleteImageButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(44.0)
        }
    }
}
