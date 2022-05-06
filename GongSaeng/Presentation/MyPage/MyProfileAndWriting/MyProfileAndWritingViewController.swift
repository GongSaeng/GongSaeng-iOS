//
//  MyProfileAndWritingViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/20.
//

import UIKit
import SnapKit

final class MyProfileAndWritingViewController: UIViewController {
    
    // MARK: Properties
    let tableView = UITableView()
    
    let headerView = MyProfileAndWritingHeaderView()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        configureTableView()
        configureTableHeaderView()
        configureNavigationView()
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
//                print("DEBUG: height \(height)")
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
    }
    
    private func configureTableHeaderView() {
        tableView.tableHeaderView = headerView
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyWrittenPostCell", for: indexPath) as? MyWrittenPostCell else { return MyWrittenPostCell() }
//        cell.backgroundColor = .systemGray5
        cell.viewModel = MyWrittenPostCellViewModel()
        if indexPath.row % 2 == 1 {
            cell.numOfCommentLabel.text = "99+"
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension MyProfileAndWritingViewController: UITableViewDelegate {
}
