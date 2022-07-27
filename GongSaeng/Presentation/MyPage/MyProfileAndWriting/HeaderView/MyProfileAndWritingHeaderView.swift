//
//  MyProfileAndWritingHeaderView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/20.
//

import UIKit
import SnapKit
import Kingfisher

protocol MyProfileAndWritingHeaderViewDelegate: AnyObject {
    func didTapPostButton(myPostType: MyPostType)
}

final class MyProfileAndWritingHeaderView: UIView {
    
    // MARK: Properties
    weak var delegate: MyProfileAndWritingHeaderViewDelegate?
    var viewModel: MyProfileAndWritingHeaderViewModel
    
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
        button.addTarget(self, action: #selector(didPostButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var writtenCommentsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didCommentButtonTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    init(viewModel: MyProfileAndWritingHeaderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        updateButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func didPostButtonTap() {
        viewModel.selectedButtonType = .post
        updateButtonState()
        delegate?.didTapPostButton(myPostType: .post)
    }
    
    @objc
    private func didCommentButtonTap() {
        viewModel.selectedButtonType = .comment
        updateButtonState()
        delegate?.didTapPostButton(myPostType: .comment)
    }
    
    // MARK: Helpers
    private func updateButtonState() {
        let postsButtonTitle = NSAttributedString(
            string: "작성한 글",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
                .foregroundColor: viewModel.postButtonTextColor
            ])
        let commentsButtonTitle = NSAttributedString(
            string: "작성한 댓글",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
                .foregroundColor: viewModel.commentButtonTextColor
            ])

        writtenPostsButton.setAttributedTitle(postsButtonTitle, for: .normal)
        writtenCommentsButton.setAttributedTitle(commentsButtonTitle, for: .normal)
        
        writtenPostsButton.backgroundColor = viewModel.postButtonBackgroundColor
        writtenCommentsButton.backgroundColor = viewModel.commentButtonBackgroundColor
        
        writtenPostsButton.isEnabled = viewModel.isPostButtonEnabled
        writtenCommentsButton.isEnabled = viewModel.isCommentButtonEnabled
    }
    
    private func configure() {
        profileImageView.kf.setImage(with: viewModel.profileImageURL, placeholder: UIImage(named: "3"))
        nicknameLabel.text = viewModel.nickname
        jobLabel.text = viewModel.job
        emailLabel.text = viewModel.email
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingTail
        introduceLabel.attributedText = NSAttributedString(
            string: viewModel.introduce,
            attributes: [.font: UIFont.systemFont(ofSize: 13.0),
                         .foregroundColor: UIColor.systemGray,
                         .paragraphStyle: paragraphStyle])
    }
    
    private func layout() {
        self.snp.makeConstraints { $0.width.equalTo(UIScreen.main.bounds.width) }
        let stackView1 = UIStackView(arrangedSubviews: [jobImageView, jobLabel])
        let stackView2 = UIStackView(arrangedSubviews: [emailImageView, emailLabel])
        let stackView3 = UIStackView(arrangedSubviews: [writtenPostsButton, writtenCommentsButton])
        [stackView1, stackView2].forEach {
            $0.axis = .horizontal
            $0.spacing = 3.0
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
            $0.top.equalTo(introduceLabel.snp.bottom).offset(40.0)
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
