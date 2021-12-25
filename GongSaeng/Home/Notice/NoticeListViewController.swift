//
//  NoticeListViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/25.
//

import UIKit

class NoticeListViewController: UIViewController {
    
    let colorBlack20: UIColor = UIColor(white: 0, alpha: 0.2)
    private var notices = [Notice]()
    private var filteredNotices = [Notice]()
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var cermonyButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        fetchNotices()
        
        // 당겨서 새로고침
        tableView.refreshControl = UIRefreshControl()
        let refreshControl = self.tableView.refreshControl
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .darkGray
        refreshControl?.attributedTitle =  NSAttributedString(string: "당겨서 새로고침")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    // MARK: API
    private func fetchNotices() {
        NoticeNetwork.fetchNotice { notices in
            self.notices = notices
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
            self.fetchNotices()
        }
    }
    
    private func configureView() {
        [allButton, noticeButton, cermonyButton, etcButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
            $0?.layer.cornerRadius = 18
        }
        
        // 분류버튼 전체버튼으로 초기화
        classficationButtonTapped(button: allButton)
    }
    
    private func classficationButtonTapped(button: UIButton) {
        [allButton, noticeButton, cermonyButton, etcButton].forEach {
            if $0 == button {
                $0?.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
                $0?.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
                $0?.isEnabled = false
            } else {
                $0?.setTitleColor(colorBlack20, for: .normal)
                $0?.layer.borderColor = colorBlack20.cgColor
                $0?.isEnabled = true
            }
        }
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
    
    @IBAction func noticeButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
    
    @IBAction func cermonyButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
    
    @IBAction func etcButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
}

// MARK: TableView DataSource
extension NoticeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as? NoticeTableViewCell else { return UITableViewCell() }
        let notice = notices[indexPath.row]
        cell.viewModel = NoticeListCellViewModel(notice: notice)
        return cell
    }
}

// MARK: TableView Delegate
extension NoticeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Notice", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NoticeDetailViewController") as! NoticeDetailViewController
        
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: TableViewCell
class NoticeTableViewCell: UITableViewCell {
    // MARK: Properties
    var viewModel: NoticeListCellViewModel? {
        didSet { configure() }
    }
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UITextView!
    @IBOutlet weak var uploadedTimeLabel: UILabel!
    @IBOutlet weak var managerImageView: UIImageView!
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        managerImageView.layer.cornerRadius = managerImageView.frame.height / 2
        thumnailImageView.layer.cornerRadius = 4
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        categoryLabel.text = viewModel.category
        titleLabel.text = viewModel.title
        contentsLabel.text = viewModel.contents
        uploadedTimeLabel.text = viewModel.time
    }
}
