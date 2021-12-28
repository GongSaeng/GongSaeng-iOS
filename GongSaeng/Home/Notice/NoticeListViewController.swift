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
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//        navigationController?.isNavigationBarHidden = false
        configureNavigationView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: API
    private func fetchNotices() {
        NoticeNetwork.fetchNotice { [weak self] notices in
            guard let self = self else { return }
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
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        let refreshControl = self.tableView.refreshControl
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .darkGray
        refreshControl?.attributedTitle =  NSAttributedString(string: "당겨서 새로고침")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
    
    private func configureNavigationView() {
//        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "공지사항"
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        let backBarButton = UIBarButtonItem(title: "홈", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], for: .normal)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
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
        self.navigationController?.popViewController(animated: true)
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
        viewController.notice = notices[indexPath.row]
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
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        managerImageView.layer.cornerRadius = managerImageView.frame.height / 2
        thumnailImageView.layer.cornerRadius = 4
    }
    
    // MARK: Helpers
    func configure() {
        guard let viewModel = viewModel else { return }
        
        categoryLabel.text = viewModel.category
        titleLabel.text = viewModel.title
        contentsLabel.text = viewModel.contents
        uploadedTimeLabel.text = viewModel.time
    }
}
