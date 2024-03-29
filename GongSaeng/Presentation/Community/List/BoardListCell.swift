//
//  GatheringBoardCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit
import Kingfisher

class BoardListCell: UITableViewCell {
    
    // MARK: Properties
    var viewModel: BoardCellListViewModel? {
        didSet {
            configure()
            layout()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    private let writerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        imageView.layer.cornerRadius = 12.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let writerNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 0, alpha: 0.87)
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
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let dividingView: UIView = {
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        return dividingView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = UIColor(white: 0, alpha: 0.5)
        return label
    }()
    
    private lazy var gatheringStatusContentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = 6.0
        return contentView
    }()
    
    private lazy var gatheringStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        return label
    }()
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        if let thumbnailImageUrl = viewModel.thumbnailImageUrl { thumbnailImageView.kf.setImage(with: thumbnailImageUrl) }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.lineBreakMode = .byTruncatingTail
        contentsLabel.attributedText = NSAttributedString(string: viewModel.contents, attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(white: 0, alpha: 0.7)])
        titleLabel.text = viewModel.title
        if viewModel.communityType == .emergency {
            writerNicknameLabel.text = "익명"
            writerImageView.image = UIImage(named: "no_image")
        } else {
            writerNicknameLabel.text = viewModel.writerNickname
            writerImageView.kf.setImage(with: viewModel.writerImageUrl, placeholder: UIImage(named: "3"))
        }
        
        uploadedTimeLabel.text = viewModel.uploadedTimeText
        numberOfCommentsLabel.text = viewModel.numberOfComments
        
        
        switch viewModel.communityType {
        case .gathering:
            gatheringStatusContentView.backgroundColor = viewModel.isGathering ? UIColor(named: "colorPinkishOrange")?.withAlphaComponent(0.15) : UIColor(white: 0, alpha: 0.2)
            gatheringStatusLabel.text = viewModel.isGathering ? "모집중" : "모집완료"
            gatheringStatusLabel.textColor = viewModel.isGathering ? UIColor(named: "colorPinkishOrange") : .white
            
        case .emergency, .suggestion:
            categoryLabel.text = viewModel.category
        default:
            return
        }
    }
    
    private func layout() {
        guard let viewModel = viewModel else { return }
        [titleLabel, contentsLabel, thumbnailImageView, writerImageView, writerNicknameLabel, uploadedTimeLabel, commentImageView, numberOfCommentsLabel, dividingView].forEach { addSubview($0) }
        
        switch viewModel.communityType {
        case .gathering:
            gatheringStatusContentView.addSubview(gatheringStatusLabel)
            gatheringStatusLabel.snp.remakeConstraints { $0.center.equalToSuperview() }
            addSubview(gatheringStatusContentView)
            gatheringStatusContentView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(9.0)
                $0.leading.equalToSuperview().inset(18.0)
                $0.height.equalTo(19.0)
                $0.width.equalTo(viewModel.isGathering ? 41.0 : 52.0)
            }
            
            titleLabel.snp.remakeConstraints {
                $0.leading.equalTo(gatheringStatusContentView.snp.trailing).offset(6.0)
                $0.centerY.equalTo(gatheringStatusContentView)
                $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
            }
            
        case .free:
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(9.0)
                $0.leading.equalToSuperview().inset(18.0)
                $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
            }
            
        default:
            addSubview(categoryLabel)
            categoryLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(9.0)
                $0.leading.equalToSuperview().inset(18.0)
            }
            
            titleLabel.snp.remakeConstraints {
                $0.leading.equalTo(categoryLabel.snp.trailing).offset(6.0)
                $0.centerY.equalTo(categoryLabel)
                $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
            }
        }
        
        contentsLabel.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(18.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
        }
        
        thumbnailImageView.snp.remakeConstraints {
            $0.top.equalTo(contentsLabel)
            $0.leading.equalTo(contentsLabel.snp.trailing).offset(10.0)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.width.equalTo(viewModel.hasThumbnailImage ? 102.0 : 0)
            $0.height.equalTo(viewModel.hasThumbnailImage ? 68.0 : 0)
        }
        
        writerImageView.snp.remakeConstraints {
            $0.top.equalTo(viewModel.hasThumbnailImage ? thumbnailImageView.snp.bottom : contentsLabel.snp.bottom).offset(15.0)
            $0.leading.equalTo(contentsLabel)
            $0.width.height.equalTo(24.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        writerNicknameLabel.snp.remakeConstraints {
            $0.leading.equalTo(writerImageView.snp.trailing).offset(4.0)
            $0.centerY.equalTo(writerImageView)
            $0.trailing.lessThanOrEqualTo(uploadedTimeLabel)
        }
        
        numberOfCommentsLabel.snp.remakeConstraints {
            $0.trailing.equalToSuperview().inset(18.0)
            $0.centerY.equalTo(writerImageView)
        }
        
        commentImageView.snp.remakeConstraints {
            $0.trailing.equalTo(numberOfCommentsLabel.snp.leading).offset(-8.0)
            $0.centerY.equalTo(writerImageView)
            $0.width.equalTo(14.0)
            $0.height.equalTo(12.0)
        }
        
        uploadedTimeLabel.snp.remakeConstraints {
            $0.trailing.equalTo(commentImageView.snp.leading).offset(-16.0)
            $0.centerY.equalTo(writerImageView)
        }
        
        dividingView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
