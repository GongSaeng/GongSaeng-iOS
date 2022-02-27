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
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return statusBarStyle
//    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        configureTableView()
        configure()
        layout()
        navigationViewAppearanceHandler()
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
    
    // MARK: Actions
    @objc
    private func didTapBackwardButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func navigationViewAppearanceHandler() {
        navigationView.backgroundColor = viewModel.navigationViewColor
        dividingView.backgroundColor = viewModel.dividingViewColor
        backwardButton.tintColor = viewModel.backwardButtonColor
//        statusBarStyle = viewModel.isNavigationViewHidden ? .darkContent : .lightContent
//        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Actions
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        print("DEBUG: keyboardWillShow")
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        print("DEBUG: keyboardHeight -> \(keyboardFrame.height)")
//        spaceView.snp.updateConstraints { $0.height.equalTo(keyboardFrame.height) }
        guard keyboardFrame.height > 150 else {
            isKeyboardShowing = false
            return
        }
        guard keyboardFrame.height > 300, !isKeyboardShowing else { return }
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
    }
    
    // MARK: Helpers
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func configureTableView() {
        let thunderDetail = ThunderDetail(postingImagesFilename: [TEST_IMAGE2_URL, TEST_IMAGE3_URL, TEST_IMAGE1_URL],
                                          title: "같이 코노가요 가나다라마바사아자차카타파하 글자길이 테스트 2줄은 어떻게 보이나 3줄은 어떻게 보이려나",
                                          writerImageFilename: TEST_IMAGE4_URL,
                                          writerId: "",
                                          writerNickname: "네잎클로버",
                                          uploadedTime: "2022-03-02 13:35:31",
                                          meetingTime: "2022-03-02 19:00:00",
                                          placeName: "레드노래연습장 부산대점",
                                          address: "부산 금정구 금강로 271",
                                          placeURL: "http://place.map.kakao.com/12421917",
                                          totalNum: 6,
                                          contents: "저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~",
                                          participantImageURLs: [TEST_IMAGE4_URL, TEST_IMAGE5_URL, TEST_IMAGE6_URL],
                                          participantIDs: ["jdc0407", "123", "1234"],
                                          status: 0,
                                          numberOfComments: 15)
        let headerView = ThunderDetailHeaderView(viewModel: ThunderDetailHeaderViewModel(thunderDetail: thunderDetail))
        headerView.delegate = self
        tableView.tableHeaderView = headerView
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
        remainingDaysLabel.font = .systemFont(ofSize: (viewModel.remainingDays == "Today") ? 16.0: 18.0, weight: .heavy)
        remainingDaysLabel.text = viewModel.remainingDays
    }
    
    private func layout() {
        [tableView, navigationView, spaceView]
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
        
        [backwardButton, dividingView, remainingDaysLabel]
            .forEach { navigationView.addSubview($0) }
        backwardButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-4.0)
            $0.leading.equalToSuperview().inset(7.0)
            $0.width.height.equalTo(44.0)
        }
        
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

extension ThunderDetailViewController: ThunderDetailHeaderViewDelegate {
    func showUserProfile(id: String) {
        print("DEBUG: id \(id)")
//        commentInputView.isHidden = !commentInputView.isHidden
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
