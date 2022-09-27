//
//  GongSaengTalkViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

final class GongSaengTalkViewController: UIViewController {
    
    // MARK: Properties
    private var talks = [GongSaengTalk]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if talks.isEmpty {
            fetchTalks()
        } else {
            talks = talks.shuffled()
            tableView.reloadData()
        }
    }
    
    // MARK: Actions
    @IBAction func lookAtAllThingsButtonHandler(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Notice", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NoticeListViewController") as! GongSaengTalkListViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: API
    private func fetchTalks() {
        HomeNetworkManager.fetchGongSaengTalk { [weak self] talks in
            guard let self = self else { return }
            self.talks = talks.shuffled()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: UITableViewDataSource
extension GongSaengTalkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talks.count > 2 ? 3 : talks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? GongSaengTalkCell else { return GongSaengTalkCell() }
        let talk = talks[indexPath.row]
        cell.viewModel = GongSaengTalkListCellViewModel(talk: talk)
        return cell
    }
}

// MARK: UITableViewCell
final class GongSaengTalkCell: UITableViewCell {
    
    // MARK: Properties
    var viewModel: GongSaengTalkListCellViewModel? {
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
