//
//  MyWrittenPostCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/05/06.
//

import UIKit

final class MyWrittenPostCell: UITableViewCell {
    
    // MARK: Properties
    var viewModel: MyWrittenPostCellViewModel? {
        didSet { configure() }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .black.withAlphaComponent(0.87)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let postingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .systemGray
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "message")
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let numOfCommentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        switch CommunityType(rawValue: viewModel.code) {
        case .emergency:
            categoryLabel.text = "고민게시판"
        case .free:
            categoryLabel.text = "자유게시판"
        case .gathering:
            categoryLabel.text = "챌린지게시판"
        case .market:
            categoryLabel.text = "장터게시판"
        case .suggestion:
            categoryLabel.text = "맛집게시판"
        case .none:
            categoryLabel.text = ""
        }
        postingTimeLabel.text = viewModel.postingTime
        numOfCommentLabel.text = viewModel.numOfComment
    }
    
    private func layout() {
        [titleLabel, categoryLabel, postingTimeLabel, commentImageView, numOfCommentLabel].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(titleLabel)
        }
        
        postingTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryLabel)
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(8.0)
        }
        
        commentImageView.snp.makeConstraints {
            $0.centerY.equalTo(categoryLabel)
            $0.width.equalTo(18.0)
            $0.height.equalTo(14.0)
        }
        
        numOfCommentLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryLabel)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(6.0)
            $0.trailing.equalToSuperview().inset(18.0)
        }
    }
}
