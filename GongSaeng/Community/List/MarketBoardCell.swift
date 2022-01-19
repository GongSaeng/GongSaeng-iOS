//
//  MarketBoardCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/17.
//

import UIKit
import SnapKit

class MarketBoardCell: UITableViewCell {
    
    // MARK: Properties
    var viewModel: MarketBoardCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21.0, weight: .bold)
        return label
    }()
    
    private let uploadedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.textColor = .gray
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "message")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let numberOfCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 0, alpha: 0.5)
        return label
    }()
    
    private let dividingView = UIView()
    
    private let completedDealView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let completedLabel = UILabel()
        completedLabel.text = "거래완료"
        completedLabel.font = .systemFont(ofSize: 16.0, weight: .heavy)
        completedLabel.textColor = .white
        
        contentView.addSubview(completedLabel)
        completedLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        return contentView
    }()

    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        let textColor =  UIColor(white: 0, alpha: viewModel.isOnSale ? 0.87 : 0.25)
        thumbnailImageView.image = viewModel.thumbnailImage
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        paragraphStyle.lineBreakMode = .byTruncatingTail
        titleLabel.attributedText = NSAttributedString(string: viewModel.title,
                                                       attributes: [.paragraphStyle: paragraphStyle,
                                                                    .font: UIFont.systemFont(ofSize: 19.0, weight: .medium),
                                                                    .foregroundColor: textColor.cgColor])
        priceLabel.textColor = textColor
        priceLabel.text = viewModel.price
        uploadedTimeLabel.text = viewModel.uploadedTimeText
        numberOfCommentsLabel.text = viewModel.numberOfComments
        completedDealView.isHidden = viewModel.isOnSale
    }

    private func layout() {
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        
        thumbnailImageView.addSubview(completedDealView)
        completedDealView.snp.makeConstraints { $0.edges.equalTo(0) }

        [thumbnailImageView, priceLabel, titleLabel, uploadedTimeLabel, commentImageView, numberOfCommentsLabel, dividingView].forEach { addSubview($0) }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.width.height.equalTo(UIScreen.main.bounds.width / 3.3)
        }
    
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView).offset(1.0)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(15.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(5.0)
            $0.leading.greaterThanOrEqualTo(thumbnailImageView.snp.trailing).offset(15.0)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.bottom.equalTo(numberOfCommentsLabel.snp.top).offset(-10.0)
        }

        numberOfCommentsLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18.0)
            $0.bottom.equalTo(thumbnailImageView)
        }

        commentImageView.snp.makeConstraints {
            $0.trailing.equalTo(numberOfCommentsLabel.snp.leading).offset(-8.0)
            $0.centerY.equalTo(numberOfCommentsLabel)
            $0.width.equalTo(14.0)
            $0.height.equalTo(12.0)
        }
        
        uploadedTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(commentImageView.snp.leading).offset(-16.0)
            $0.centerY.equalTo(numberOfCommentsLabel)
        }

        dividingView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(10.0)
            $0.leading.trailing.equalToSuperview().inset(18.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
