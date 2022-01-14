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
    var userID: String
    var post: Post
    var gatheringStatus: Int
    
    private let collectionReuseIdentifier = "GatheringImageCell"
    private let tableReuserIdetifier = "CommentTableViewCell"
    private let headerView = GatheringBoardDetailHeaderView()
    private var postingImages: [UIImage]? { return headerView.viewModel?.postingImages }
    
//    private let gathering = Gathering(index: 1, gatheringStatus: 0, title: "저녁에 떡볶이 같이 드실분??", contents: "엽떡 시킬건데 떡볶이 혼자 다 먹기 힘들어서.. 같이 드실분 구합니다~ 엽떡 3단계 이상으로 주문하고 싶어서 매운거 잘 드시는 분이면 좋겠어요!ㅎㅎ 사이드도 협의 후에 시킬 예정입니다~ 부담없이 댓글남겨주세요! 최대 4명까지만 선착순으로 구하겠습니다~", writerImageUrl: "10", writerId: "sdfasdf", writerNickname: "떡볶이가좋아", uploadedTime: "1시간 전", numberOfComments: 5, postingImagesUrl: ["10", "10", "10"])
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100.0)
        let commentInputAccesoryView = CommentInputAccessoryView(frame: frame)
        return commentInputAccesoryView
    }()
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: Lifecycle
    init(withUser user: User, post: Post, gatheringStatus: Int) {
        self.userID = user.id
        self.post = post
        self.gatheringStatus = gatheringStatus
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
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
    
    // MARK: Helpers
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
    }
}

// MARK: UIScrollViewDelegate
//extension GatheringBoardDetailViewController {
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let layout = headerView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
//
//        var offset = targetContentOffset.pointee
//        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
//        var roundedIndex = round(index)
//
//        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
//            roundedIndex = floor(index)
//        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
//            roundedIndex = ceil(index)
//        } else {
//            roundedIndex = round(index)
//        }
//
//        if currentIndex > roundedIndex {
//            currentIndex -= 1
//            roundedIndex = currentIndex
//        } else if currentIndex < roundedIndex {
//            currentIndex += 1
//            roundedIndex = currentIndex
//        }
//
//        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
//        targetContentOffset.pointee = offset
//    }
//}

// MARK: GatheringBoardDetailHeaderViewDelegate
extension GatheringBoardDetailViewController: GatheringBoardDetailHeaderViewDelegate {
    func completeGatheringStatus() {
        //
    }
}

// MARK: UITableViewDataSource, Delegate
extension GatheringBoardDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableReuserIdetifier) as? CommentTableViewCell else {
            print("DEBUG: Return UITableViewCell() ")
            return CommentTableViewCell() }
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
        return postingImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let postingImages = postingImages else { return UICollectionViewCell() }
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

// MARK: UICollectionViewDelegate
extension GatheringBoardDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Did tap collectionViewCell..")
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension GatheringBoardDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 72.0
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
