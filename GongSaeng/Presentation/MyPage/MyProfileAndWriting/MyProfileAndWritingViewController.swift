//
//  MyProfileAndWritingViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/20.
//

import UIKit
import SnapKit

enum MyPostType {
    case post
    case comment
}

protocol MyProfileAndWritingViewControllerDelegate: AnyObject {
    func presentThunderView(index: Int)
}

final class MyProfileAndWritingViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: MyProfileAndWritingViewControllerDelegate?
    
    let user: User
    let headerViewModel: MyProfileAndWritingHeaderViewModel
    let headerView: MyProfileAndWritingHeaderView
    
    var myWrittenList = [MyWritten]()
    let tableView = UITableView()
    
    // MARK: Lifecycle
    init(user: User) {
        self.user = user
        self.headerViewModel = MyProfileAndWritingHeaderViewModel(user: user)
        self.headerView = MyProfileAndWritingHeaderView(viewModel: headerViewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        configureTableView()
        configureTableHeaderView()
        configureNavigationView()
        fetchMyPosts(myPostType: .post)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        
//    }
    
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
    private func fetchMyPosts(myPostType: MyPostType) {
        showLoader(true)
        CommunityNetworkManager.fetchMyPosts(myPostType: myPostType) { [weak self] myWritten in
            self?.showLoader(false)
            print("DEBUG: myWritten -> \(myWritten)")
            self?.myWrittenList = myWritten
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: Helpers
    private func configureTableView() {
        view.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 67.0
        tableView.separatorStyle = .none
        tableView.register(MyWrittenPostCell.self, forCellReuseIdentifier: "MyWrittenPostCell")
        tableView.register(MyCommentCell.self, forCellReuseIdentifier: "MyCommentCell")
    }
    
    private func configureTableHeaderView() {
        tableView.tableHeaderView = headerView
        headerView.delegate = self
    }
    
    private func configureNavigationView() {
        navigationItem.title = "내 프로필/작성글/댓글"
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 0.8)
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .medium)
        var backImage = UIImage(systemName: "arrow.left", withConfiguration: configuration)
        backImage = backImage?.withInsets(.init(top: 0, left: 5.0, bottom: 0, right: 0))
        
        navigationController?.navigationBar.tintColor = .black.withAlphaComponent(0.6)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: UITableViewDataSource
extension MyProfileAndWritingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWrittenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myPost = myWrittenList[indexPath.row] as? MyPost {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyWrittenPostCell", for: indexPath) as? MyWrittenPostCell else { return MyWrittenPostCell() }
            cell.viewModel = MyWrittenPostCellViewModel(myPost: myPost)
            return cell
        } else  if let myComment = myWrittenList[indexPath.row] as? MyComment {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommentCell", for: indexPath) as? MyCommentCell else { return MyCommentCell() }
            cell.data = myComment
            return cell
        }
        fatalError()
    }
}

// MARK: UITableViewDelegate
extension MyProfileAndWritingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var index = myWrittenList[indexPath.row].postIndex
        var boardName = myWrittenList[indexPath.row].boardName
        var communityType: CommunityType = .free
        switch boardName {
        case "자유게시판": communityType = .free
        case "고민게시판": communityType = .emergency
        case "맛집게시판": communityType = .suggestion
        case "챌린지게시판": communityType = .gathering
        case "장터게시판": communityType = .market
        case "번개게시판":
            navigationController?.popViewController(animated: false)
            delegate?.presentThunderView(index: index)
            return
            
        default:
            return
        }
        
        let viewController = BoardDetailViewController(withUser: user, postIndex: index, communityType: communityType)
        viewController.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: MyProfileAndWritingHeaderViewDelegate
extension MyProfileAndWritingViewController: MyProfileAndWritingHeaderViewDelegate {
    func didTapPostButton(myPostType: MyPostType) {
        fetchMyPosts(myPostType: myPostType)
    }
}
