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
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    private lazy var requestCheckInContainerViewController: RequestCheckInContainerViewController = {
        let storyboard = UIStoryboard(name: "RequestCheckInOut", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "RequestCheckInContainerViewController") as! RequestCheckInContainerViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [checkInButton, checkOutButton].forEach {
            $0?.layer.cornerRadius = 5
            $0?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        }
        
        didTapCheckInOutButton(checkInButton)
        nextButton.layer.cornerRadius = 8
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        self.addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func didTapCheckInOutButton(_ button: UIButton) {
        [checkInButton, checkOutButton].forEach {
                if $0 == button {
                    $0?.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
                    $0?.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.9490196078, blue: 0.937254902, alpha: 1)
                    $0?.layer.borderWidth = 0
                    $0?.isEnabled = false
                    $0?.isSelected = true
                } else {
                    $0?.setTitleColor(UIColor(white: 0, alpha: 0.8), for: .normal)
                    $0?.backgroundColor = .white
                    $0?.layer.borderWidth = 1.0
                    $0?.isEnabled = true
                    $0?.isSelected = false
                }
        }
    }
        
    // 뒤로가기 버튼
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // 입실 버튼
    @IBAction func checkInButtonTapped(_ sender: UIButton) {
        didTapCheckInOutButton(sender)
    }
    
    
    // 퇴실 버튼
    @IBAction func checkOutButtonTapped(_ sender: UIButton) {
        didTapCheckInOutButton(sender)
    }
    
    // 다음 버튼
    @IBAction func nextButtonTapped(_ sender: UIButton) {
//        switch
        if checkInButton.isSelected {
            let storyBoard = UIStoryboard.init(name: "CheckInRequestPopUp", bundle: nil)
            let popUpViewController = storyBoard.instantiateViewController(identifier: "CheckInRequestPopUpViewController")
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
        } else if checkOutButton.isSelected {
            let storyboard = UIStoryboard(name: "RequestCheckInOut", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RequestCheckOutViewController") as! RequestCheckOutViewController
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
        
        
        
    }
    
}

// MARK:- "컬렉션뷰 DataSource"
extension RequestCheckInViewController: UICollectionViewDataSource {
    // Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayList.count
    }
    
    // Cell 디자인
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectDateCell", for: indexPath) as? SelectDateCollectionViewCell else { return SelectDateCollectionViewCell() }
        cell.dayLabel.text = dayList[indexPath.row][0]
        cell.dateLabel.text = dayList[indexPath.row][1]
        cell.layer.cornerRadius = 5
    
        return cell
    }
}


// MARK:- "컬렉션뷰 Delegate"
extension RequestCheckInViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.containerView.subviews.count == 0 {
            add(asChildViewController: requestCheckInContainerViewController)
        }
        
        collectionView.indexPathsForVisibleItems.forEach {
            if $0 == indexPath {
                guard let cell = collectionView.cellForItem(at: $0) as? SelectDateCollectionViewCell  else { return }
                cell.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.9490196078, blue: 0.937254902, alpha: 1)
                cell.dateLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            } else {
                guard let cell = collectionView.cellForItem(at: $0) as? SelectDateCollectionViewCell else { return }
                cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.dateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87)
            }
        }
    }
    
}


// MARK:- "컬렉션뷰 DelegateFlowLayout"
extension RequestCheckInViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 34) / 7
        return CGSize(width: width, height: 52)
    }
}

// MARK:- "컬렉션뷰 클래스 정의"
// 날짜선택 컬렉션뷰 셀
class SelectDateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
