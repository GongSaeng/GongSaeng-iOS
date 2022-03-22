//
//  MyProfileAndWritingHeaderView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/20.
//

import UIKit
import SnapKit
import Kingfisher

class MyProfileAndWritingHeaderView: UIView {
    
    // MARK: Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    private let jobImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bagicon")
        return imageView
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .systemGray4
        label.text = "대학생"
        return label
    }()
    
    private let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileGroupIcon")
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .systemGray4
        label.text = "@gongsaneng"
        return label
    }()
    
    private let introduceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .systemGray4
        label.text = "301호에 새로 들어왔어요~ 잘부탁드립니다. 현재 앱을 개발하는 일을 하고 있어요."
        return label
    }()
    
    private let dividingView: UIView = {
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        return dividingView
    }()
    
    private lazy var writtenPostsButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var writtenCommentsButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: Lifecycle
    
    // MARK: Helpers
    private func configure() {
        
    }
    
    private func layout() {
        
    }
}
