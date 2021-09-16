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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.roundCornerOfImageView()
        commentTextField.layer.cornerRadius = 22
        commentTextField.addLeftPadding(paddingWidth: 20)
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK:- "컬렉션뷰 클래스 정의"
class RoomConditionImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roomConditionImageView: UIImageView!
}


// MARK:- "컬렉션뷰 DataSource"
extension CheckOutRequestDetailViewController: UICollectionViewDataSource {
    // Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomConditionImageList.count
    }
    
    // Cell 디자인
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomConditionImageCell", for: indexPath) as? RoomConditionImageCollectionViewCell else { return RoomConditionImageCollectionViewCell() }
        cell.roomConditionImageView.image = roomConditionImageList[indexPath.row]
        cell.roomConditionImageView.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 5
        return cell
    }
}


// MARK:- "컬렉션뷰 Delegate"
extension CheckOutRequestDetailViewController: UICollectionViewDelegate {
    
}


// MARK:- "컬렉션뷰 DelegateFlowLayout"
extension CheckOutRequestDetailViewController: UICollectionViewDelegateFlowLayout {
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
