//
//  ReservateViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/09/30.
//

import UIKit

class ReserveViewController: UIViewController {
    // 임시 [요일, 일자] 리스트
    var dayList: [[String]] = [["월", "17"], ["화", "18"], ["수", "19"], ["목", "20"], ["금", "21"], ["토", "22"], ["일", "23"]]
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    private lazy var reserveContainerViewController: ReserveContainerViewController = {
        let storyboard = UIStoryboard(name: "Reserve", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ReserveContainerViewController") as! ReserveContainerViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "ReservationPopUp", bundle: nil)
        let popUpViewController = storyBoard.instantiateViewController(identifier: "ConfirmReservationPopUpViewController") as! ConfirmReservationPopUpViewController
        popUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(popUpViewController, animated: false, completion: nil)
    }
}

extension ReserveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectReservationDateCell", for: indexPath) as? SelectReservationDateCollectionViewCell else { return SelectReservationDateCollectionViewCell() }
        cell.dayLabel.text = dayList[indexPath.row][0]
        cell.dateLabel.text = dayList[indexPath.row][1]
        cell.layer.cornerRadius = 5
        
        return cell
    }
}

extension ReserveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.containerView.subviews.count == 0 {
            add(asChildViewController: reserveContainerViewController)
        }
        
        collectionView.indexPathsForVisibleItems.forEach {
            if $0 == indexPath {
                guard let cell = collectionView.cellForItem(at: $0) as? SelectReservationDateCollectionViewCell else { return }
                cell.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.9490196078, blue: 0.937254902, alpha: 1)
                cell.dateLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            } else {
                guard let cell = collectionView.cellForItem(at: $0) as? SelectReservationDateCollectionViewCell else { return }
                cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.dateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87)
            }
        }
    }
}

extension ReserveViewController: UICollectionViewDelegateFlowLayout {
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

class SelectReservationDateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
