//
//  MyProfileAndWriting.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/12.
//

import UIKit

class MyProfileAndWritingViewController: UIViewController {
    // 임시 데이터
    var postDataList: [(String, String, String, String)] = [("온천천 러닝 같이 뛰실분 구합니다.", "함께게시판", "04/25 13:05", "3"), ("BBQ 치킨 키프티콘 판매합니다.", "장터게시판", "03/24 18:53", "1"), ("20X호 새벽 2시에 너무 시끄럽습니다.", "자유게시판", "02/12 02:12", "18"), ("온천천 러닝 같이 뛰실분 구합니다.", "함께게시판", "04/25 13:05", "3"), ("BBQ 치킨 키프티콘 판매합니다.", "장터게시판", "03/24 18:53", "1"), ("20X호 새벽 2시에 너무 시끄럽습니다.", "자유게시판", "02/12 02:12", "18")]
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var introductionLabel: UITextView!
    @IBOutlet weak var writtenTextButton: UIButton!
    @IBOutlet weak var writtrnCommentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.roundCornerOfImageView()
        
        writtenTextButton.isEnabled = false
        inactivateButton(button: writtrnCommentButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func activateButton(button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87), for: .normal)
    }
    
    private func inactivateButton(button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), for: .normal)
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func writtenTextButtonTapped(_ sender: UIButton) {
        activateButton(button: writtenTextButton)
        inactivateButton(button: writtrnCommentButton)
        viewWillAppear(true)
    }
    
    @IBAction func writtenCommentButtonTapped(_ sender: UIButton) {
        activateButton(button: writtrnCommentButton)
        inactivateButton(button: writtenTextButton)
        viewWillAppear(true)
    }
    
}

class writtenContentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleOfPostLabel: UILabel!
    @IBOutlet weak var typeOfBoardLabel: UILabel!
    @IBOutlet weak var timeOfPostLabel: UILabel!
    @IBOutlet weak var numberOfCommentLabel: UILabel!
}

// 컬렉션뷰 DataSource 구현
extension MyProfileAndWritingViewController: UICollectionViewDataSource {
    // Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDataList.count
    }
    
    // Cell 디자인
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "writtenCommentCell", for: indexPath) as? writtenContentCollectionViewCell else { return writtenContentCollectionViewCell() }
        cell.titleOfPostLabel?.text = postDataList[indexPath.row].0
        cell.typeOfBoardLabel?.text = postDataList[indexPath.row].1
        cell.timeOfPostLabel?.text = postDataList[indexPath.row].2
        cell.numberOfCommentLabel?.text = postDataList[indexPath.row].3
        return cell
    }
}

// 컬렉션뷰 Delegate 구현
extension MyProfileAndWritingViewController: UICollectionViewDelegate {
}

// 컬렉션뷰 DelegateFlowLayout 구현
extension MyProfileAndWritingViewController: UICollectionViewDelegateFlowLayout {
    // InSet
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
    // 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(24)
    }
    
    // Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 43)
    }
}




