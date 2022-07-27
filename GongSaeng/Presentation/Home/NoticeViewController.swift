//
//  NoticeViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

final class NoticeViewController: UIViewController {
    
    // MARK: Properties
    private var notices = [Notice]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if notices.isEmpty {
            fetchNotices()
        } else {
            notices = notices.shuffled()
            tableView.reloadData()
        }
    }
    
    // MARK: Actions
    @IBAction func lookAtAllThingsButtonHandler(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Notice", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NoticeListViewController") as! NoticeListViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: API
    private func fetchNotices() {
        HomeNetworkManager.fetchNotice { [weak self] notices in
            guard let self = self else { return }
            self.notices = notices.shuffled()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: UITableViewDataSource
extension NoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count > 2 ? 3 : notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? NoticeCell else { return NoticeCell() }
        let notice = notices[indexPath.row]
        cell.viewModel = NoticeListCellViewModel(notice: notice)
        return cell
    }
}

// MARK: UITableViewCell
final class NoticeCell: UITableViewCell {
    
    // MARK: Properties
    var viewModel: NoticeListCellViewModel? {
        didSet { configure() }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
  
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.category
    }
}
