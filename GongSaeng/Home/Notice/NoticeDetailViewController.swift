//
//  NoticeDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/26.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    
    @IBOutlet weak var postingUserImageView: UIImageView!
    
    @IBOutlet weak var boundaryPresentingView: UIView!
    @IBOutlet weak var textContainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!

    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var boundaryPresentingViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postingUserImageView.layer.cornerRadius = postingUserImageView.frame.height / 2
        postingUserImageView.layer.borderWidth = 1
        postingUserImageView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).cgColor
        
        textContainView.layer.cornerRadius = textContainView.frame.height / 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        boundaryPresentingView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        placeHolderSetting(commentTextView)
    }
    
    // 화면터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.commentTextView.resignFirstResponder()
    }
    
    // Placeholder 함수
    private func placeHolderSetting(_ textView: UITextView) {
        textView.text = "댓글 작성중입니다."
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        commentTextViewHeightConstraint.constant = 33.0
    }
    
// MARK:- 키보드 보일 때 함수
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: animationDuration, animations: { self.boundaryPresentingViewBottomConstraint.constant = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            })

            let scrollContentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
            tableView.contentInset = scrollContentInset
            tableView.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height)
        }
    }


// MARK:- 키보드 내릴 때 함수
    @objc func keyboardHideShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        UIView.animate(withDuration: animationDuration, animations: { self.boundaryPresentingViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })

        let scrollContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = scrollContentInset
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

class NoticeTableView: UITableView {
    
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var attachedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        attachedImageView.layer.cornerRadius = 8
    }
}

class CommentTableViewCell: UITableViewCell {
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

extension NoticeDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeHolderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        if textView.textColor == placeHolderColor {
            textView.text = nil
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderSetting(textView)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: commentTextView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if estimatedSize.height <= 70 {
            textView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        } else {
            textView.isScrollEnabled = true
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }

        return true
    }
}

extension NoticeTableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return ImageCollectionViewCell() }
        return cell
    }
}

extension NoticeTableView: UICollectionViewDelegate {
    
}

extension NoticeTableView: UICollectionViewDelegateFlowLayout {
    
}

extension NoticeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell() }
        
        return cell
    }
}

extension NoticeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
