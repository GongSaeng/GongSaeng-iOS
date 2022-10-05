//
//  AvailableThunder2Cell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/16.
//

import UIKit
import SnapKit
import Kingfisher

final class AvailableThunderCell: UITableViewCell {
    
    // MARK: Properties
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        imageView.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "33"))
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        return label
    }()
    
    private let timeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0, alpha: 0.6)
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        return label
    }()
    
    private let placeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0, alpha: 0.6)
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        return label
    }()
    
    private let peopleIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.3")
        imageView.tintColor = UIColor(white: 0, alpha: 0.6)
        return imageView
    }()
    
    private let totalNumOfPeopleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        return label
    }()
    
    private let remainingDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "colorPinkishOrange")
        return label
    }()
    
    private let remainingPeopleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.0, weight: .medium)
        label.textColor = .black
        label.text = "남은인원"
        return label
    }()
    
    private let remainingNumOfPeopleLabel = UILabel()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func layout() {
        [thumbnailImageView, titleLabel, timeIconImageView, timeLabel,
         placeIconImageView, placeLabel, peopleIconImageView,
         totalNumOfPeopleLabel, remainingDaysLabel,
         remainingPeopleLabel, remainingNumOfPeopleLabel]
            .forEach { contentView.addSubview($0) }
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(80.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(18.0)
        }
        
        timeIconImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(20.0)
            $0.width.equalTo(12.0)
            $0.height.equalTo(13.0)
        }

        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeIconImageView.snp.trailing).offset(5.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(60.0)
            $0.centerY.equalTo(timeIconImageView)
        }

        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(60.0)
            $0.top.equalTo(timeLabel.snp.bottom).offset(6.0)
        }

        totalNumOfPeopleLabel.snp.makeConstraints {
            $0.leading.equalTo(placeLabel)
            $0.top.equalTo(placeLabel.snp.bottom).offset(6.0)
        }

        placeIconImageView.snp.makeConstraints {
            $0.centerX.equalTo(timeIconImageView)
            $0.centerY.equalTo(placeLabel)
            $0.width.equalTo(12.0)
            $0.height.equalTo(13.0)
        }

        peopleIconImageView.snp.makeConstraints {
            $0.centerX.equalTo(placeIconImageView)
            $0.centerY.equalTo(totalNumOfPeopleLabel)
            $0.width.equalTo(14.0)
            $0.height.equalTo(16.0)
        }

        remainingDaysLabel.snp.makeConstraints {
            $0.centerX.equalTo(remainingPeopleLabel)
            $0.centerY.equalTo(titleLabel)
        }

        remainingPeopleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45.0)
            $0.trailing.equalToSuperview().inset(20.0)
        }

        remainingNumOfPeopleLabel.snp.makeConstraints {
            $0.top.equalTo(remainingPeopleLabel.snp.bottom).offset(2.0)
            $0.centerX.equalTo(remainingPeopleLabel)
        }
    }
}

extension AvailableThunderCell {
    func configure(data viewModel: ThunderListCellViewModel) {
        thumbnailImageView.kf.setImage(with: viewModel.thumnailImage)
        titleLabel.text = viewModel.title
        timeLabel.text = viewModel.meetingTime
        placeLabel.text = viewModel.placeName
        totalNumOfPeopleLabel.text = viewModel.totalNum
        remainingDaysLabel.font = .systemFont(ofSize: (viewModel.remainingDays == "Today") ? 16.0: 18.0, weight: .heavy)
        remainingDaysLabel.text = viewModel.remainingDays
        remainingNumOfPeopleLabel.attributedText = viewModel.remainingNum
    }
}
