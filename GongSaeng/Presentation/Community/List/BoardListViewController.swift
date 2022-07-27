//
//  BoardListViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit

final class BoardListViewController: UITableViewController {
    
    // MARK: Properties
    private var user: User
    private let communityType: CommunityType
    
    private let reuseIdentifier1 = "BoardListCell"
    private let reuseIdentifier2 = "MarketBoardCell"
    private var communityList = [Community]()
    private var fetchedPageList = [Int]()
    private var currentPage = 1
    
    // MARK: Lifecycle
    init(withUser user: User, communityType: CommunityType) {
        self.user = user
        self.communityType = communityType
        
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigationBar()
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCommunitys(of: currentPage, shouldRefresh: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        currentPage = 1
        fetchedPageList.removeAll()
    }
    
    // MARK: API
    private func fetchCommunitys(of page: Int, shouldRefresh: Bool = false) {
        guard fetchedPageList.firstIndex(of: currentPage) == nil else { return }
        fetchedPageList.append(page)
        showLoader(true)
        CommunityNetworkManager.fetchCommunitys(page: page, communityType: communityType) { [weak self] communitys in
            self?.showLoader(false)
            print("DEBUG: communitys -> \(communitys)")
            guard let self = self else { return }
            if shouldRefresh {
                self.communityList = communitys
            } else {
                self.communityList += communitys
            }
            print("DEBUG: communitysIndexs \(self.communityList.map { $0.index })")
            self.currentPage += 1
            print("DEBUG: currentPage(\(self.currentPage)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: Actions
    @objc
    private func didTapWriteButton() {
        let viewController = WriteViewController(commuityType: communityType)
        viewController.hidesBottomBarWhenPushed = true
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func refresh() {
        currentPage = 1
        fetchedPageList.removeAll()
        print("DEBUG: fetched page list \(fetchedPageList)")
        fetchCommunitys(of: currentPage, shouldRefresh: true)
    }
    
    // MARK: Helpers
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        let refreshControl = self.tableView.refreshControl
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .darkGray
        refreshControl?.attributedTitle =  NSAttributedString(string: "당겨서 새로고침")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func configureTableView() {
        if communityType == .market {
            tableView.register(MarketBoardCell.self, forCellReuseIdentifier: reuseIdentifier2)
        } else {
            tableView.register(BoardListCell.self, forCellReuseIdentifier: reuseIdentifier1)
        }
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.prefetchDataSource = self
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "write"), style: .plain, target: self, action: #selector(didTapWriteButton))
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

// MARK: UITableViewDataSource
extension BoardListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communityList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if communityType == .market {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2) as? MarketBoardCell else { return MarketBoardCell() }
            cell.viewModel = MarketBoardCellViewModel(community: communityList[indexPath.row])
            print("DEBUG: MarketBoardCell \(communityList[indexPath.row])")
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier1) as? BoardListCell else { return BoardListCell() }
            cell.viewModel = BoardCellListViewModel(communityType: communityType, community: communityList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: UITableViewDataSourcePrefetching
extension BoardListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("DEBUG: prefetchRow \(indexPaths.map { $0.row })")
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            if ($0.row + 1) / 10 + 1 == currentPage { // 10개씩 불러올 때 숫자 값
                self.fetchCommunitys(of: currentPage)
            }
        }
    }
}

// MARK: UITableViewDelegate
extension BoardListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Did tap \(indexPath.row) tableViewCell")
        let postIndex = communityList[indexPath.row].index
        print("DEBUG: index is \(postIndex)")
        let viewController = BoardDetailViewController(withUser: user, postIndex: postIndex, communityType: communityType)
        viewController.hidesBottomBarWhenPushed = true
        viewController.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        let backBarButton = UIBarButtonItem(title: "목록", style: .plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.pushViewController(viewController, animated: true)
    }
}
