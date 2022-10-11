//
//  MyCommentCell.swift
//  GongSaeng
//
//  Created by Yujin Cha on 2022/10/11.
//

import UIKit

final class MyCommentCell: UITableViewCell {
    
    // MARK: Properties
    var data: MyComment? {
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
    
    private let postingTimeLabel: UILabel = {
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
        guard let data = data else { return }
        titleLabel.text = data.content
        postingTimeLabel.text = data.postingTime
    }
    
    private func layout() {
        [titleLabel, postingTimeLabel].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        postingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(titleLabel)
        }
    }
}
