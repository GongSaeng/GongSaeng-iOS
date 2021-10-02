//
//  UsageHistoryViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/02.
//

import UIKit

class UsageHistoryViewController: UIViewController {
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var immediationButton: UIButton!
    @IBOutlet weak var reservationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSetUp()
    }
    
    private func buttonTapped(button: UIButton) {
        [allButton, immediationButton, reservationButton].forEach {
            if $0 == button {
                let selectedColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
                $0?.isSelected = true
                $0?.isEnabled = false
                $0?.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
                $0?.setTitleColor(selectedColor, for: .normal)
            } else {
                let notSelectedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                $0?.isSelected = false
                $0?.isEnabled = true
                $0?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
                $0?.setTitleColor(notSelectedColor, for: .normal)
            }
        }
    }
    
    private func buttonSetUp() {
        [allButton, immediationButton, reservationButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            $0?.layer.cornerRadius = 17
        }
        buttonTapped(button: allButton)
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func allButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func immediationButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
    
    @IBAction func reservationButtonTapped(_ sender: UIButton) {
        buttonTapped(button: sender)
    }
}

extension UsageHistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsageDetailCollectionViewCell", for: indexPath) as? UsageDetailCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension UsageHistoryViewController: UICollectionViewDelegate {
    
}

extension UsageHistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return CGSize(width: width, height: 118)
    }
}

class UsageDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var kindOfUsingWayLabel: UILabel!
    @IBOutlet weak var targetUsedLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var stateOfUsageLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
