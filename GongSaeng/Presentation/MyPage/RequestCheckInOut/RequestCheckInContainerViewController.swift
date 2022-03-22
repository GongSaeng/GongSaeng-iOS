//
//  RequestCheckInContainerViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/08.
//

import UIKit

class RequestCheckInContainerViewController: UIViewController {
    // 임시 시간 리스트
    var timeList: [String] = ["12:00", "12:10", "12:20", "12:30", "12:40", "12:50", "13:00", "13:10", "13:20", "13:30"]
 
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

extension RequestCheckInContainerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectCheckOutTimeCell", for: indexPath) as? SelectCheckOutTimeCollectionViewCell else { return SelectCheckOutTimeCollectionViewCell() }
        cell.timeLabel?.text = timeList[indexPath.item]
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        return cell
    }
    
}

extension RequestCheckInContainerViewController: UICollectionViewDelegate {
    
}

extension RequestCheckInContainerViewController: UICollectionViewDelegateFlowLayout {
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

// 시간선택 컬렉션뷰 셀
class SelectCheckOutTimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
