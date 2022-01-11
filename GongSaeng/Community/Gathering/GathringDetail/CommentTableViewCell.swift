//
//  CommentTableViewCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/11.
//

import UIKit
import SnapKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: Properties
    private let writerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        imageView.layer.cornerRadius = 22.0
        imageView.image = UIImage(named: "3")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let writerNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor(white: 0, alpha: 0.87)
        return label
    }()
    
    private let uploadedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.textColor = .gray
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        writerNicknameLabel.text = "로제떡볶이"
        uploadedTimeLabel.text = "1시간 전"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.lineBreakMode = .byTruncatingTail
        contentsLabel.attributedText = NSAttributedString(string: "저요! 7시에 엘리베이터 앞에서 만나요. 가나다라마바사아자차카타파하 글자 길이 늘려서 테스트 중입니다. 안녕하세요~~~ 가나다라마바사아자차카타파하 가나다라마바사아자차카타파하 가나다라마바사아자차카타파하 가나다라마바사아자차카타파하 가나다라마바사아자차카타파하 가나다라마바사아자차카타파하", attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(white: 0, alpha: 0.7)])
    }
    
    private func layout() {
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        [writerImageView, writerNicknameLabel, uploadedTimeLabel, contentsLabel, dividingView].forEach { addSubview($0) }
        writerImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18.0)
            $0.width.height.equalTo(44.0)
        }
        
        writerNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(writerImageView)
            $0.leading.equalTo(writerImageView.snp.trailing).offset(12.0)
        }
        
        uploadedTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(writerNicknameLabel.snp.trailing).offset(8.0)
            $0.centerY.equalTo(writerNicknameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(writerNicknameLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(writerNicknameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        dividingView.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(32.0)
            $0.leading.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
            $0.bottom.equalToSuperview()//되나 ??
        }
    }
}
