//
//  CheckOutRequestDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/15.
//

import UIKit

class CheckOutRequestDetailViewController: UIViewController {
    // 임시데이터
    var commentedUserDataList = [(UIImage(named: "profileImage_0.png"), "관리자123", "2시간 전", "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하"), (UIImage(named: "profileImage_1.png"), "김민지", "2시간 전", "네네!"), (UIImage(named: "profileImage_0.png"), "관리자", "1시간 전", "확인됐습니다!"), (UIImage(named: "profileImage_0.png"), "관리자123", "2시간 전", "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하"), (UIImage(named: "profileImage_1.png"), "김민지", "2시간 전", "네네!"), (UIImage(named: "profileImage_0.png"), "관리자", "1시간 전", "확인됐습니다!")]

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var boundaryPresentingView: UIView!
    @IBOutlet weak var textContainView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var roomConditionCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var boundaryPresentingViewBottomConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.roundCornerOfImageView()
        textContainView.layer.cornerRadius = textContainView.frame.height / 2

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        boundaryPresentingView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        placeHolderSetting(commentTextView)
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension

    }

    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // 화면터치 시 키보드 내리기
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                guard let self = self else { return }
                self.boundaryPresentingViewBottomConstraint.constant = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
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

        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let self = self else { return }
            self.boundaryPresentingViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })

        let scrollContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = scrollContentInset
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
}

// MARK:- 텍스트뷰 델리게이트
extension CheckOutRequestDetailViewController: UITextViewDelegate {
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

// MARK:- "컬렉션뷰 클래스 정의"
class RoomConditionImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roomConditionImageView: UIImageView!
}

class CheckOutRequestDetailTableView: UITableView {
    var roomConditionImageList: [UIImage?] = [UIImage(named: "profileImage_0.png"), UIImage(named: "profileImage_1.png"), UIImage(named: "profileImage_2.png"), UIImage(named: "profileImage_3.png")]
}


class CheckOutCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentedUserImageView: UIImageView!
    @IBOutlet weak var commentedUserNicknameLabel: UILabel!
    @IBOutlet weak var commentedTimeLabel: UILabel!
    @IBOutlet weak var commentedTextLabel: UILabel!
    
//    @IBOutlet weak var commentedTextLabelWidthConstraint: NSLayoutConstraint!
}

extension CheckOutRequestDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentedUserDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutCommentTableViewCell", for: indexPath) as? CheckOutCommentTableViewCell else { return CheckOutCommentTableViewCell() }
        cell.commentedUserImageView.image = commentedUserDataList[indexPath.row].0
        cell.commentedUserImageView.contentMode = .scaleAspectFill
        cell.commentedUserImageView.roundCornerOfImageView()
        
        cell.commentedUserNicknameLabel.text = commentedUserDataList[indexPath.row].1
        cell.commentedUserNicknameLabel.sizeToFit()

        cell.commentedTimeLabel.text = commentedUserDataList[indexPath.row].2
        cell.commentedTimeLabel.sizeToFit()
        
        cell.commentedTextLabel.text = commentedUserDataList[indexPath.row].3

        return cell
    }
}

extension CheckOutRequestDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sizingLabel: UILabel
        sizingLabel = UILabel()
        sizingLabel.font = UIFont(name: sizingLabel.font.fontName, size: 14)
        sizingLabel.textAlignment = .left
        sizingLabel.numberOfLines = 0
        sizingLabel.text = commentedUserDataList[indexPath.row].3
        let newSize = sizingLabel.sizeThatFits( CGSize(width: view.frame.width - 90, height: CGFloat.greatestFiniteMagnitude))
        
        return newSize.height + 82
    }
}


// MARK:- "컬렉션뷰 DataSource"
extension CheckOutRequestDetailTableView: UICollectionViewDataSource {
    // Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomConditionImageList.count
    }

    // Cell 디자인
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomConditionImageCell", for: indexPath) as? RoomConditionImageCollectionViewCell else { return RoomConditionImageCollectionViewCell() }
        cell.roomConditionImageView.image = roomConditionImageList[indexPath.row]
        cell.roomConditionImageView.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 8
        return cell
    }
}


// MARK:- "컬렉션뷰 Delegate"
extension CheckOutRequestDetailTableView: UICollectionViewDelegate {

}


// MARK:- "컬렉션뷰 DelegateFlowLayout"
extension CheckOutRequestDetailTableView: UICollectionViewDelegateFlowLayout {
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // 인셋
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

    }

    // Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270, height: 195)
    }
}
