//
//  RequestCheckInOutViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/13.
//

import UIKit

class RequestCheckInOutViewController: UIViewController {
    // 임시 데이터
    var requestInfoList: [(UIImage?, String, String, String, String)] = [(UIImage(named: "check_in.png"), "입실", "4월 17일 12:00", "20.04.17 3:32 신청", "입실 완료"), (UIImage(named: "check_in.png"), "입실", "4월 17일 12:00", "20.04.17 3:32 신청", "입실 완료")]
    
    // 데이터가 없을 때
    //var requestInfoList: [(UIImage?, String, String, String, String)] = []
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var noneOfDetailView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        allButton.layer.cornerRadius = 18
        allButton.layer.borderWidth = 1
        allButton.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        allButton.isEnabled = false
        [checkInButton, checkOutButton].forEach {
            $0?.layer.cornerRadius = 18
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
            $0?.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), for: .normal)
            $0?.isEnabled = true
        }
        
        showOrHideDetail(hasDetail: !requestInfoList.isEmpty)
    }
    
    private func buttonTapped(button: UIButton?) {
        [allButton, checkInButton, checkOutButton].forEach {
            if $0 == button {
                $0?.setTitleColor(#colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1), for: .normal)
                $0?.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
                $0?.isEnabled = false
            } else {
                $0?.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), for: .normal)
                $0?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                $0?.isEnabled = true
            }
        }
    }

    // 테이블뷰의 셀 값 존재하면 noneOFDetailView를 숨김
    private func showOrHideDetail(hasDetail: Bool) {
        if hasDetail {
            noneOfDetailView.isHidden = true
        } else {
            noneOfDetailView.isHidden = false
        }
    }
    
    @IBAction func backwardButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func checkInButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func checkOutButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
        // 임시로 퇴실신청내역 뷰컨트롤러 활성화버튼으로 사용
        let storyboard = UIStoryboard(name: "RequestCheckInOut", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CheckOutRequestDetailViewController") as! CheckOutRequestDetailViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func requestCheckInButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RequestCheckInOut", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RequestCheckInViewController") as! RequestCheckInViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}


// MARK:- "컬렉션뷰 클래스 정의"
class RequestDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var checkStateImage: UIImageView!
    @IBOutlet weak var checkStateLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var requestedTimeLabel: UILabel!
    @IBOutlet weak var requestProgressLabel: UILabel!
}


// MARK:- "컬렉션뷰 DataSource"
extension RequestCheckInOutViewController: UICollectionViewDataSource {
    // Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(requestInfoList.count)
        return requestInfoList.count
    }
    
    // Cell 디자인
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestInfoCell", for: indexPath) as? RequestDetailCollectionViewCell else { return RequestDetailCollectionViewCell() }
        // 임시 데이터 표현
        cell.checkStateImage.image = requestInfoList[indexPath.row].0
        cell.checkStateLabel.text = requestInfoList[indexPath.row].1
        cell.dateTimeLabel.text = requestInfoList[indexPath.row].2
        cell.requestedTimeLabel.text = requestInfoList[indexPath.row].3
        cell.requestProgressLabel.text = requestInfoList[indexPath.row].4
        
        return cell
    }
}


// MARK:- "컬렉션뷰 Delegate"
extension RequestCheckInOutViewController: UICollectionViewDelegate {
    
}


// MARK:- "컬렉션뷰 DelegateFlowLayout"
extension RequestCheckInOutViewController: UICollectionViewDelegateFlowLayout {
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

    // 인셋
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 80)
    }
}
