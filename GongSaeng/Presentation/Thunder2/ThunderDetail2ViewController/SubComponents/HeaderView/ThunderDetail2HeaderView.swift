////
////  ThunderDetail2HeaderView.swift
////  GongSaeng
////
////  Created by 정동천 on 2022/03/30.
////
//
//import UIKit
//import SnapKit
//import Kingfisher
//import RxSwift
//import RxCocoa
//
//final class ThunderDetail2HeaderView: UIView {
//
//    // MARK: Properties
//    private let disposeBag = DisposeBag()
//    
//    private let attachedImageCollectionView: AttachedImageCollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        let collectionView = AttachedImageCollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        return collectionView
//    }()
//    private let participantsImageCollectionView:  ParticipantsImageCollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        let collectionView = ParticipantsImageCollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        return collectionView
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
//        label.textColor = .black
//        label.numberOfLines = 0
//        label.lineBreakMode = .byCharWrapping
//        return label
//    }()
//
//    private let writerImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.borderWidth = 1.0
//        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
//        imageView.layer.cornerRadius = 10.0
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//
//    private let writerNicknameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 12.0, weight: .semibold)
//        label.textColor = UIColor(white: 0, alpha: 0.87)
//        label.numberOfLines = 1
//        label.lineBreakMode = .byTruncatingTail
//        return label
//    }()
//
//    private let uploadedTimeLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 10.0)
//        label.textColor = .systemGray
//        label.numberOfLines = 1
//        return label
//    }()
//
//    private let timeIconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = UIColor(white: 0, alpha: 0.6)
//        return imageView
//    }()
//
//    private let timeLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14.0, weight: .medium)
//        label.lineBreakMode = .byTruncatingTail
//        label.textColor = .black
//        label.numberOfLines = 1
//        return label
//    }()
//
//    private let placeIconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = UIColor(white: 0, alpha: 0.6)
//        return imageView
//    }()
//
//    private lazy var placeLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14.0, weight: .medium)
//        label.lineBreakMode = .byTruncatingTail
//        label.textColor = .black
//        label.numberOfLines = 1
//        return label
//    }()
//
//    private lazy var openMapButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setAttributedTitle(
//            NSAttributedString(
//                string: "지도보기",
//                attributes: [
//                    .font: UIFont.systemFont(ofSize: 12.0, weight: .semibold),
//                    .foregroundColor: UIColor(named: "colorPaleOrange")!]),
//            for: .normal)
//        return button
//    }()
//
//    private let peopleIconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(systemName: "person.3")
//        imageView.tintColor = UIColor(white: 0, alpha: 0.6)
//        return imageView
//    }()
//
//    private let totalNumOfPeopleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14.0, weight: .medium)
//        label.lineBreakMode = .byTruncatingTail
//        label.textColor = .black
//        label.numberOfLines = 1
//        return label
//    }()
//
//    private let contentsLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private lazy var joinButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor(named: "colorPaleOrange")
//        button.setAttributedTitle(NSAttributedString(
//            string: "참여하기",
//            attributes: [.font: UIFont.systemFont(ofSize: 17.0, weight: .heavy),
//                         .foregroundColor: UIColor.white]), for: .normal)
//        button.layer.cornerRadius = 8.0
//        return button
//    }()
//
//    private let commentImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "message")
//        imageView.contentMode = .scaleToFill
//        return imageView
//    }()
//
//    private let numberOfCommentsLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14.0)
//        label.textColor = UIColor(white: 0, alpha: 0.8)
//        return label
//    }()
//
//    // MARK: Lifecycle
//    init() {
//        super.init(frame: .zero)
//
//        attribute()
//        layout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: Helpers
//    private func attribute() {
//        backgroundColor = .white
//
//        attachedImageCollectionView.backgroundColor = .red
//    }
//
//    private func layout() {
//        self.snp.makeConstraints { $0.width.equalTo(UIScreen.main.bounds.width) }
//
//        let verticalDividingView = UIView()
//        let horizontalDividingView1 = UIView()
//        let horizontalDividingView2 = UIView()
//        [verticalDividingView, horizontalDividingView1, horizontalDividingView2]
//            .forEach { $0.backgroundColor = UIColor(white: 0, alpha: 0.05) }
//
//        [attachedImageCollectionView, titleLabel, writerImageView,
//         writerNicknameLabel, verticalDividingView, uploadedTimeLabel,
//         horizontalDividingView1, timeIconImageView, timeLabel,
//         placeIconImageView, peopleIconImageView, totalNumOfPeopleLabel,
//         contentsLabel, placeLabel, openMapButton, participantsImageCollectionView,
//         joinButton, horizontalDividingView2, commentImageView, numberOfCommentsLabel
//        ].forEach { addSubview($0) }
//
//        attachedImageCollectionView.snp.makeConstraints {
//            $0.top.leading.trailing.equalToSuperview()
//            $0.height.equalTo(UIScreen.main.bounds.width * 9.0 / 16.0 + topPadding)
//        }
//
//        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(attachedImageCollectionView.snp.bottom).offset(15.0)
//            $0.leading.equalToSuperview().inset(18.0)
//            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
//        }
//
//        writerImageView.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
//            $0.leading.equalTo(titleLabel)
//            $0.width.height.equalTo(20.0)
//        }
//
//        writerNicknameLabel.snp.makeConstraints {
//            $0.leading.equalTo(writerImageView.snp.trailing).offset(5.0)
//            $0.centerY.equalTo(writerImageView)
//        }
//        writerNicknameLabel.snp.contentCompressionResistanceHorizontalPriority = 749
//
//        verticalDividingView.snp.makeConstraints {
//            $0.leading.equalTo(writerNicknameLabel.snp.trailing).offset(5.0)
//            $0.centerY.equalTo(writerNicknameLabel)
//            $0.width.equalTo(1.0)
//            $0.height.equalTo(10.0)
//        }
//
//        uploadedTimeLabel.snp.makeConstraints {
//            $0.leading.equalTo(verticalDividingView.snp.trailing).offset(5.0)
//            $0.centerY.equalTo(verticalDividingView)
//            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
//        }
//
//        horizontalDividingView1.snp.makeConstraints {
//            $0.top.equalTo(writerImageView.snp.bottom).offset(14.0)
//            $0.leading.trailing.equalToSuperview().inset(18.0)
//            $0.height.equalTo(1.0)
//        }
//
//        timeIconImageView.snp.makeConstraints {
//            $0.top.equalTo(writerImageView.snp.bottom).offset(30.0)
//            $0.leading.equalTo(writerImageView)
//            $0.width.equalTo(14.0)
//            $0.height.equalTo(15.0)
//        }
//
//        timeLabel.snp.makeConstraints {
//            $0.leading.equalTo(timeIconImageView.snp.trailing).offset(9.0)
//            $0.centerY.equalTo(timeIconImageView)
//            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
//        }
//
//        placeLabel.snp.makeConstraints {
//            $0.top.equalTo(timeLabel.snp.bottom).offset(7.0)
//            $0.leading.equalTo(timeLabel)
//        }
//
//        placeLabel.snp.contentCompressionResistanceHorizontalPriority = 749
//
//        openMapButton.snp.makeConstraints {
//            $0.centerY.equalTo(placeLabel)
//            $0.leading.equalTo(placeLabel.snp.trailing).offset(10.0)
//            $0.trailing.equalToSuperview().inset(18.0)
//            $0.width.height.equalTo(44.0)
//        }
//
//        placeIconImageView.snp.makeConstraints {
//            $0.centerX.equalTo(timeIconImageView)
//            $0.centerY.equalTo(placeLabel)
//            $0.width.equalTo(14.0)
//            $0.height.equalTo(15.0)
//        }
//
//        totalNumOfPeopleLabel.snp.makeConstraints {
//            $0.top.equalTo(placeLabel.snp.bottom).offset(7.0)
//            $0.leading.equalTo(placeLabel)
//        }
//
//        peopleIconImageView.snp.makeConstraints {
//            $0.centerX.equalTo(placeIconImageView)
//            $0.centerY.equalTo(totalNumOfPeopleLabel)
//            $0.width.equalTo(16.0)
//            $0.height.equalTo(16.0)
//        }
//
//        contentsLabel.snp.makeConstraints {
//            $0.top.equalTo(peopleIconImageView.snp.bottom).offset(14.0)
//            $0.leading.equalToSuperview().inset(18.0)
//            $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
//        }
//
//        participantsImageCollectionView.snp.makeConstraints {
//            $0.top.equalTo(contentsLabel.snp.bottom).offset(40.0)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(60.0)
//        }
//
//        joinButton.snp.makeConstraints {
//            $0.top.equalTo(participantsImageCollectionView.snp.bottom).offset(30.0)
//            $0.leading.trailing.equalToSuperview().inset(18.0)
//            $0.height.equalTo(50.0)
//        }
//
//        horizontalDividingView2.snp.makeConstraints {
//            $0.top.equalTo(joinButton.snp.bottom).offset(30.0)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(8.0)
//        }
//
//        commentImageView.snp.makeConstraints {
//            $0.top.equalTo(horizontalDividingView2.snp.bottom).offset(14.0)
//            $0.leading.equalToSuperview().inset(18.0)
//            $0.bottom.equalToSuperview().inset(6.0)
//            $0.width.equalTo(14.0)
//            $0.height.equalTo(12.0)
//        }
//
//        numberOfCommentsLabel.snp.remakeConstraints {
//            $0.leading.equalTo(commentImageView.snp.trailing).offset(8.0)
//            $0.centerY.equalTo(commentImageView)
//        }
//    }
//}
//
//extension ThunderDetail2HeaderView {
//    func bind(_ viewModel: ThunderDetail2HeaderViewModel) {
//        viewModel.title
//            .drive(titleLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.writerImageURL
//            .drive { [weak self] url in
//                self?.writerImageView.kf.setImage(with: url)
//            }
//            .disposed(by: disposeBag)
//
//        viewModel.writerNickname
//            .drive(writerNicknameLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.uploadedTime
//            .drive(uploadedTimeLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.meetingTime
//            .drive(timeLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.placeName
//            .drive(placeLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.totalNumText
//            .drive(totalNumOfPeopleLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.contents
//            .drive { [weak self] contents in
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 2.0
//                paragraphStyle.lineBreakMode = .byCharWrapping
//                paragraphStyle.alignment = .justified
//                self?.contentsLabel.attributedText = NSAttributedString(string: contents, attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor(white: 0, alpha: 0.8), .paragraphStyle: paragraphStyle])
//            }
//            .disposed(by: disposeBag)
//
//        viewModel.numOfCommentsText
//            .drive(numberOfCommentsLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        openMapButton.rx.tap
//            .bind(to: viewModel.openMapButtonTapped)
//            .disposed(by: disposeBag)
//
//        viewModel.openMap
//            .drive { url in
//                if let url = url { UIApplication.shared.open(url, options: [:]) }
//            }
//            .disposed(by: disposeBag)
//    }
//}
