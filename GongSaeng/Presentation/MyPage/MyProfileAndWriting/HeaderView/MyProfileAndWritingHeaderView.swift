//
//  MyProfileAndWritingHeaderView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/20.
//

import UIKit
import SnapKit
import Kingfisher

final class MyProfileAndWritingHeaderView: UIView {
    
    // MARK: Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()
    
    private let jobImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bagIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .systemGray
        label.text = "대학생"
        return label
    }()
    
    private let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileGroupIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .systemGray
        label.text = "@gongsaneng"
        return label
    }()
    
    private let introduceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
        updateButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func updateButtonState() {
        let postsButtonTitle = NSAttributedString(
            string: "작성한 글",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
                .foregroundColor: UIColor.black
            ])
        let commentsButtonTitle = NSAttributedString(
            string: "작성한 댓글",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
                .foregroundColor: UIColor.black.withAlphaComponent(0.2)
            ])

        writtenPostsButton.setAttributedTitle(postsButtonTitle, for: .normal)
        writtenCommentsButton.setAttributedTitle(commentsButtonTitle, for: .normal)
        
        writtenPostsButton.backgroundColor = .white
        writtenCommentsButton.backgroundColor = .black.withAlphaComponent(0.05)
//        writtenPostsButton.isEnabled = !bool
        
    }
    
    private func configure() {
        profileImageView.image = UIImage(named: "3")
        nicknameLabel.text = "공생공생메이트"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingTail
        introduceLabel.attributedText = NSAttributedString(
            string: "301호에 새로 들어왔어요~ 잘부탁드립니다. 현재 앱을 개발하는 일을 하고 있어요. 301호에 새로 들어왔어요~ 잘부탁드립니다. 현재 앱을 개발하는 일을 하고 있어요. 301호에 새로 들어왔어요~ 잘부탁드립니다. 현재 앱을 개발하는 일을 하고 있어요. 301호에 새로 들어왔어요~ 잘부탁드립니다. 현재 앱을 개발하는 일을 하고 있어요.",
            attributes: [.font: UIFont.systemFont(ofSize: 13.0),
                         .foregroundColor: UIColor.systemGray,
                         .paragraphStyle: paragraphStyle])
    }
    
    private func layout() {
        let stackView1 = UIStackView(arrangedSubviews: [jobImageView, jobLabel])
        let stackView2 = UIStackView(arrangedSubviews: [emailImageView, emailLabel])
        let stackView3 = UIStackView(arrangedSubviews: [writtenPostsButton, writtenCommentsButton])
        [stackView1, stackView2].forEach {
            $0.axis = .horizontal
            $0.spacing = 7.0
            $0.distribution = .equalCentering
        }
        stackView3.axis = .horizontal
        stackView3.spacing = 0
        stackView3.distribution = .fillEqually
        
        [profileImageView, nicknameLabel, stackView1, stackView2,
         introduceLabel, dividingView, stackView3]
            .forEach { self.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100.0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(24.0)
            $0.centerX.equalToSuperview()
        }
        
        stackView1.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18.0)
        }
        
        stackView2.snp.makeConstraints {
            $0.top.equalTo(stackView1.snp.bottom).offset(10.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18.0)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(stackView2.snp.bottom).offset(10.0)
            $0.leading.trailing.equalToSuperview().inset(45.0)
        }
        
        dividingView.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.top).offset(100)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        stackView3.snp.makeConstraints {
            $0.top.equalTo(dividingView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.bottom.equalToSuperview()
        }
    }
}
