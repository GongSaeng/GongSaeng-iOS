//
//  RequestCheckOutViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/15.
//

import UIKit

class RequestCheckOutViewController: UIViewController {
    var imageList: [UIImage?] = [UIImage(named: "addPicture.png"), UIImage(named: "profileImage_0"), UIImage(named: "profileImage_1"), UIImage(named: "profileImage_2")]
    
    @IBOutlet weak var cleaningCondtionCollectionView: UICollectionView!
    @IBOutlet weak var roomNumberTextField: UITextField!
    @IBOutlet weak var requestCompleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomNumberTextField.underlined(viewSize: view.bounds.width, color: UIColor.systemGray5)
        requestCompleteButton.layer.cornerRadius = 8
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestCompletedButtonTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "CheckOutCompletedPopUp", bundle: nil)
        let popUpViewController = storyBoard.instantiateViewController(identifier: "CheckOutCompletedPopUpViewController")
        popUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(popUpViewController, animated: false, completion: nil)
    }
    
    
}

// 사진 첨부 컬렉션뷰 셀
class CleaningConditionCheckCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cleaningConditionImage: UIImageView!
    @IBOutlet weak var deleteImageButton: UIButton!
}

// 컬렉션뷰 DataSource 구현
extension RequestCheckOutViewController: UICollectionViewDataSource {
    // Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    // Cell 디자인
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? CleaningConditionCheckCollectionViewCell else { return CleaningConditionCheckCollectionViewCell() }
        cell.cleaningConditionImage?.image = imageList[indexPath.row]
        cell.cleaningConditionImage.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 5
        if indexPath.row == 0 {
            cell.deleteImageButton.isHidden = true
        }
        return cell
    }
}

// 컬렉션뷰 Delegate 구현
extension RequestCheckOutViewController: UICollectionViewDelegate {
    // 사진추가 이미지 탭할 때 imageList에 사용자 이미지 추가

}

// 컬렉션뷰 DelegateFlowLayout 구현
extension RequestCheckOutViewController: UICollectionViewDelegateFlowLayout {
    // InSet
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    // 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    // Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 102, height: 102)
    }
}
