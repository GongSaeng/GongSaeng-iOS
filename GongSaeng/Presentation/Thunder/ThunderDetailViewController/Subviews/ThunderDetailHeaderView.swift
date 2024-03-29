//
//  ThunderDetailHeaderView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/22.
//

import UIKit
import SnapKit
import Kingfisher

protocol ThunderDetailHeaderViewDelegate: AnyObject {
    func showFullImages(imageUrlList: [URL], page: Int)
    func showUserProfile(index: Int, profiles: [Profile])
    func refresh()
}

final class ThunderDetailHeaderView: UIView {
    
    // MARK: Properties
    weak var delegate: ThunderDetailHeaderViewDelegate?
    
    var collectionViewHeight: CGFloat {
        return attachedImageCollectionView.frame.height
    }
    
    private var viewModel: ThunderDetailHeaderViewModel
    
    private lazy var attachedImageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.masksToBounds = false
        collectionView.bounces = false
        collectionView.register(AttachedImageCell.self, forCellWithReuseIdentifier: "AttachedImageCell")
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = viewModel.attachedImageURLs.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let writerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let writerNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .semibold)
        label.textColor = UIColor(white: 0, alpha: 0.87)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let uploadedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10.0)
        label.textColor = .systemGray
        label.numberOfLines = 1
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
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.numberOfLines = 1
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
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var openMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(
            NSAttributedString(
                string: "지도보기",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12.0, weight: .semibold),
                    .foregroundColor: UIColor(named: "colorPaleOrange")!]),
            for: .normal)
        button.addTarget(self, action: #selector(openMapLink), for: .touchUpInside)
        return button
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
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var partcipantsImageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.masksToBounds = false
        collectionView.register(ParticipantImageCell.self, forCellWithReuseIdentifier: "ParticipantImageCell")
        return collectionView
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "colorPaleOrange")
        button.setAttributedTitle(NSAttributedString(
            string: "참여하기",
            attributes: [.font: UIFont.systemFont(ofSize: 17.0, weight: .heavy),
                         .foregroundColor: UIColor.white]), for: .normal)
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(didTapJoinButton), for: .touchUpInside)
        return button
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
    
    private let bottomGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.15).cgColor]
        gradientLayer.locations = [0, 1]
        let frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35.0)
        gradientLayer.frame = frame
        return gradientLayer
    }()
    
    // MARK: Lifecycle
    init(viewModel: ThunderDetailHeaderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func didTapJoinButton() {
        switch viewModel.joinStatus {
        case .canJoin:
            ThunderNetworkManager.joinThunder(index: viewModel.idx) { [unowned self] isSuccess in
                if isSuccess {
                    print("DEBUG: Join succeded")
                    self.delegate?.refresh()
                } else {
                    
                }
            }
        case .canCancel:
            ThunderNetworkManager.cancelThunder(index: viewModel.idx) { [unowned self] isSuccess in
                if isSuccess {
                    print("DEBUG: Cancel succeded")
                    self.delegate?.refresh()
                } else {
                    
                }
            }
        case .owner:
            break
        }
    }
    
    @objc
    private func openMapLink() {
        if let url = viewModel.placeURL { UIApplication.shared.open(url, options: [:]) }
    }
    
    // MARK: Animations
    func activateShakeAnimation(index: Int) {
        partcipantsImageCollectionView.visibleCells.forEach { $0.layer.removeAllAnimations() }
        guard let cell = partcipantsImageCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ParticipantImageCell else { return }
        cell.addShakeAnimation()
    }
    
    func removeAnimation() {
        partcipantsImageCollectionView.visibleCells.forEach { $0.layer.removeAllAnimations() }
    }
    
    // MARK: Helpers
    func updateImageHeight(_ height: CGFloat) {
        guard let cell = attachedImageCollectionView.visibleCells.first as? AttachedImageCell else { return }
        cell.updateImageHeight(height)
    }
    
    func updateNumberOfComments(_ num: Int) {
        numberOfCommentsLabel.text = "댓글 \(num)"
    }
    
    private func configure() {
        self.backgroundColor = .white
        titleLabel.text = viewModel.title
        writerImageView.kf.setImage(with: viewModel.writerImageURL)
        writerNicknameLabel.text = viewModel.writerNickname
        uploadedTimeLabel.text = viewModel.uploadedTime
        timeLabel.text = viewModel.meetingTime
        placeLabel.text = viewModel.placeName
        totalNumOfPeopleLabel.text = viewModel.totalNumText
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.0
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.alignment = .justified
        contentsLabel.attributedText = NSAttributedString(string: viewModel.contents, attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor(white: 0, alpha: 0.8), .paragraphStyle: paragraphStyle])
        
        numberOfCommentsLabel.text = viewModel.numOfCommentsText
        
        switch viewModel.joinStatus {
        case .canJoin:
            joinButton.setAttributedTitle(NSAttributedString(
                string: "참여하기",
                attributes: [.font: UIFont.systemFont(ofSize: 17.0, weight: .heavy),
                             .foregroundColor: UIColor.white]), for: .normal)
        case .canCancel:
            joinButton.setAttributedTitle(NSAttributedString(
                string: "취소하기",
                attributes: [.font: UIFont.systemFont(ofSize: 17.0, weight: .heavy),
                             .foregroundColor: UIColor.white]), for: .normal)
        case .owner:
            break
        }
    }
    
    private func layout() {
        self.snp.makeConstraints { $0.width.equalTo(UIScreen.main.bounds.width) }
        let verticalDividingView = UIView()
        let horizontalDividingView1 = UIView()
        let horizontalDividingView2 = UIView()
        [verticalDividingView, horizontalDividingView1, horizontalDividingView2]
            .forEach { $0.backgroundColor = UIColor(white: 0, alpha: 0.05) }
        
        let bottomDarkView = UIView()
        bottomDarkView.layer.addSublayer(bottomGradientLayer)
        [attachedImageCollectionView, bottomDarkView, pageControl, titleLabel,
         writerImageView, writerNicknameLabel, verticalDividingView,
         uploadedTimeLabel, horizontalDividingView1, timeIconImageView,
         timeLabel, placeIconImageView, peopleIconImageView,
         totalNumOfPeopleLabel, contentsLabel, placeLabel, openMapButton,
         partcipantsImageCollectionView, joinButton, horizontalDividingView2,
        commentImageView, numberOfCommentsLabel]
            .forEach { addSubview($0) }
        
        attachedImageCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 9.0 / 16.0 + topPadding)
        }
        
        bottomDarkView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(attachedImageCollectionView)
            $0.height.equalTo(bottomGradientLayer.frame.height)
        }

        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(attachedImageCollectionView).offset(-4.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(attachedImageCollectionView.snp.bottom).offset(15.0)
            $0.leading.equalToSuperview().inset(18.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        writerImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(titleLabel)
            $0.width.height.equalTo(20.0)
        }

        writerNicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(writerImageView.snp.trailing).offset(5.0)
            $0.centerY.equalTo(writerImageView)
        }
        writerNicknameLabel.snp.contentCompressionResistanceHorizontalPriority = 749

        verticalDividingView.snp.makeConstraints {
            $0.leading.equalTo(writerNicknameLabel.snp.trailing).offset(5.0)
            $0.centerY.equalTo(writerNicknameLabel)
            $0.width.equalTo(1.0)
            $0.height.equalTo(10.0)
        }

        uploadedTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(verticalDividingView.snp.trailing).offset(5.0)
            $0.centerY.equalTo(verticalDividingView)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        horizontalDividingView1.snp.makeConstraints {
            $0.top.equalTo(writerImageView.snp.bottom).offset(14.0)
            $0.leading.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
        }
        
        timeIconImageView.snp.makeConstraints {
            $0.top.equalTo(writerImageView.snp.bottom).offset(30.0)
            $0.leading.equalTo(writerImageView)
            $0.width.equalTo(14.0)
            $0.height.equalTo(15.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeIconImageView.snp.trailing).offset(9.0)
            $0.centerY.equalTo(timeIconImageView)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(7.0)
            $0.leading.equalTo(timeLabel)
        }
        
        placeLabel.snp.contentCompressionResistanceHorizontalPriority = 749
        
        openMapButton.snp.makeConstraints {
            $0.centerY.equalTo(placeLabel)
            $0.leading.equalTo(placeLabel.snp.trailing).offset(10.0)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.width.height.equalTo(44.0)
        }
        
        placeIconImageView.snp.makeConstraints {
            $0.centerX.equalTo(timeIconImageView)
            $0.centerY.equalTo(placeLabel)
            $0.width.equalTo(14.0)
            $0.height.equalTo(15.0)
        }
        
        totalNumOfPeopleLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(7.0)
            $0.leading.equalTo(placeLabel)
        }
        
        peopleIconImageView.snp.makeConstraints {
            $0.centerX.equalTo(placeIconImageView)
            $0.centerY.equalTo(totalNumOfPeopleLabel)
            $0.width.equalTo(16.0)
            $0.height.equalTo(16.0)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(peopleIconImageView.snp.bottom).offset(14.0)
            $0.leading.equalToSuperview().inset(18.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
        }
        
        partcipantsImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(40.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60.0)
        }
        
        
        switch viewModel.joinStatus {
        case .canJoin, .canCancel:
            joinButton.snp.makeConstraints {
                $0.top.equalTo(partcipantsImageCollectionView.snp.bottom).offset(30.0)
                $0.leading.trailing.equalToSuperview().inset(18.0)
                $0.height.equalTo(50.0)
            }
            
            horizontalDividingView2.snp.makeConstraints {
                $0.top.equalTo(joinButton.snp.bottom).offset(30.0)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(8.0)
            }
        case .owner:
            joinButton.removeFromSuperview()
            horizontalDividingView2.snp.makeConstraints {
                $0.top.equalTo(partcipantsImageCollectionView.snp.bottom).offset(30.0)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(8.0)
            }
        }
        
        commentImageView.snp.makeConstraints {
            $0.top.equalTo(horizontalDividingView2.snp.bottom).offset(14.0)
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

// MARK: UICollectionViewDataSource
extension ThunderDetailHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case attachedImageCollectionView:
            return viewModel.attachedImageURLs.count
            
        case partcipantsImageCollectionView:
            return viewModel.participantsProfile.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case attachedImageCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachedImageCell", for: indexPath) as? AttachedImageCell else { return AttachedImageCell() }
            cell.imageURL = viewModel.attachedImageURLs[indexPath.item]
            return cell
            
        case partcipantsImageCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantImageCell", for: indexPath) as? ParticipantImageCell else { return ParticipantImageCell() }
            if indexPath.item < viewModel.participantImageURLs.count {
                cell.imageURL = viewModel.participantImageURLs[indexPath.item]
            } else {
                cell.configureVacancy()
            }
            if indexPath.item == 0 { cell.configureHost() }
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
        
    }
}

// MARK: UICollectionViewDelegate
extension ThunderDetailHeaderView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == attachedImageCollectionView {
            let page = Int(targetContentOffset.pointee.x / frame.width)
            pageControl.currentPage = page
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case attachedImageCollectionView:
            print("DEBUG: Did tap image..")
            delegate?.showFullImages(imageUrlList: viewModel.attachedImageURLs
                                                        .filter { $0 != nil }
                                                        .map { $0! },
                                     page: indexPath.item + 1)
            
        case partcipantsImageCollectionView:
            guard indexPath.item < viewModel.participantImageURLs.count else { return }
            delegate?.showUserProfile(index: indexPath.row, profiles: viewModel.participantsProfile)
            
        default:
            return
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == partcipantsImageCollectionView {
            partcipantsImageCollectionView.visibleCells.forEach { $0.layer.removeAllAnimations() }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ThunderDetailHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case attachedImageCollectionView:
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = collectionView.frame.height
            return CGSize(width: width, height: height)
            
        case partcipantsImageCollectionView:
            let width: CGFloat = 60.0
            return CGSize(width: width, height: width)
            
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case attachedImageCollectionView:
            return 0
            
        case partcipantsImageCollectionView:
            return 15.0
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case attachedImageCollectionView:
            return UIEdgeInsets.zero
            
        case partcipantsImageCollectionView:
            return UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
            
        default:
            return UIEdgeInsets.zero
        }
        
    }
}
