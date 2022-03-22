//
//  NoticeViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class NoticeViewController: UIViewController {
    
    // MARK: Properties
    private var notices = [Notice]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNotices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if notices == [] {
            fetchNotices()
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
            self.notices = notices
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension NoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? NoticeCell else { return NoticeCell() }
        let notice = notices[indexPath.row]
        cell.viewModel = NoticeListCellViewModel(notice: notice)
        return cell
    }
}

extension NoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Notice", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NoticeDetailViewController") as! NoticeDetailViewController
        viewController.notice = notices[indexPath.row]
        viewController.modalPresentationStyle = .fullScreen
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

class NoticeCell: UITableViewCell {
    
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
        dateLabel.text = viewModel.time
//        guard let timeString = viewModel.time else { return }
//        let dateString = String(timeString[timeString.index(timeString.startIndex, offsetBy: 4)...])
//        dateLabel.text = dateString
    }
}
