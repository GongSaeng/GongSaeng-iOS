//
//  ThunderDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/22.
//

import UIKit
import SnapKit

final class ThunderDetailViewController: UIViewController {
    
    // MARK: Properties
    var thunderIndex: Int
    
    private var isKeyboardShowing = false
    private var viewModel = ThunderDetailViewModel()
    private var commentList: [Comment] = [
        Comment(contents: "안녕하세요~ 저 코로나 확진인데 같이 놀아도 될까요??",
                writerImageFilename: TEST_IMAGE5_URL,
                writerNickname: "코로나확진자",
                uploadedTime: "2022-03-02 14:20:00"),
        Comment(contents: "저두 같이 놀고 싶어서 참여했어요 ~~",
                writerImageFilename: TEST_IMAGE6_URL,
                writerNickname: "자가격리자",
                uploadedTime: "2022-03-02 14:25:00"),
        Comment(contents: "안녕하세요~ 저 코로나 확진인데 같이 놀아도 될까요??",
                writerImageFilename: TEST_IMAGE5_URL,
                writerNickname: "코로나확진자",
                uploadedTime: "2022-03-02 14:20:00"),
        Comment(contents: "저두 같이 놀고 싶어서 참여했어요 ~~",
                writerImageFilename: TEST_IMAGE6_URL,
                writerNickname: "자가격리자",
                uploadedTime: "2022-03-02 14:25:00"),
        Comment(contents: "안녕하세요~ 저 코로나 확진인데 같이 놀아도 될까요??",
                writerImageFilename: TEST_IMAGE5_URL,
                writerNickname: "코로나확진자",
                uploadedTime: "2022-03-02 14:20:00"),
        Comment(contents: "저두 같이 놀고 싶어서 참여했어요 ~~",
                writerImageFilename: TEST_IMAGE6_URL,
                writerNickname: "자가격리자",
                uploadedTime: "2022-03-02 14:25:00"),
        Comment(contents: "안녕하세요~ 저 코로나 확진인데 같이 놀아도 될까요??",
                writerImageFilename: TEST_IMAGE5_URL,
                writerNickname: "코로나확진자",
                uploadedTime: "2022-03-02 14:20:00"),
        Comment(contents: "저두 같이 놀고 싶어서 참여했어요 ~~",
                writerImageFilename: TEST_IMAGE6_URL,
                writerNickname: "자가격리자",
                uploadedTime: "2022-03-02 14:25:00")
    ]
    
    private let topGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.3).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0, 1]
        let topPadding = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
            .map { $0.safeAreaInsets.top } ?? 0
        let frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topPadding + 40.0)
        gradientLayer.frame = frame
        return gradientLayer
    }()
    
    private let tableView = UITableView()
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
        let commentInputAccesoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccesoryView.delegate = self
        return commentInputAccesoryView
    }()
    
    private let navigationView = UIView()
    private let dividingView = UIView()
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .medium)
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: configuration), for: .normal)
        button.addTarget(self, action: #selector(didTapBackwardButton), for: .touchUpInside)
        return button
    }()
    
    private let remainingDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "colorPinkishOrange")
        label.isHidden = true
        return label
    }()
    
    private let spaceView = UIView()
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: Lifecycle
    init(index: Int) {
        self.thunderIndex = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        configureTableView()
        fetchThunderDetail(index: thunderIndex)
        configure()
        layout()
        navigationViewAppearanceHandler()
        navigationView.layer.addSublayer(topGradientLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tempNavigationViewController = navigationController as? TempNavigationViewController else { return }
        tempNavigationViewController.statusBarStyle = .darkContent
    }
    
    // MARK: API
    private func fetchThunderDetail(index: Int) {
        ThunderNetworkManager.fetchThunderDetail(index: index) { [weak self] thunderDetail in
            guard let self = self else { return }
            self.viewModel.thunderDetail = thunderDetail
            let headerView = ThunderDetailHeaderView(viewModel: ThunderDetailHeaderViewModel(thunderDetail: thunderDetail))
            headerView.delegate = self
            self.tableView.tableHeaderView = headerView
            self.remainingDaysLabel.text = self.viewModel.remainingDays
        }
    }
    
    // MARK: Actions
    @objc
    private func didTapBackwardButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func navigationViewAppearanceHandler() {
        guard let tempNavigationViewController = navigationController as? TempNavigationViewController else { return }
        navigationView.backgroundColor = viewModel.navigationViewColor
        dividingView.backgroundColor = viewModel.dividingViewColor
        backwardButton.tintColor = viewModel.backwardButtonColor
        remainingDaysLabel.isHidden = viewModel.isNavigationViewHidden
        if viewModel.isNavigationViewHidden {
            navigationView.layer.addSublayer(topGradientLayer)
            tempNavigationViewController.statusBarStyle = .lightContent
        } else {
            topGradientLayer.removeFromSuperlayer()
            tempNavigationViewController.statusBarStyle = .darkContent
        }
    }

    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        print("DEBUG: Before isKeyboardShowing \(isKeyboardShowing)")
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        print("DEBUG: keyboardFrame \(keyboardFrame.height)")
        if keyboardFrame.height < 200 {
            isKeyboardShowing = false
        }
        guard keyboardFrame.height > 200, !isKeyboardShowing else { return }
        let bottomPadding = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
            .map { $0.safeAreaInsets.bottom } ?? 0
        let newOffsetY = tableView.contentOffset.y + keyboardFrame.height - commentInputView.frame.height - bottomPadding
        tableView.setContentOffset(CGPoint(x: 0, y: newOffsetY), animated: true)
        isKeyboardShowing = true
        print("DEBUG: After isKeyboardShowing \(isKeyboardShowing)")
    }
    
    // MARK: Helpers
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func configureTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
    }
    
    private func configure() {
        navigationView.backgroundColor = .clear
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        backwardButton.tintColor = .white
        remainingDaysLabel.font = .systemFont(ofSize: (viewModel.remainingDays == "Today") ? 16.0: 18.0, weight: .bold)
        remainingDaysLabel.text = viewModel.remainingDays
    }
    
    private func layout() {
        [tableView, navigationView, spaceView, backwardButton]
            .forEach { view.addSubview($0) }
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        spaceView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40.0)
        }
        
        backwardButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-4.0)
            $0.leading.equalToSuperview().inset(7.0)
            $0.width.height.equalTo(44.0)
        }
        
        [dividingView, remainingDaysLabel]
            .forEach { navigationView.addSubview($0) }
        remainingDaysLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backwardButton)
        }
        
        dividingView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}

// MARK: ParticipantProfileViewControllerDelegate
extension ThunderDetailViewController: ParticipantProfileViewControllerDelegate {
    func activateShakeAnimation(index: Int) {
        guard let headerView = tableView.tableHeaderView as? ThunderDetailHeaderView else { return }
        headerView.activateShakeAnimation(index: index)
    }
    
    func removeAnimation() {
        guard let headerView = tableView.tableHeaderView as? ThunderDetailHeaderView else { return }
        headerView.removeAnimation()
    }
}

// MARK: ThunderDetailHeaderViewDelegate
extension ThunderDetailViewController: ThunderDetailHeaderViewDelegate {
    func showUserProfile(index: Int, profiles: [Profile]) {
        let viewController = ParticipantProfileViewController(index: index, profiles: profiles)
        viewController.statusBarStyle = navigationController?.preferredStatusBarStyle ?? .default
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false) {
            self.isKeyboardShowing = true
            self.spaceView.snp.updateConstraints { $0.height.equalTo(0) }
        }
    }
}

// MARK: CommentInputAccessoryViewDelegate
extension ThunderDetailViewController: CommentInputAccessoryViewDelegate {
    func transferComment(_ contents: String) {
        print("DEBUG: \(contents)")
    }
}

// MARK: UITableViewDataSource
extension ThunderDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell() }
        cell.viewModel = CommentTableViewCellViewModel(comment: commentList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: UITableViewDelegate
extension ThunderDetailViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenHeight = UIScreen.main.bounds.height
        let scrolledOffset = scrollView.contentOffset.y
        if let commentHeight = commentInputView.superview?.frame.minY,
           scrolledOffset > (screenHeight - commentHeight) {
            spaceView.snp.updateConstraints {
                $0.height.equalTo(screenHeight - commentHeight)
            }
        } else {
            spaceView.snp.updateConstraints {
                let bottomPadding = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map { $0 as? UIWindowScene }
                    .compactMap { $0 }
                    .first?.windows
                    .filter { $0.isKeyWindow }.first
                    .map { $0.safeAreaInsets.bottom } ?? 0
                $0.height.equalTo(bottomPadding + 55.0)
            }
        }
        
        guard let tableView = scrollView as? UITableView,
              let headerView = tableView.tableHeaderView as? ThunderDetailHeaderView else { return }
        let cellHeight = headerView.collectionViewHeight
        let comparisonHeight = cellHeight - navigationView.frame.maxY
        if scrolledOffset >= comparisonHeight, viewModel.isNavigationViewHidden {
            viewModel.isNavigationViewHidden = false
            navigationViewAppearanceHandler()
        } else if scrolledOffset < comparisonHeight, !viewModel.isNavigationViewHidden {
            viewModel.isNavigationViewHidden = true
            navigationViewAppearanceHandler()
        }
        
        guard scrolledOffset <= 0 else { return }
        headerView.updateImageHeight(cellHeight - scrolledOffset)
    }
}
