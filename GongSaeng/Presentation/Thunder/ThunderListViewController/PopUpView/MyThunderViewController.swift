//
//  MyThunderViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/02.
//

import UIKit
import SnapKit
import Kingfisher

protocol MyThunderViewControllerDelegate: AnyObject {
    func showDetailViewController(index: Int)
    func showTabBar()
}

final class MyThunderViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: MyThunderViewControllerDelegate?
    
    var myThunders: [ThunderDetailInfo]
    private var viewModel: MyThunderViewModel
    
    private let maxDimmedAlpha: CGFloat = 0.6
    private let defaultHeight: CGFloat = (UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }.first
        .map { $0.safeAreaInsets.bottom / 2 } ?? 0) + UIScreen.main.bounds.width * 9 / 16 + 375
    
    private let dismissibleHeight: CGFloat = (UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }.first
        .map { $0.safeAreaInsets.bottom / 2 } ?? 0) + UIScreen.main.bounds.width * 9 / 16 + 245
    
    private var currentContainerHeight: CGFloat = (UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }.first
        .map { $0.safeAreaInsets.bottom / 2 } ?? 0) + UIScreen.main.bounds.width * 9 / 16 + 345
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let holderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
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
            string: "취소하기",
            attributes: [.font: UIFont.systemFont(ofSize: 17.0, weight: .heavy),
                         .foregroundColor: UIColor.white]), for: .normal)
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = UIColor(white: 0, alpha: 0.8)
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
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .systemGray2
        return pageControl
    }()
    
    private let pageButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var previousPageButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "colorPaleOrange")
        button.addTarget(self, action: #selector(didTapPreviousPageButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextPageButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "colorPaleOrange")
        button.addTarget(self, action: #selector(didTapNextPageButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    init(myThunders: [ThunderDetailInfo]) {
        self.myThunders = myThunders
        self.viewModel = MyThunderViewModel(myThunders: myThunders)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
        setupPanGestrue()
        updateButtonState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    // MARK: Actions
    @objc
    private func openMapLink() {
        if let url = viewModel.placeURL { UIApplication.shared.open(url, options: [:]) }
    }
    
    @objc
    private func didTapPreviousPageButton() {
        viewModel.index -= 1
        pageButtonHandler()
        updateMyThunder()
    }
    
    @objc
    private func didTapNextPageButton() {
        viewModel.index += 1
        pageButtonHandler()
        updateMyThunder()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView(showDetail: Bool = false) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(-self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
        self.delegate?.showTabBar()
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false) {
                if showDetail {
                    self.delegate?.showDetailViewController(index: self.viewModel.postIndex)
                }
            }
        }
    }
    
    private func setupPanGestrue() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        holderView.addGestureRecognizer(panGesture)
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerView.snp.updateConstraints { $0.height.equalTo(height) }
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    @objc
    private func didTapCancelButton() {
        if viewModel.isOwner {
            DispatchQueue.main.async {
                self.showLoader(false)
                let popUpContents = "해당 번개의 작성자이므로 취소하실 수 없습니다."
                let viewController = PopUpViewController(buttonType: .cancel, contents: popUpContents)
                viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: false, completion: nil)
            }
        } else if !viewModel.isCanceled {
            ThunderNetworkManager.cancelThunder(index: viewModel.postIndex) { [unowned self] isSuccess in
                if isSuccess {
                    print("DEBUG: Cancel succeded")
                    viewModel.setCancel()
                    DispatchQueue.main.async {
                        self.showLoader(false)
                        let popUpContents = "취소했습니다."
                        let viewController = PopUpViewController(buttonType: .cancel, contents: popUpContents)
                        viewController.modalPresentationStyle = .overCurrentContext
                        self.present(viewController, animated: false, completion: nil)
                    }
                } else {
                    
                }
            }
        } else {
            DispatchQueue.main.async {
                self.showLoader(false)
                let popUpContents = "이미 취소한 번개 입니다."
                let viewController = PopUpViewController(buttonType: .cancel, contents: popUpContents)
                viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: false, completion: nil)
            }
        }
    }
    
    @objc
    private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < defaultHeight {
                containerView.snp.updateConstraints { $0.height.equalTo(newHeight) }
                view.layoutIfNeeded()
            }
            
        case .ended:
            if newHeight < dismissibleHeight {
                animateDismissView()
            } else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            
        default:
            break
        }
    }
    
    // MARK: Helpers
    private func pageButtonHandler() {
        updateButtonState()
        let indexPath = IndexPath(item: viewModel.index, section: 0)
        print("DEBUG: index -> \(viewModel.index) \(indexPath)")
        attachedImageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = viewModel.index
    }
    
    private func updateButtonState() {
        previousPageButton.isEnabled = viewModel.isPreviousButtonEnabled
        nextPageButton.isEnabled = viewModel.isNextButtonEnabled
    }
    
    private func updateMyThunder() {
        titleLabel.text = viewModel.title
        timeLabel.text = viewModel.meetingTime
        placeLabel.text = viewModel.placeName
        totalNumOfPeopleLabel.text = viewModel.totalNumText
        contentsLabel.text = viewModel.contents
        partcipantsImageCollectionView.reloadData()
    }
    
    private func configure() {
        view.backgroundColor = .clear
        updateMyThunder()
        pageButtonStackView.isHidden = !viewModel.shouldShowButtons
        attachedImageCollectionView.isScrollEnabled = false
    }
    
    private func layout() {
        [dimmedView, containerView, holderView].forEach { view.addSubview($0) }
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalToSuperview().inset(-defaultHeight)
        }
        
        holderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200.0)
            $0.bottom.equalTo(containerView.snp.top)
        }
        
        let holderBarView = UIView()
        holderBarView.backgroundColor = .systemGray
        holderBarView.layer.cornerRadius = 2.5
        
        holderView.addSubview(holderBarView)
        holderBarView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8.0)
            $0.width.equalTo(40.0)
            $0.height.equalTo(5.0)
        }
        
        let horizontalDividingView = UIView()
        horizontalDividingView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        
        [previousPageButton, nextPageButton].forEach { pageButtonStackView.addArrangedSubview($0) }
        
        [attachedImageCollectionView, titleLabel, horizontalDividingView,
         timeIconImageView, timeLabel, placeIconImageView, placeLabel,
         openMapButton, peopleIconImageView, totalNumOfPeopleLabel,
         contentsLabel, partcipantsImageCollectionView, joinButton,
         pageControl]
            .forEach { containerView.addSubview($0) }
        
        attachedImageCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            let screenWidth: CGFloat = UIScreen.main.bounds.width
            $0.height.equalTo(screenWidth * 9.0 / 16.0)
        }
        
        if viewModel.shouldShowButtons {
            containerView.addSubview(pageButtonStackView)
            pageButtonStackView.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel)
                $0.trailing.equalToSuperview()
                $0.width.equalTo(88.0)
                $0.height.equalTo(44.0)
            }
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(attachedImageCollectionView.snp.bottom).offset(15.0)
            $0.leading.equalToSuperview().inset(18.0)
            if viewModel.shouldShowButtons {
                $0.trailing.lessThanOrEqualTo(pageButtonStackView.snp.leading)
            } else {
                $0.trailing.lessThanOrEqualToSuperview().inset(18.0)
            }
        }        
        
        horizontalDividingView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13.0)
            $0.leading.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(1.0)
        }
        
        timeIconImageView.snp.makeConstraints {
            $0.top.equalTo(horizontalDividingView.snp.bottom).offset(12.0)
            $0.leading.equalToSuperview().inset(18.0)
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
            $0.top.equalTo(contentsLabel.snp.bottom).offset(25.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60.0)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(partcipantsImageCollectionView.snp.bottom).offset(25.0)
            $0.leading.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(50.0)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(joinButton.snp.bottom).offset(15.0)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: UICollectionViewDataSource
extension MyThunderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case attachedImageCollectionView:
            return viewModel.numOfMyThunder
            
        case partcipantsImageCollectionView:
            print("DEBUG: viewModel.numOfParticipants \(viewModel.numOfParticipants)")
            return viewModel.numOfParticipants
            
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case attachedImageCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachedImageCell", for: indexPath) as? AttachedImageCell else { return AttachedImageCell() }
            cell.imageURL = viewModel.postingImageURLs[indexPath.item]
            return cell
            
        case partcipantsImageCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantImageCell", for: indexPath) as? ParticipantImageCell else { return ParticipantImageCell() }
            if indexPath.item < viewModel.numOfParticipants {
                cell.imageURL = viewModel.participantsImageURL[indexPath.item]
            } else {
                cell.configureVacancy()
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: UICollectionViewDelegate
extension MyThunderViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        viewModel.index = page
        updateMyThunder()
        print("DEBUG: Current index \(viewModel.index)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == attachedImageCollectionView {
            animateDismissView(showDetail: true)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MyThunderViewController: UICollectionViewDelegateFlowLayout {
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
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case attachedImageCollectionView:
            return .zero
            
        case partcipantsImageCollectionView:
            return UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
            
        default:
            return .zero
        }
    }
}
