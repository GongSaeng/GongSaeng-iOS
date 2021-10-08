//
//  ReserveContainerViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/30.
//

import UIKit

class ReserveContainerViewController: UIViewController {
    // 임시 시간 리스트
    var timeList: [String] = ["06:00", "07:00", "08:00", "09:00", "10:00", "11:00"]
    
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
        
        // 임시 초기 시간 선택 6
        hourButtonTapped(tappedButton: sixHourButton)
    }
    
    private func hourButtonTapped(tappedButton: UIButton) {
        let hourButtonList = [zeroHourButton, sixHourButton, twelveHourButton, eighteenHourButton]
        let hourUnderlinedViewList = [zeroHourUnderlinedView, sixHourUnderlinedView, twelveHourUnderlinedView, eighteenHourUnderlinedView]
        for index in 0..<hourButtonList.count {
            if hourButtonList[index] == tappedButton {
                hourButtonList[index]?.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                hourButtonList[index]?.isEnabled = false
                hourUnderlinedViewList[index]?.isHidden = false
            } else {
                hourButtonList[index]?.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1), for: .normal)
                hourButtonList[index]?.isEnabled = true
                hourUnderlinedViewList[index]?.isHidden = true
            }
        }
    }
    
    // cell UI로 체크상태 확인 불가 reusableCell이라 체크상태 데이터를 새로 만들어서 다시 함수작성해야함
    private func testCountOfCheckedCell(collectionView: UICollectionView, indexPath: IndexPath, maxNum: Int) -> Bool {
        // maxNum = 3 이라 가정
        var count = 0
        var firstIndexPath: IndexPath?
//        print("numberOfSections:", collectionView.numberOfItem)
        for item in 0..<collectionView.numberOfItems(inSection: indexPath.section) {
            print(item)
            let index = IndexPath(item: item, section: indexPath.section)
            if collectionView.cellForItem(at: index)?.layer.borderWidth == 0 {
                if count == 0 {
                    firstIndexPath = index
                }
                count += 1
            }
            guard count < maxNum else { return false }
        }
        if count == 0 {
            return true
        } else {
            if let firstIndex = firstIndexPath, (firstIndex.item - indexPath.item == 1) || (indexPath.item - firstIndex.item == count) {
                return true
            } else {
                let storyBoard = UIStoryboard.init(name: "ReservationPopUp", bundle: nil)
                let popUpViewController = storyBoard.instantiateViewController(identifier: "NotCloseCellTappedPopUpViewController") as! NotCloseCellTappedPopUpViewController
                popUpViewController.modalPresentationStyle = .overCurrentContext
                self.present(popUpViewController, animated: false, completion: nil)
            }
        }
        return false
    }
    
    private func cellTapped(collectionView: UICollectionView, indexPath: IndexPath, maxNum: Int) {
        // borderWidth가 0이면 isSelected로 간주
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectReservationTimeCollectionViewCell else { return }
        if cell.layer.borderWidth == 0 {
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.timeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87)
            cell.layer.borderWidth = 1
        } else if cell.layer.borderWidth == 1 {
            guard testCountOfCheckedCell(collectionView: collectionView, indexPath: indexPath, maxNum: maxNum) else { return }
            cell.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.9490196078, blue: 0.937254902, alpha: 1)
            cell.timeLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            cell.layer.borderWidth = 0
        }
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
}

extension ReserveContainerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectReservationTimeCell", for: indexPath) as? SelectReservationTimeCollectionViewCell else { return SelectReservationTimeCollectionViewCell() }
        cell.timeLabel?.text = timeList[indexPath.item]
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        return cell
    }
}

extension ReserveContainerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTapped(collectionView: collectionView, indexPath: indexPath, maxNum: 2)
    }
}

extension ReserveContainerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 36)
    }
}

class SelectReservationTimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
