//
//  ImageInputAccessoryView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/12.
//

import UIKit
import SnapKit

protocol ImageInputAccessoryViewDelegate: AnyObject {
    func didTapimageAddingButton()
}

class ImageInputAccessoryView: UIView {
    
    // MARK: Properties
    weak var delegate: ImageInputAccessoryViewDelegate?
    
    var hasImage: Bool = false {
        didSet {
            if hasImage {
                imageContentView.snp.updateConstraints { $0.height.equalTo(92.0) }
            } else {
                imageContentView.snp.updateConstraints { $0.height.equalTo(0) }
            }
        }
    }
    
    var imageCollectionView: UICollectionView? {
        didSet {
            print("DEBUG: didSet")
            guard let imageCollectionView = imageCollectionView else { return }
            imageContentView.addSubview(imageCollectionView)
            imageCollectionView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(12.0)
                $0.leading.trailing.equalToSuperview()
            }
        }
    }
    
    private let imageContentView = UIView()
    
    private let imageAddingButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "gallery")
        button.setImage(UIImage(named: "gallery"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddingButton), for: .touchUpInside)
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
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: Actions
    @objc private func didTapAddingButton() { delegate?.didTapimageAddingButton() }
    
    
    // MARK: Helpers
    private func layout() {
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        imageContentView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        
        addSubview(imageContentView)
        addSubview(imageAddingButton)
        
        imageContentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        imageAddingButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(imageContentView.snp.bottom).offset(3.0)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-3.0)
        }
    }
}
