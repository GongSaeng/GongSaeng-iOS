//
//  ParticipantProfileViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/01.
//

import UIKit
import SnapKit
import Kingfisher

protocol ParticipantProfileViewControllerDelegate: AnyObject {
    func activateShakeAnimation(index: Int)
    func removeAnimation()
}

final class ParticipantProfileViewController: UIViewController {
    
    // MARK: Properties
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    
    weak var delegate: ParticipantProfileViewControllerDelegate?
    
    var index: Int
    var profiles: [Profile]
    private var viewModel: ParticipantProfileViewModel
    
    private let maxDimmedAlpha: CGFloat = 0.6
    private let defaultHeight: CGFloat = 420
    private let dismissibleHeight: CGFloat = 320
    private var currentContainerHeight: CGFloat = 420
    
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
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ProfileImageCell")
        collectionView.layer.cornerRadius = 60.0
        return collectionView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return label
    }()
    
    private let jobImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bagIcon")
        return imageView
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .systemGray
        return label
    }()
    
    private let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "profileGroupIcon")
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .systemGray
        return label
    }()
    
    private let introduceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageBackwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(named: "colorPinkishOrange")
        button.addTarget(self, action: #selector(DidTapImageBackwardButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = UIColor(named: "colorPinkishOrange")
        button.addTarget(self, action: #selector(DidTapImageForwardButton), for: .touchUpInside)
        return button
    }()
    
    private let holderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    // MARK: Lifecycle
    init(index: Int, profiles: [Profile]) {
        self.index = index
        self.profiles = profiles
        self.viewModel = ParticipantProfileViewModel(index: index, profiles: profiles)
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
        collectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .centeredHorizontally, animated: false)
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
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(-self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.delegate?.removeAnimation()
            self.dismiss(animated: false)
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
    
    // MARK: Actions
    @objc
    private func DidTapImageBackwardButton() {
        
        if (viewModel.index - 1) == 0 {
            viewModel.index =  viewModel.profileList.count - 2
            collectionView.scrollToItem(at: IndexPath(item: viewModel.index + 1, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            viewModel.index -= 1
        }
        collectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .centeredHorizontally, animated: true)
        configureProfile()
    }
    
    @objc
    private func DidTapImageForwardButton() {
        
        if (viewModel.index + 1) == viewModel.profileList.count - 1 {
            viewModel.index =  1
            collectionView.scrollToItem(at: IndexPath(item: viewModel.index - 1, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            viewModel.index += 1
        }
        collectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .centeredHorizontally, animated: true)
        configureProfile()
    }
    
    // MARK: Helpers
    private func configureProfile() {
        nicknameLabel.text = viewModel.nickname
        jobLabel.text = viewModel.job
        emailLabel.text = viewModel.email
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.0
        paragraphStyle.alignment = .center
        introduceLabel.attributedText = NSAttributedString(
            string: viewModel.introduce,
            attributes: [.font: UIFont.systemFont(ofSize: 13.0),
                         .foregroundColor: UIColor.systemGray,
                         .paragraphStyle: paragraphStyle])
        if viewModel.imageURLs.count == 1 {
            [imageBackwardButton, imageForwardButton].forEach {
                $0.isHidden = true
            }
        }
        delegate?.activateShakeAnimation(index: viewModel.index - 1)
    }
    
    private func configure() {
        view.backgroundColor = .clear
        configureProfile()
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
        
        let stackView1 = UIStackView(arrangedSubviews: [jobImageView, jobLabel])
        let stackView2 = UIStackView(arrangedSubviews: [emailImageView, emailLabel])
        [stackView1, stackView2].forEach {
            $0.axis = .horizontal
            $0.spacing = 7.0
            $0.distribution = .equalCentering
        }
        
        jobImageView.snp.makeConstraints {
            $0.width.height.equalTo(16.0)
        }
        
        emailImageView.snp.makeConstraints {
            $0.width.height.equalTo(16.0)
        }
        
        [collectionView, nicknameLabel, stackView1, stackView2,
         introduceLabel, imageBackwardButton, imageForwardButton]
            .forEach { containerView.addSubview($0) }
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(120.0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24.0)
            $0.centerX.equalToSuperview()
        }
        
        stackView1.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(26.0)
            $0.centerX.equalToSuperview()
        }
        
        stackView2.snp.makeConstraints {
            $0.top.equalTo(stackView1.snp.bottom).offset(15.0)
            $0.centerX.equalToSuperview()
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(stackView2.snp.bottom).offset(15.0)
            $0.centerX.equalToSuperview()
            $0.leading.lessThanOrEqualToSuperview().inset(45.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(45.0)
        }
        
        imageBackwardButton.snp.makeConstraints {
            $0.centerX.equalTo(collectionView.snp.leading).offset(-10.0)
            $0.centerY.equalTo(collectionView)
            $0.width.height.equalTo(70.0)
        }
        
        imageForwardButton.snp.makeConstraints {
            $0.centerX.equalTo(collectionView.snp.trailing).offset(10.0)
            $0.centerY.equalTo(collectionView)
            $0.width.height.equalTo(70.0)
        }
    }
}

// MARK: UICollectionViewDataSource
extension ParticipantProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath)
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = collectionView.frame.height / 2
            imageView.layer.borderWidth = 1.0
            imageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
            return imageView
        }()
        cell.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(collectionView.frame.height)
        }
        if let imageURL = viewModel.imageURLs[indexPath.row] {
            profileImageView.kf.setImage(with: imageURL)
        } else {
            profileImageView.image = UIImage(named: "3")
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ParticipantProfileViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if page == 0 {
            viewModel.index = viewModel.profileList.count - 2
            collectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .centeredHorizontally, animated: false)
        } else if page == viewModel.profileList.count - 1 {
            viewModel.index = 1
            collectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            viewModel.index = page
        }
        configureProfile()
        print("DEBUG: Current index \(viewModel.index)")
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ParticipantProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
