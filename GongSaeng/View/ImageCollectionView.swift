//
//  ImageCollectionView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/11.
//

import UIKit

class ImageCollectionView: UICollectionView {
    private let reuseIdentifier = "WriteImageCell"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        register(WriteImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
