//
//  BoardDetailHeaderView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit

protocol BoardDetailHeaderViewDelegate: AnyObject {
    func completeGatheringStatus()
}

class BoardDetailHeaderView: UIView {
    
    // MARK: Properties
    weak var delegate: BoardDetailHeaderViewDelegate?
    private let communityType: CommunityType
    
    var viewModel: BoardDetialHeaderViewModel? {
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
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
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
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
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 0, alpha: 0.8)
        return label
    }()
    
    private let dividingView: UIView = {
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        return dividingView
    }()
    
    private lazy var completePostingStatusContentView = UIView()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var completePostingStatusButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 11.0
        button.layer.borderWidth = 1.0
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapCompletionButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var completedStatusContentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return contentView
    }()
    
    private lazy var completedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .bold)
        label.numberOfLines = 1
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = UIColor(white: 0, alpha: 0.5)
        return label
    }()
    
    // MARK: Lifecycle
    init(communityType: CommunityType) {
        self.communityType = communityType
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc func didTapCompletionButton() {
        print("DEBUG: Did tap completionButton..")
        delegate?.completeGatheringStatus()
    }
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        let isValid = viewModel.isValid
        let canCompletePost = viewModel.canCompletePost

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        contentsLabel.attributedText = NSAttributedString(string: viewModel.contents, attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(white: 0, alpha: 0.8)])
        titleLabel.text = viewModel.title
        writerNicknameLabel.text = viewModel.writerNickname
        uploadedTimeLabel.text = viewModel.uploadedTimeText
        numberOfCommentsLabel.text = viewModel.numberOfCommentsText
        writerImageView.kf.setImage(with: viewModel.writerImageUrl, placeholder: UIImage(named: "3"))
        switch communityType {
        case .gathering:
            if canCompletePost {
                questionLabel.attributedText = NSAttributedString(string: "함께할 메이트님들이 다\n모집되었나요?", attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(white: 0, alpha: 0.7)])
                completePostingStatusButton.setAttributedTitle(NSAttributedString(string: "모집완료 처리하기", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium), .foregroundColor: UIColor(named: "colorPinkishOrange")!]), for: .normal)
                completePostingStatusButton.layer.borderColor = UIColor(named: "colorPinkishOrange")?.cgColor
                completePostingStatusContentView.backgroundColor = UIColor(named: "colorPaleOrange")?.withAlphaComponent(0.1)
            } else if !isValid {
                completedLabel.text = "모집이 완료되었어요."
                completePostingStatusContentView.isHidden = true
            }
            
        case .market:
            if canCompletePost {
                questionLabel.attributedText = NSAttributedString(string: "위 상품의\n거래가 다 끝나셨다면,", attributes: [.paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor(white: 0, alpha: 0.7)])
                completePostingStatusButton.setAttributedTitle(NSAttributedString(string: "거래완료 처리하기", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium), .foregroundColor: UIColor(named: "colorBlueGreen")!]), for: .normal)
                completePostingStatusButton.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
                completePostingStatusContentView.backgroundColor = UIColor(named: "colorBlueGreen")?.withAlphaComponent(0.1)
            } else if !isValid {
                completedLabel.text = "거래가 완료되었어요."
                completePostingStatusContentView.isHidden = true
            }
            priceLabel.text = viewModel.price
        case .suggestion, .emergency:
            categoryLabel.text = viewModel.category
        default:
            return
        }
    }
    
    private func layout() {
        guard let viewModel = viewModel else { return }
        let isValid = viewModel.isValid
        let hasImages = viewModel.hasImages
        let canCompletePost = viewModel.canCompletePost
        
        completedStatusContentView.layer.cornerRadius = 6.0
        
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
        
        if communityType == .emergency || communityType == .suggestion {
            addSubview(categoryLabel)
            categoryLabel.snp.remakeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.leading.equalToSuperview().inset(18.0)
            }
            
            titleLabel.snp.remakeConstraints {
                let screenWidth = UIScreen.main.bounds.width
                let categoryWidth = categoryLabel.frame.width
                let newSize = titleLabel.sizeThatFits(CGSize(width: screenWidth - categoryWidth - 36.0, height: .greatestFiniteMagnitude))
                $0.height.equalTo(newSize.height)
                $0.top.equalTo(hasImages ? collectionView.snp.bottom : self).offset(12.0)
                $0.leading.equalTo(categoryLabel.snp.trailing).offset(6.0)
                $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
            }
        } else {
            titleLabel.snp.remakeConstraints {
                let screenWidth = UIScreen.main.bounds.width
                let newSize = titleLabel.sizeThatFits(CGSize(width: screenWidth - 36.0, height: .greatestFiniteMagnitude))
                $0.height.equalTo(newSize.height)
                $0.top.equalTo(hasImages ? collectionView.snp.bottom : self).offset(12.0)
                $0.leading.equalToSuperview().inset(18.0)
                $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
            }
        }
        
        if communityType == .market {
            addSubview(priceLabel)
            priceLabel.snp.remakeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
                $0.leading.equalToSuperview().inset(18.0)
                $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
            }
        }
        
        writerImageView.snp.remakeConstraints {
            $0.top.equalTo((communityType == .market ? priceLabel : titleLabel).snp.bottom).offset(12.0)
            $0.leading.equalToSuperview().inset(18.0)
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
            $0.leading.equalToSuperview().inset(18.0)
            $0.top.equalTo(writerImageView.snp.bottom).offset(10.0)
            $0.trailing.equalToSuperview().inset(18.0)
        }
        if communityType == .market || communityType == .gathering {
            if canCompletePost {
                addSubview(completePostingStatusContentView)
                [questionLabel, completePostingStatusButton].forEach { completePostingStatusContentView.addSubview($0) }
                completePostingStatusContentView.snp.remakeConstraints {
                    $0.top.equalTo(contentsLabel.snp.bottom).offset(20.0)
                    $0.leading.trailing.equalToSuperview().inset(18.0)
                    $0.height.equalTo(129.0)
                }
                
                questionLabel.snp.remakeConstraints {
                    $0.top.leading.equalToSuperview().inset(20.0)
                }
                
                completePostingStatusButton.snp.remakeConstraints {
                    $0.leading.equalToSuperview().inset(21.0)
                    $0.bottom.equalToSuperview().inset(16.0)
                    $0.width.equalTo(137.0)
                    $0.height.equalTo(43.0)
                }
            } else if !isValid {
                addSubview(completedStatusContentView)
                completedStatusContentView.snp.remakeConstraints {
                    $0.top.equalTo(contentsLabel.snp.bottom).offset(22.0)
                    $0.leading.trailing.equalToSuperview().inset(18.0)
                    $0.height.equalTo(44.0)
                }
                
                completedStatusContentView.addSubview(completedLabel)
                completedLabel.snp.remakeConstraints { $0.center.equalToSuperview() }
            }
        }
        
        dividingView.snp.remakeConstraints {
            if communityType == .gathering || communityType == .market {
                $0.top.equalTo(canCompletePost ? completePostingStatusContentView.snp.bottom :
                                (!isValid ? completedStatusContentView.snp.bottom : contentsLabel.snp.bottom)).offset(24.0)
            } else {
                $0.top.equalTo(contentsLabel.snp.bottom).offset(24.0)
            }
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8.0)
        }
        
        commentImageView.snp.remakeConstraints {
            $0.top.equalTo(dividingView.snp.bottom).offset(14.0)
            $0.leading.equalToSuperview().inset(18.0)
            $0.bottom.equalToSuperview().inset(6.0)
            $0.width.equalTo(14.0)
            $0.height.equalTo(12.0)
        }
        
        numberOfCommentsLabel.snp.remakeConstraints {
            $0.leading.equalTo(commentImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(commentImageView)
        }
    }
}
