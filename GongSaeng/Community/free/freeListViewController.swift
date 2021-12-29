//
//  freeListViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/25.
//

import UIKit

class freeListViewController: UIViewController {
    
    let colorBlack20: UIColor = UIColor(white: 0, alpha: 0.2)
    private var frees = [free]()
    private var filteredfrees = [free]()
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var freeButton: UIButton!
    @IBOutlet weak var cermonyButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureRefreshControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationView()
        fetchfrees()
    }
    
    // MARK: API
    func fetchfrees() {
        freeNetwork.fetchfree { [weak self] frees in
            guard let self = self else { return }
            self.frees = frees
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
            self.fetchfrees()
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
        [allButton, freeButton, cermonyButton, etcButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
            $0?.layer.cornerRadius = 18
        }
        
    }
    
    private func configureNavigationView() {
//        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "자유게시판"
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "write"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(writeButtonTap))
        
        let backBarButton = UIBarButtonItem(title: "게시판목록", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], for: .normal)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
    }
    
    private func classficationButtonTapped(button: UIButton) {
        [allButton, freeButton, cermonyButton, etcButton].forEach {
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
    
    @objc func writeButtonTap() {
        print("write button tapped")
        let viewController = FreeWriteController()
//        let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "freeWrite") as! freeWriteViewController
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
    
    @IBAction func freeButtonTapped(_ sender: UIButton) {
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
extension freeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "freeTableViewCell", for: indexPath) as? freeTableViewCell else { return UITableViewCell() }
        let free = frees[indexPath.row]
        cell.viewModel = freeListCellViewModel(free: free)
        return cell
    }
}

// MARK: TableView Delegate
extension freeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "free", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "freeDetailViewController") as! freeDetailViewController
        viewController.free = frees[indexPath.row]
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: TableViewCell
class freeTableViewCell: UITableViewCell {
    // MARK: Properties
    var viewModel: freeListCellViewModel? {
        didSet { configure() }
    }
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UITextView!
    @IBOutlet weak var uploadedTimeLabel: UILabel!
    @IBOutlet weak var managerImageView: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
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
        
       // categoryLabel.text = viewModel.category
        titleLabel.text = viewModel.title
        contentsLabel.text = viewModel.contents
        uploadedTimeLabel.text = viewModel.time
        writerLabel.text = viewModel.writer
        
    }
}
