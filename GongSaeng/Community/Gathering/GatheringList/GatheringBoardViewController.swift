//
//  GatheringBoardViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit

final class GatheringBoardViewController: UITableViewController {
    
    // MARK: Properties
    var user: User
    private let reuseIdentifier = "GatheringBoardCell"
    private var gatheringList = [Gathering]()
    private var fetchedPageList = [Int]()
    private var currentPage = 1
    
    // MARK: Lifecycle
    init(withUser user: User) {
        self.user = user
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
        
        fetchGatherings(of: currentPage)
    }
    
    // MARK: API
    private func fetchGatherings(of page: Int) {
        guard fetchedPageList.firstIndex(of: currentPage) == nil else { return }
        fetchedPageList.append(page)
        CommunityNetworkManager.fetchGatheringPosts(page: page) { [weak self] gatherings in
            guard let self = self else { return }
            self.gatheringList += gatherings
            self.currentPage += 1
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: Actions
    @objc
    private func didTapWriteButton() {
        let viewController = GatheringWriteViewController()
        viewController.hidesBottomBarWhenPushed = true
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helpers
    @objc
    private func refresh() {
        self.fetchGatherings(of: currentPage)
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        let refreshControl = self.tableView.refreshControl
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .darkGray
        refreshControl?.attributedTitle =  NSAttributedString(string: "당겨서 새로고침")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func configureTableView() {
        tableView.register(GatheringBoardCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.prefetchDataSource = self
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "write"), style: .plain, target: self, action: #selector(didTapWriteButton))
    }
}

// MARK: UITableViewDataSource
extension GatheringBoardViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEBUG: gatherings.count ->", gatheringList.count)
        return gatheringList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? GatheringBoardCell else { return GatheringBoardCell() }
        cell.viewModel = GatheringBoardCellViewModel(gathering: gatheringList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: UITableViewDataSourcePrefetching
extension GatheringBoardViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("DEBUG: prefetchRow \(indexPaths.map { $0.row })")
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            if ($0.row + 1) / 10 + 1 == currentPage {
                self.fetchGatherings(of: currentPage)
            }
        }
    }
}

// MARK: UITableViewDelegate
extension GatheringBoardViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Did tap \(indexPath.row) tableViewCell")
        let index = gatheringList[indexPath.row].index
        let gatheringStatus = gatheringList[indexPath.row].gatheringStatus
        print("DEBUG: index is \(index)")
        showLoader(true)
        CommunityNetworkManager.fetchPost(index: index) { [weak self] post in
            print("DEBUG: fetch succeded ->", post)
            guard let self = self else { return }
            DispatchQueue.main.async {
                let viewController = GatheringBoardDetailViewController(withUser: self.user, post: post, gatheringStatus: gatheringStatus)
                viewController.hidesBottomBarWhenPushed = true
                viewController.navigationItem.title = "함께게시판"
                viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
                let backBarButton = UIBarButtonItem(title: "목록", style: UIBarButtonItem.Style.plain, target: self, action: nil)
                backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
                self.navigationItem.backBarButtonItem = backBarButton
                self.showLoader(false)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
