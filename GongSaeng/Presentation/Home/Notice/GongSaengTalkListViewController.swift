//
//  GongSaengTalkListViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/25.
//

import UIKit

final class GongSaengTalkListViewController: UIViewController {
    
    // MARK: Properties
    let colorBlack20: UIColor = UIColor(white: 0, alpha: 0.2)
    private var talks = [GongSaengTalk]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
   
        fetchTalks()
        configureRefreshControl()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationView()
    }
    
    // MARK: API
    private func fetchTalks() {
        HomeNetworkManager.fetchGongSaengTalk { [weak self] talks in
            guard let self = self else { return }
            self.talks = talks.shuffled()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: Helpers
    @objc func refresh() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.fetchTalks()
        }
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        let refreshControl = self.tableView.refreshControl
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .darkGray
        refreshControl?.attributedTitle =  NSAttributedString(string: "당겨서 새로고침")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func configureNavigationView() {
        navigationItem.title = "공생토크"
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        let backBarButton = UIBarButtonItem(title: "홈", style: .plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16.0)], for: .normal)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
    }
}

// MARK: TableView DataSource
extension GongSaengTalkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as? GongSaengTalkTableViewCell else { return GongSaengTalkTableViewCell() }
        let talk = talks[indexPath.row]
        cell.viewModel = GongSaengTalkListCellViewModel(talk: talk)
        return cell
    }
}

// MARK: TableView Delegate
extension GongSaengTalkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

// MARK: TableViewCell
final class GongSaengTalkTableViewCell: UITableViewCell {
    // MARK: Properties
    var viewModel: GongSaengTalkListCellViewModel? {
        didSet { configure() }
    }
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Helpers
    func configure() {
        guard let viewModel = viewModel else { return }
        
        categoryLabel.text = viewModel.category
//        titleLabel.text = viewModel.title
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.alignment = .center
        titleLabel.attributedText = NSAttributedString(
            string: viewModel.title,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 16.0, weight: .medium),
                .foregroundColor: UIColor(white: 0, alpha: 0.87)])
    }
}
