//
//  GatheringBoardCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit

class GatheringBoardCell: UITableViewCell {
    
    // MARK: Properties
    var viewModel: GatheringBoardCellViewModel? {
        didSet {
            layout()
            configure()
        }
    }
    
    private let gatheringLabel: UILabel = {
        let label = UILabel()
        label.text = "모집중"
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = UIColor(named: "colorPinkishOrange")
        return label
    }()
    
    private let gatheredLabel: UILabel = {
        let label = UILabel()
        label.text = "모집완료"
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .white
        return label
    }()
    
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
        imageView.image = UIImage(named: "3")
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
        return imageView
    }()
    
    private let numberOfCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 0, alpha: 0.5)
        return label
    }()
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel, let title = viewModel.title, let contents = viewModel.contents, let writerNickname = viewModel.writerNickname, let uploadedTime = viewModel.uploadedTime, let numberOfComments = viewModel.numberOfComments else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.lineBreakMode = .byTruncatingTail
        contentsLabel.attributedText = NSAttributedString(string: contents, attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(white: 0, alpha: 0.7)])
        titleLabel.text = title
        writerNicknameLabel.text = writerNickname
        uploadedTimeLabel.text = uploadedTime
        numberOfCommentsLabel.text = numberOfComments
        writerImageView.image = viewModel.writerImage
    }
    
    private func layout() {
        guard let viewModel = viewModel, let isGathering = viewModel.isGathering else { return }
        let gatheringStatusContentView = UIView()
        gatheringStatusContentView.layer.cornerRadius = 6.0
        if isGathering {
            gatheringStatusContentView.addSubview(gatheringLabel)
            gatheringStatusContentView.backgroundColor = UIColor(named: "colorPinkishOrange")?.withAlphaComponent(0.15)
            gatheringLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        } else {
            gatheringStatusContentView.addSubview(gatheredLabel)
            gatheringStatusContentView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            gatheredLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        }
        
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        
        [gatheringStatusContentView, titleLabel, contentsLabel, writerImageView, writerNicknameLabel, uploadedTimeLabel, commentImageView, numberOfCommentsLabel, dividingView].forEach { addSubview($0) }
        
        gatheringStatusContentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9.0)
            $0.leading.equalToSuperview().inset(18.0)
            $0.height.equalTo(19.0)
            $0.width.equalTo(isGathering ? 41.0 : 52.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(gatheringStatusContentView.snp.trailing).offset(6.0)
            $0.centerY.equalTo(gatheringStatusContentView)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.leading.equalTo(gatheringStatusContentView)
            $0.top.equalTo(gatheringStatusContentView.snp.bottom).offset(10.0)
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        writerImageView.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(15.0)
            $0.leading.equalTo(gatheringStatusContentView)
            $0.width.height.equalTo(24.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        writerNicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(writerImageView.snp.trailing).offset(4.0)
            $0.centerY.equalTo(writerImageView)
            $0.trailing.lessThanOrEqualTo(uploadedTimeLabel)
        }
        
        numberOfCommentsLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18.0)
            $0.centerY.equalTo(writerImageView)
        }
        
        commentImageView.snp.makeConstraints {
            $0.trailing.equalTo(numberOfCommentsLabel.snp.leading).offset(-8.0)
            $0.centerY.equalTo(writerImageView)
            $0.width.height.equalTo(14.0)
        }
        
        uploadedTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(commentImageView.snp.leading).offset(-16.0)
            $0.centerY.equalTo(writerImageView)
        }
        
        dividingView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
