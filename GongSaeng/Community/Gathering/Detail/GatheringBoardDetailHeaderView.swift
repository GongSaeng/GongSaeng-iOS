//
//  GatheringBoardDetailHeaderView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit

protocol GatheringBoardDetailHeaderViewDelegate: AnyObject {
    func completeGatheringStatus()
}

class GatheringBoardDetailHeaderView: UIView {
    
    // MARK: Properties
    weak var delegate: GatheringBoardDetailHeaderViewDelegate?
    
    var viewModel: GatheringBoardDetialHeaderViewModel? {
        didSet {
            configure()
            layout()
        }
    }
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    private let gatheredLabel: UILabel = {
        let label = UILabel()
        label.text = "모집이 완료되었어요."
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        return imageView
    }()
    
    private let numberOfCommentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 0, alpha: 0.8)
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        label.attributedText = NSAttributedString(string: "함께할 메이트님들이 다\n모집되었나요?", attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(white: 0, alpha: 0.7)])
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var gatheringCompletionButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "모집완료 처리하기", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium), .foregroundColor: UIColor(named: "colorPinkishOrange")!]), for: .normal)
        button.layer.cornerRadius = 11.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(named: "colorPinkishOrange")?.cgColor
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapCompletionButton), for: .touchUpInside)
        return button
    }()
    
    private let gatheringStatusContentView = UIView()
    private let gatheringCompletionContentView = UIView()
    private let dividingView = UIView()

    // MARK: Actions
    @objc func didTapCompletionButton() {
        print("DEBUG: Did tap completionButton..")
        delegate?.completeGatheringStatus()
    }
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        contentsLabel.attributedText = NSAttributedString(string: viewModel.contents, attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(white: 0, alpha: 0.8)])
        titleLabel.text = viewModel.title
        writerNicknameLabel.text = viewModel.writerNickname
        uploadedTimeLabel.text = viewModel.uploadedTimeText
        numberOfCommentsLabel.text = viewModel.numberOfCommentsText
        writerImageView.image = viewModel.writerImage
    }
    
    private func layout() {
        guard let viewModel = viewModel else { return }
        let isGathering = viewModel.isGathering
        let hasImages = viewModel.hasImages
        let canCompleteGathering = viewModel.canCompleteGathering
        
        gatheringStatusContentView.layer.cornerRadius = 6.0
        
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        
        if hasImages {
            addSubview(collectionView)
            let height: CGFloat = (UIScreen.main.bounds.width - 72.0) / 270 * 195
            collectionView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(3.0)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(height)
            }
        }
        
        [titleLabel, contentsLabel, writerImageView, writerNicknameLabel, uploadedTimeLabel, commentImageView, numberOfCommentsLabel, dividingView].forEach { addSubview($0) }
        
        titleLabel.snp.remakeConstraints {
            let screenWidth = UIScreen.main.bounds.width
            let newSize = titleLabel.sizeThatFits(CGSize(width: screenWidth - 36.0, height: .greatestFiniteMagnitude))
            $0.height.equalTo(newSize.height)
            $0.top.equalTo(hasImages ? collectionView.snp.bottom : self).offset(12.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        writerImageView.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(titleLabel)
            $0.width.height.equalTo(24.0)
        }
        
        writerNicknameLabel.snp.remakeConstraints {
            $0.leading.equalTo(writerImageView.snp.trailing).offset(4.0)
            $0.centerY.equalTo(writerImageView)
        }
        
        uploadedTimeLabel.snp.remakeConstraints {
            $0.leading.equalTo(writerNicknameLabel.snp.trailing).offset(8.0)
            $0.centerY.equalTo(writerImageView)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        contentsLabel.snp.remakeConstraints {
            let screenWidth = UIScreen.main.bounds.width
            let newSize = contentsLabel.sizeThatFits(CGSize(width: screenWidth - 36.0, height: .greatestFiniteMagnitude))
            $0.height.equalTo(newSize.height)
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(writerImageView.snp.bottom).offset(10.0)
            $0.trailing.equalToSuperview().inset(18.0)
        }
        
        if canCompleteGathering {
            gatheringCompletionContentView.backgroundColor = UIColor(named: "colorPaleOrange")?.withAlphaComponent(0.1)
            addSubview(gatheringCompletionContentView)
            [questionLabel, gatheringCompletionButton].forEach { gatheringCompletionContentView.addSubview($0) }
            gatheringCompletionContentView.snp.remakeConstraints {
                $0.top.equalTo(contentsLabel.snp.bottom).offset(20.0)
                $0.leading.trailing.equalToSuperview().inset(18.0)
                $0.height.equalTo(129.0)
            }
            
            questionLabel.snp.remakeConstraints {
                $0.top.leading.equalToSuperview().inset(20.0)
            }
            
            gatheringCompletionButton.snp.remakeConstraints {
                $0.leading.equalToSuperview().inset(21.0)
                $0.bottom.equalToSuperview().inset(16.0)
                $0.width.equalTo(137.0)
                $0.height.equalTo(43.0)
            }
        }
        
        if !isGathering {
            gatheringStatusContentView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            addSubview(gatheringStatusContentView)
            gatheringStatusContentView.snp.remakeConstraints {
                $0.top.equalTo(contentsLabel.snp.bottom).offset(22.0)
                $0.leading.trailing.equalToSuperview().inset(18.0)
                $0.height.equalTo(44.0)
            }
            
            gatheringStatusContentView.addSubview(gatheredLabel)
            gatheredLabel.snp.remakeConstraints { $0.center.equalToSuperview() }
        }
        
        dividingView.snp.remakeConstraints {
//            $0.top.equalTo(contentsLabel.snp.bottom).offset(24.0)
            $0.top.equalTo(canCompleteGathering ? gatheringCompletionContentView.snp.bottom :
                            (!isGathering ? gatheringStatusContentView.snp.bottom : contentsLabel.snp.bottom)).offset(24.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8.0)
        }
        
        commentImageView.snp.remakeConstraints {
            $0.top.equalTo(dividingView.snp.bottom).offset(14.0)
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(6.0)
            $0.width.height.equalTo(14.0)
        }
        
        numberOfCommentsLabel.snp.remakeConstraints {
            $0.leading.equalTo(commentImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(commentImageView)
        }
    }
}
