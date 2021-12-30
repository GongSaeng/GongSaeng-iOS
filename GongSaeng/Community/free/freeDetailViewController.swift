//
//  freeDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/26.
//

import UIKit

class freeDetailViewController: UIViewController {
    
    // MARK: Properties
    var free: free?
    private var free_comments = [free_comment]()
    
    private lazy var freeCommentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150.0)
        let CommentInputAccesoryView = CommentInputAccesoryView(frame: frame)
        CommentInputAccesoryView.delegate = self
        return CommentInputAccesoryView
    }()
    
    @IBOutlet weak var postingUserImageView: UIImageView!
    
   //
    
   // @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentsLabel: UITextView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private func fetchfree_comments() {
        freeNetwork.fetch_freecomment { [weak self] free_comments in
            guard let self = self else { return }
            self.free_comments = free_comments
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure()
        tableView.keyboardDismissMode = .interactive
        fetchfree_comments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = tableView.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                print("DEBUG: headerView height ->", height)
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    override var inputAccessoryView: UIView? {
        get { return freeCommentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // 화면터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configure() {
        tabBarController?.tabBar.isHidden = true
        
        postingUserImageView.layer.cornerRadius = postingUserImageView.frame.height / 2
        postingUserImageView.layer.borderWidth = 1
        postingUserImageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).cgColor
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        if let free = free {
            //categoryLabel.text = free.category
            titleLabel.attributedText = NSAttributedString(string: free.title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            timeLabel.text = free.time
            contentsLabel.text = free.contents
            writerLabel.text = free.writer
        }
        
    }
    
    private func configureNavigationView() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "자유게시판"
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        let backBarButton = UIBarButtonItem(title: "목록", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], for: .normal)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension freeDetailViewController: CommentInputAccesoryViewDelegate {
    func transferComment(_ contents: String?) {
        let parent_num="3"
        let contents = contents ?? "test"
        freeNetwork.freeCommentWrite(num: parent_num, contentsText: contents) { [weak self] isSucceded in
            guard let self = self else { return }
            self.fetchfree_comments()
        }
    }
}

class freeTableView: UITableView {
    
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var attachedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        layer.borderWidth = 0.5
    }
}

extension freeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return free_comments.count
        //return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "freeCommentTableViewCell", for: indexPath) as? freeCommentTableViewCell else { return freeCommentTableViewCell() }
        let free_comment = free_comments[indexPath.row]
        cell.viewModel = freeCommentCellViewModel(free_comment: free_comment)
        return cell
    }
}

extension freeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

class freeCommentTableViewCell: UITableViewCell {
    var viewModel: freeCommentCellViewModel? {
        didSet { configure() }
    }
    
    @IBOutlet weak var CommentWriterImageView: UIImageView!
    @IBOutlet weak var CommentWriterNicknameLabel: UILabel!
    @IBOutlet weak var CommentedTimeLabel: UILabel!
    @IBOutlet weak var CommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CommentWriterImageView.layer.cornerRadius = CommentWriterImageView.frame.height / 2
        CommentWriterImageView.layer.borderWidth = 1
        CommentWriterImageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).cgColor
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
       // categoryLabel.text = viewModel.category
        CommentWriterNicknameLabel.text = viewModel.writer
        CommentLabel.text = viewModel.comment
        CommentedTimeLabel.text = viewModel.time
        //writerLabel.text = viewModel.writer
        
    }
    
    
}

extension freeDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeHolderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        if textView.textColor == placeHolderColor {
            textView.text = nil
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
//            placeHolderSetting(textView)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }

        return true
    }
}

extension freeTableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return ImageCollectionViewCell() }
        return cell
    }
}

extension freeTableView: UICollectionViewDelegate {
    
}

extension freeTableView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100.0, height: 100.0)
//    }
}

extension freeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "freeCommentTableViewCell", for: indexPath) as? freeCommentTableViewCell else { return freeCommentTableViewCell() }
        
        return cell
    }
}

