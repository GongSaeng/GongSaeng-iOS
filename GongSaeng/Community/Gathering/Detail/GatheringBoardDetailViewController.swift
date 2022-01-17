//
//  GatheringBoardDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit

class GatheringBoardDetailViewController: UITableViewController {
    
    // MARK: Propeties
    private var post: Post
    private let communityType: CommunityType
    private let userID: String
    private var gatheringStatus: Int
    private var postIndex: Int
    
    private var currentIndex: CGFloat = 0
    private var currentPage = 1
    private var fetchedPageList = [Int]()
    private var isKeyboardShowing = false
    private var commentList = [Comment]()
    
    private let collectionReuseIdentifier = "GatheringImageCell"
    private let tableReuserIdetifier = "CommentTableViewCell"
    private let headerView = GatheringBoardDetailHeaderView()
    private var postingImages: [UIImage] { return headerView.viewModel?.postingImages ?? [] }
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100.0)
        let commentInputAccesoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccesoryView.delegate = self
        return commentInputAccesoryView
    }()
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: Lifecycle
    init(withUser user: User, post: Post, gatheringStatus: Int, postIndex: Int, communityType: CommunityType) {
        self.userID = user.id
        self.post = post
        self.gatheringStatus = gatheringStatus
        self.postIndex = postIndex
        self.communityType = communityType
        
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureNavigationBar()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchComments(of: currentPage)
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
    
    // MARK: API
    private func fetchPost(postIndex index: Int) {
        CommunityNetworkManager.fetchPost(index: index) { [weak self] post in
            print("DEBUG: fetch succeded ->", post)
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.headerView.viewModel = GatheringBoardDetialHeaderViewModel(post: post, userID: self.userID, gatheringStatus: self.gatheringStatus)
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchComments(of page: Int, shouldRefresh: Bool = false) {
        guard fetchedPageList.firstIndex(of: currentPage) == nil else { return }
        fetchedPageList.append(page)
        CommunityNetworkManager.fetchComments(page: page, index: postIndex) { [weak self] comments in
            guard let self = self else { return }
            if shouldRefresh {
                self.commentList = comments
            } else {
                self.commentList += comments
            }
            self.currentPage += 1
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Actions
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        print("DEBUG: keyboardWillShow")
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func configure() {
        headerView.delegate = self
        headerView.viewModel = GatheringBoardDetialHeaderViewModel(post: post, userID: userID, gatheringStatus: gatheringStatus)
        tableView.tableHeaderView = headerView
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: tableReuserIdetifier)
        headerView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionReuseIdentifier)
        headerView.collectionView.dataSource = self
        headerView.collectionView.delegate = self
        tableView.prefetchDataSource = self
    }
    
    private func configureNavigationBar() {
        switch communityType {
        case .free:
            navigationItem.title = "자유게시판"
        case .emergency:
            navigationItem.title = "긴급게시판"
        case .suggestion:
            navigationItem.title = "건의게시판"
        case .gathering:
            navigationItem.title = "함께게시판"
        case .market:
            navigationItem.title = "장터게시판"
        }
    }
}

// MARK: GatheringBoardDetailHeaderViewDelegate
extension GatheringBoardDetailViewController: GatheringBoardDetailHeaderViewDelegate {
    func completeGatheringStatus() {
        CommunityNetworkManager.completeGatheringStatus(index: postIndex) { [weak self] isSucceded in
            guard let self = self, isSucceded else {
                print("DEBUG: Completing gatheringStatus is failed..")
                return
            }
            self.fetchPost(postIndex: self.postIndex)
        }
        
    }
}

// MARK: CommentInputAccessoryViewDelegate
extension GatheringBoardDetailViewController: CommentInputAccessoryViewDelegate {
    func transferComment(_ contents: String) {
        print("DEBUG: Comment contents -> \(contents)")
        CommunityNetworkManager.postComment(index: postIndex, contents: contents) { [weak self] numOfComments in
            guard let self = self, let numOfComments = numOfComments else {
                print("DEBUG: Posting comment is failed..")
                return
            }
            DispatchQueue.main.async {
                self.commentInputView.clearComment()
                self.post.updateNumberOfComments(numberOfComments: numOfComments)
                self.headerView.viewModel = GatheringBoardDetialHeaderViewModel(post: self.post, userID: self.userID, gatheringStatus: self.gatheringStatus)
            }
            self.fetchComments(of: self.currentPage, shouldRefresh: true)
        }
    }
}

// MARK: UITableViewDataSource, Delegate
extension GatheringBoardDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableReuserIdetifier) as? CommentTableViewCell else { return CommentTableViewCell() }
        cell.viewModel = CommentTableViewCellViewModel(comment: commentList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: UICollectionViewDataSource
extension GatheringBoardDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postingImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath) as UICollectionViewCell
        let imageView = UIImageView()
        imageView.image = postingImages[indexPath.item]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        imageView.layer.cornerRadius = 10.0
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalTo(0) }
        return cell
    }
}

// MARK: UITableViewDataSourcePrefetching
extension GatheringBoardDetailViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("DEBUG: prefetchRow \(indexPaths.map { $0.row })")
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            if ($0.row + 1) / 10 + 1 == currentPage { // 10개씩 불러올 때 숫자 값
                self.fetchComments(of: currentPage)
            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension GatheringBoardDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Did tap collectionViewCell..")
        let viewController = FullImageViewController(imageList: postingImages, page: indexPath.item + 1)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension GatheringBoardDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - (postingImages.count == 1 ? 36.0 : 72.0)
        let height: CGFloat = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 18.0, bottom: 0, right: 18.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18.0
    }
}
