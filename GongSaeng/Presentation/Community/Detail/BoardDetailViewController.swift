//
//  GatheringBoardDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit
import Kingfisher

class BoardDetailViewController: UITableViewController {
    
    // MARK: Propeties
    private var post: Post?
    private let communityType: CommunityType
    private let userID: String
    private var postIndex: Int
    
    private var currentIndex: CGFloat = 0
    private var currentPage = 1
    private var fetchedPageList = [Int]()
    private var commentList = [Comment]()
    private var isKeyboardShowing = false
    
    private let collectionReuseIdentifier = "ImageCollectioViewCell"
    private let tableReuserIdetifier = "CommentTableViewCell"
    private var postingImageUrls = [URL]()
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
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
    init(withUser user: User, postIndex: Int, communityType: CommunityType) {
        self.userID = user.id
        self.postIndex = postIndex
        self.communityType = communityType
        
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configure()
        fetchPost(postIndex: postIndex)
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        commentInputView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        commentInputView.isHidden = true
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
        CommunityNetworkManager.fetchPost(index: index) { post in
            print("DEBUG: fetch succeded ->", post)
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let headerView = self.tableView.tableHeaderView as? BoardDetailHeaderView else { return }
                headerView.viewModel = BoardDetialHeaderViewModel(post: post, userID: self.userID)
                self.postingImageUrls = headerView.viewModel?.postingImageUrls ?? []
                self.tableView.tableHeaderView = headerView
                self.tableView.reloadData()
                self.currentPage = 1
                self.fetchedPageList = []
                self.fetchComments(of: self.currentPage, shouldRefresh: true)
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
        print("DEBUG: keyboardHeight -> \(keyboardFrame.height)")
        guard keyboardFrame.height > 120 else {
            isKeyboardShowing = false
            return
        }
        guard keyboardFrame.height > 200, !isKeyboardShowing else { return }
        let newOffsetY = tableView.contentOffset.y + keyboardFrame.height - commentInputView.frame.height - bottomPadding
        tableView.setContentOffset(CGPoint(x: 0, y: newOffsetY), animated: true)
        isKeyboardShowing = true
    }
    
    // MARK: Helpers
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func configure() {
        let headerView = BoardDetailHeaderView(communityType: communityType)
        headerView.delegate = self
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
            navigationItem.title = "고민게시판"
        case .suggestion:
            navigationItem.title = "맛집게시판"
        case .gathering:
            navigationItem.title = "챌린지게시판"
        case .market:
            navigationItem.title = "장터게시판"
        }
    }
}

// MARK: GatheringBoardDetailHeaderViewDelegate
extension BoardDetailViewController: BoardDetailHeaderViewDelegate {
    func completeGatheringStatus() {
        CommunityNetworkManager.completeValidStatus(index: postIndex, communityType: communityType) { [weak self] isSucceded in
            guard let self = self, isSucceded else {
                print("DEBUG: Completing gatheringStatus is failed..")
                return
            }
            self.fetchPost(postIndex: self.postIndex)
        }
        
    }
}

// MARK: CommentInputAccessoryViewDelegate
extension BoardDetailViewController: CommentInputAccessoryViewDelegate {
    func transferComment(_ contents: String) {
        print("DEBUG: Comment contents -> \(contents)")
        CommunityNetworkManager.postComment(index: postIndex, contents: contents) { [weak self] numOfComments in
            guard let self = self, let _ = numOfComments else {
                print("DEBUG: Posting comment is failed..")
                return
            }
            self.fetchPost(postIndex: self.postIndex)
            DispatchQueue.main.async {
                self.commentInputView.clearComment()
            }
        }
    }
}

// MARK: UITableViewDataSource, Delegate
extension BoardDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableReuserIdetifier) as? CommentTableViewCell else { return CommentTableViewCell() }
        cell.viewModel = CommentTableViewCellViewModel(comment: commentList[indexPath.row], shouldBeAnonymous: communityType == .emergency)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: UICollectionViewDataSource
extension BoardDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postingImageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath) as UICollectionViewCell
        let imageView = UIImageView()
        imageView.kf.setImage(with: postingImageUrls[indexPath.row])
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
extension BoardDetailViewController: UITableViewDataSourcePrefetching {
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
extension BoardDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Did tap collectionViewCell..")
        let viewController = FullImageViewController(imageUrlList: postingImageUrls, page: indexPath.item + 1)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension BoardDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - (postingImageUrls.count == 1 ? 36.0 : 72.0)
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
