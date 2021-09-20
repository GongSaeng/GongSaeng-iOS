//
//  CheckOutRequestDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/15.
//

import UIKit

class CheckOutRequestDetailViewController: UIViewController {
    // 임시데이터
    var roomConditionImageList: [UIImage?] = [UIImage(named: "profileImage_0.png"), UIImage(named: "profileImage_1.png"), UIImage(named: "profileImage_2.png"), UIImage(named: "profileImage_3.png")]
    var commentedUserDataList = [(UIImage(named: "profileImage_0.png"), "관리자123", "2시간 전", "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하"), (UIImage(named: "profileImage_1.png"), "김민지", "2시간 전", "네네!"), (UIImage(named: "profileImage_0.png"), "관리자", "1시간 전", "확인됐습니다!")]

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var boundaryPresentingView: UIView!
    @IBOutlet weak var textContanView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var roomConditionCollectionView: UICollectionView!
    @IBOutlet weak var commentCollectionView: UICollectionView!

    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var boundaryPresentingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.roundCornerOfImageView()
        textContanView.layer.cornerRadius = textContanView.frame.height / 2

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        boundaryPresentingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        placeHolderSetting(commentTextView)

    }

    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // 화면터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            UIView.animate(withDuration: animationDuration, animations: { self.boundaryPresentingViewBottomConstraint.constant = keyboardFrame.size.height
                self.view.layoutIfNeeded()
            })

            let scrollContentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
            scrollView.contentInset = scrollContentInset
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height)
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
        scrollView.contentInset = scrollContentInset
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
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

class CommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var commentedUserImageView: UIImageView!
    @IBOutlet weak var commentedUserNicknameLabel: UILabel!
    @IBOutlet weak var commentedTimeLabel: UILabel!
    @IBOutlet weak var commentedTextLabel: UILabel!
    
    @IBOutlet weak var commentedTextLabelWidthConstraint: NSLayoutConstraint!
}


// MARK:- "컬렉션뷰 DataSource"
extension CheckOutRequestDetailViewController: UICollectionViewDataSource {
    // Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case roomConditionCollectionView:
            return roomConditionImageList.count
        case commentCollectionView:
            return commentedUserDataList.count
        default:
            return 0
        }
    }

    // Cell 디자인
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case roomConditionCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomConditionImageCell", for: indexPath) as? RoomConditionImageCollectionViewCell else { return RoomConditionImageCollectionViewCell() }
            cell.roomConditionImageView.image = roomConditionImageList[indexPath.row]
            cell.roomConditionImageView.contentMode = .scaleAspectFill
            cell.layer.cornerRadius = 8
            return cell
        case commentCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as? CommentCollectionViewCell else { return CommentCollectionViewCell() }
            cell.commentedUserImageView.image = commentedUserDataList[indexPath.row].0
            cell.commentedUserImageView.contentMode = .scaleAspectFill
            cell.commentedUserImageView.roundCornerOfImageView()
            
            cell.commentedUserNicknameLabel.text = commentedUserDataList[indexPath.row].1
            cell.commentedUserNicknameLabel.sizeToFit()

            cell.commentedTimeLabel.text = commentedUserDataList[indexPath.row].2
            cell.commentedTimeLabel.sizeToFit()
            
            cell.commentedTextLabel.text = commentedUserDataList[indexPath.row].3
            let newSize = cell.commentedTextLabel.sizeThatFits( CGSize(width: cell.frame.width - 90, height: CGFloat.greatestFiniteMagnitude))
            cell.commentedTextLabelWidthConstraint.constant = newSize.width
            cell.commentedTextLabel.frame.size.height = newSize.height
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}


// MARK:- "컬렉션뷰 Delegate"
extension CheckOutRequestDetailViewController: UICollectionViewDelegate {

}


// MARK:- "컬렉션뷰 DelegateFlowLayout"
extension CheckOutRequestDetailViewController: UICollectionViewDelegateFlowLayout {
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case roomConditionCollectionView:
            return 10
        case commentCollectionView:
            return 1
        default:
            return 0
        }
    }

    // 인셋
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case roomConditionCollectionView:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        case commentCollectionView:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    // Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case roomConditionCollectionView:
            return CGSize(width: 270, height: 195)
        case commentCollectionView:
            let sizingLabel: UILabel
            sizingLabel = UILabel()
            sizingLabel.font = UIFont(name: sizingLabel.font.fontName, size: 14)
            sizingLabel.textAlignment = .left
            sizingLabel.numberOfLines = 0
            sizingLabel.text = commentedUserDataList[indexPath.row].3
            let newSize = sizingLabel.sizeThatFits( CGSize(width: view.frame.width - 90, height: CGFloat.greatestFiniteMagnitude))
            return CGSize(width: view.frame.width, height: newSize.height + 82)
        default:
            return CGSize()
        }
    }
}
