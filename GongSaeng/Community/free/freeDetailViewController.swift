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
    
    private lazy var freeCommentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150.0)
        let CommentInputAccesoryView = CommentInputAccesoryView(frame: frame)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        tableView.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationView()
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
            titleLabel.text = free.title
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

class freeTableView: UITableView {
    
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var attachedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        attachedImageView.layer.cornerRadius = 8
    }
}

class freeCommentTableViewCell: UITableViewCell {
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

extension freeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}