//
//  RequestCheckInViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/15.
//

import UIKit

class RequestCheckInViewController: UIViewController {
    // 임시 [요일, 일자] 리스트
    var dayList: [[String]] = [["월", "17"], ["화", "18"], ["수", "19"], ["목", "20"], ["금", "21"], ["토", "22"], ["일", "23"]]
    // 임시 시간 리스트
    var timeList: [String] = ["12:00", "12:10", "12:20", "12:30", "12:40", "12:50", "13:00", "13:10", "13:20", "13:30"]
    // 임시 선택된 시간 데이터
    var selectedHourValue: Int = 6
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectDateCollectionView: UICollectionView!
    @IBOutlet weak var selectTimeCollectionView: UICollectionView!
    @IBOutlet weak var zeroHourButton: UIButton!
    @IBOutlet weak var sixHourButton: UIButton!
    @IBOutlet weak var twelveHourButton: UIButton!
    @IBOutlet weak var eighteenHourButton: UIButton!
    @IBOutlet weak var zeroHourUnderlinedView: UIView!
    @IBOutlet weak var sixHourUnderlinedView: UIView!
    @IBOutlet weak var twelveHourUnderlinedView: UIView!
    @IBOutlet weak var eighteenHourUnderlinedView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInButton.layer.cornerRadius = 5
        checkInButton.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.9490196078, blue: 0.937254902, alpha: 1)
        
        checkOutButton.layer.cornerRadius = 5
        checkOutButton.layer.borderWidth = 1
        checkOutButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        nextButton.layer.cornerRadius = 8
        
        // 임시 초기 시간 선택 6
        hourButtonTapped(tappedButton: sixHourButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func hourButtonTapped(tappedButton: UIButton) {
        let hourButtonList = [zeroHourButton, sixHourButton, twelveHourButton, eighteenHourButton]
        let hourUnderlinedViewList = [zeroHourUnderlinedView, sixHourUnderlinedView, twelveHourUnderlinedView, eighteenHourUnderlinedView]
        for index in 0..<hourButtonList.count {
            if hourButtonList[index] == tappedButton {
                hourButtonList[index]?.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                hourButtonList[index]?.isEnabled = false
                hourUnderlinedViewList[index]?.alpha = 1
                selectedHourValue = index * 6
                print(selectedHourValue)
            } else {
                hourButtonList[index]?.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1), for: .normal)
                hourButtonList[index]?.isEnabled = true
                hourUnderlinedViewList[index]?.alpha = 0
            }
        }
    }
    
    // 뒤로가기 버튼
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // 퇴실 버튼
    @IBAction func checkOutButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RequestCheckInOut", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RequestCheckOutViewController") as! RequestCheckOutViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    // 0시 버튼
    @IBAction func zeroHourButtonTapped(_ sender: UIButton) {
        hourButtonTapped(tappedButton: sender)
    }
    
    // 6시 버튼
    @IBAction func sixHourButtonTapped(_ sender: UIButton) {
        hourButtonTapped(tappedButton: sender)
    }
    
    // 12시 버튼
    @IBAction func twelveHourButtonTapped(_ sender: UIButton) {
        hourButtonTapped(tappedButton: sender)
    }
    
    // 18시 버튼
    @IBAction func eighteenHourButtonTapped(_ sender: UIButton) {
        hourButtonTapped(tappedButton: sender)
    }
    
    // 다음 버튼
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "CheckInRequestPopUp", bundle: nil)
        let popUpViewController = storyBoard.instantiateViewController(identifier: "CheckInRequestPopUpViewController")
        popUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(popUpViewController, animated: false, completion: nil)
    }
    
}


// MARK:- "컬렉션뷰 클래스 정의"
// 날짜선택 컬렉션뷰 셀
class SelectDateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

// 시간선택 컬렉션뷰 셀
class SelectTimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
}


// MARK:- "컬렉션뷰 DataSource"
extension RequestCheckInViewController: UICollectionViewDataSource {
    // Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case selectDateCollectionView:
            return dayList.count
        case selectTimeCollectionView:
            return timeList.count
        default:
            return 0
        }
    }
    
    // Cell 디자인
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case selectDateCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectDateCell", for: indexPath) as? SelectDateCollectionViewCell else { return SelectDateCollectionViewCell() }
            cell.dayLabel.text = dayList[indexPath.row][0]
            cell.dateLabel.text = dayList[indexPath.row][1]
            cell.layer.cornerRadius = 3
            
            // 특정 셀 임시선택표시
            if indexPath.row == 0 {
                cell.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.9490196078, blue: 0.937254902, alpha: 1)
                cell.dateLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            }
            return cell
        case selectTimeCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectTimeCell", for: indexPath) as? SelectTimeCollectionViewCell else { return SelectTimeCollectionViewCell() }
            cell.timeLabel.text = timeList[indexPath.row]
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}


// MARK:- "컬렉션뷰 Delegate"
extension RequestCheckInViewController: UICollectionViewDelegate {
    
}


// MARK:- "컬렉션뷰 DelegateFlowLayout"
extension RequestCheckInViewController: UICollectionViewDelegateFlowLayout {
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case selectDateCollectionView:
            return 0
        case selectTimeCollectionView:
            return 8
        default:
            return 0
        }
    }
    
    // 인셋
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == selectTimeCollectionView {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets()
    }
    
    // Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case selectDateCollectionView:
            let width = collectionView.frame.width / 7
            return CGSize(width: width, height: 52)
        case selectTimeCollectionView:
            return CGSize(width: 56, height: 36)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
