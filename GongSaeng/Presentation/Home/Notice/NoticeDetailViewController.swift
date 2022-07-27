//
//  NoticeDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/26.
//

import UIKit

class NoticeDetailViewController: UITableViewController {
    
    // MARK: Properties
    var notice: Notice?
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
        let commentInputAccesoryView = CommentInputAccessoryView(frame: frame)
        return commentInputAccesoryView
    }()
    
    @IBOutlet weak var postingUserImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentsLabel: UITextView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        tableView.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationView()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // 화면터치 시 키보드 내리기
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Helpers
    private func configure() {
        postingUserImageView.layer.cornerRadius = postingUserImageView.frame.height / 2
        postingUserImageView.layer.borderWidth = 1
        postingUserImageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).cgColor
        
        if let notice = notice {
            categoryLabel.text = notice.category
            titleLabel.text = notice.title
//            timeLabel.text = notice.time
//            contentsLabel.text = notice.contents
        }
    }
    
    private func configureNavigationView() {
        navigationItem.title = "공지사항"
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        let backBarButton = UIBarButtonItem(title: "목록", style: .plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16.0)], for: .normal)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
    }
}

// MARK: UITableViewDataSource
extension NoticeDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCelll else { return CommentTableViewCelll() }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension NoticeDetailViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

// MARK: UITableViewCell  ->  댓글 Cell
class CommentTableViewCelll: UITableViewCell {
    @IBOutlet weak var commentWriterImageView: UIImageView!
    @IBOutlet weak var commentWriterNicknameLabel: UILabel!
    @IBOutlet weak var commentedTimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentWriterImageView.layer.cornerRadius = commentWriterImageView.frame.height / 2
        commentWriterImageView.layer.borderWidth = 1
        commentWriterImageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).cgColor
    }
}

// MARK: UITextViewDelegate
extension NoticeDetailViewController: UITextViewDelegate {
    // 리턴 누르면 키보드 내리기
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}


//----------------------------------------------------------------


// MARK: UICollectionViewCell  ->  사진 수평식 컬렉션뷰
class NoticeImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var attachedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        attachedImageView.layer.cornerRadius = 8
    }
}

// MARK: UICollectionViewDataSource
extension NoticeDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoticeImageCollectionViewCell", for: indexPath) as? NoticeImageCollectionViewCell else { return NoticeImageCollectionViewCell() }
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension NoticeDetailViewController: UICollectionViewDelegate {

}

// MARK: UICollectionViewDelegateFlowLayout
extension NoticeDetailViewController: UICollectionViewDelegateFlowLayout {

}
