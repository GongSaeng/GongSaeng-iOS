//
//  ReservationViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/16.
//

import UIKit

class ReservationViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loginUser: User?
    let viewModel: ReservationViewModel = ReservationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = UserDefaults.standard.object(forKey: "loginUser") as? Data, let user = try? PropertyListDecoder().decode(User.self, from: data) else { return }
        self.loginUser = user
        
        collectionView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }
}

extension ReservationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.usingPublics(loginUser: self.loginUser).count
        case 1:
            return viewModel.toUsePublics(loginUser: self.loginUser).count
        case 2:
            return viewModel.availablePublics(loginUser: self.loginUser).count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationCell", for: indexPath) as? ReservationCell else { return ReservationCell() }
        
        cell.delegate = self
        
        var item: Public
        switch indexPath.section {
        case 0:
            item = viewModel.usingPublics(loginUser: self.loginUser)[indexPath.item]
        case 1:
            item = viewModel.toUsePublics(loginUser: self.loginUser)[indexPath.item]
        case 2:
            item = viewModel.availablePublics(loginUser: self.loginUser)[indexPath.item]
        default:
            return cell
        }
        
        cell.updateUI(at: item, loginUser: self.loginUser)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReservationHeaderView", for: indexPath) as? ReservationHeaderView else { return ReservationHeaderView() }
            
            guard let section = ReservationViewModel.Section(rawValue: indexPath.section) else { return UICollectionReusableView() }
            
            header.updateUI(sectionTitleString: section.title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension ReservationViewController: UICollectionViewDelegate {
    //
}

extension ReservationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.view.bounds.width
        let height: CGFloat
        switch indexPath.section {
        case 0:
            height = CGFloat(82)
        case 1:
            height = CGFloat(82)
        case 2:
            height = CGFloat(74)
        default:
            height = CGFloat(0)
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = self.view.bounds.width
        let height: CGFloat = CGFloat(68)
        switch section {
        case 0:
            guard viewModel.usingPublics(loginUser: self.loginUser).count != 0 else { return CGSize()
            }
        case 1:
            guard viewModel.toUsePublics(loginUser: self.loginUser).count != 0 else { return CGSize() }
        case 2:
            guard viewModel.availablePublics(loginUser: self.loginUser).count != 0 else { return CGSize() }
        default:
            return CGSize()
        }
        return CGSize(width: width, height: height)
    }
}

extension ReservationViewController: ReservationCellDelegate {
    func reservationCell(_ reservationCell: ReservationCell) {
        guard let buttonName = reservationCell.button.titleLabel?.text else { return }
        switch buttonName {
        case "사용완료":
            let storyBoard = UIStoryboard.init(name: "ReservationPopUp", bundle: nil)
            let popUpViewController = storyBoard.instantiateViewController(identifier: "FinishUsingPopUpViewController") as! FinishUsingPopUpViewController
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
            
        case "예약취소":
            let storyBoard = UIStoryboard.init(name: "ReservationPopUp", bundle: nil)
            let popUpViewController = storyBoard.instantiateViewController(identifier: "CancelReservationPopUpViewController") as! CancelReservationPopUpViewController
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
            
        case "예약하기":
            let storyboard = UIStoryboard(name: "Reserve", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ReserveViewController") as! ReserveViewController
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        default:
            return
        }
    }
}

class ReservationCell: UICollectionViewCell {
    @IBOutlet weak var imgBackgroundView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finalTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var reservedTimeLabel: UILabel!
    
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBackgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopSpaceConstraint: NSLayoutConstraint!
    
    weak var delegate: ReservationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func updateUI(at index: Public, loginUser: User?) {
        DispatchQueue.main.async {
            // 사용중
            if index.isDone == true && index.usingUser == loginUser?.id && "2021-7-16 17:00:00" >= (index.startTime ?? "0000-0-00 00:00:00") {
                self.imgBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.imgHeightConstraint.constant = 32
                self.imgBackgroundHeightConstraint.constant = 72
                self.reservedTimeLabel.isHidden = true
            }
            // 예약 내역
            if index.isDone == true && index.usingUser == loginUser?.id && "2021-7-16 17:00:00" < (index.startTime ?? "0000-0-00 00:00:00") {
                self.imgBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.imgBackgroundView.layer.borderWidth = 7
                self.imgBackgroundView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
                self.imgHeightConstraint.constant = 32
                self.imgBackgroundHeightConstraint.constant = 72
                self.finalTimeLabel.isHidden = true
                self.leftTimeLabel.isHidden = true
                
                self.button.setTitle("예약취소", for: .normal)
                self.button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.button.layer.borderWidth = 1
                self.button.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
                self.button.setTitleColor(UIColor(red: 17.0 / 255.0, green: 103.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0), for: .normal)
            }
            // 예약하기
            if !(index.isDone == true && index.usingUser == loginUser?.id) {
                self.imgBackgroundView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
                self.imgHeightConstraint.constant = 24
                self.imgBackgroundHeightConstraint.constant = 50
                self.titleLabel.font = UIFont(name: self.titleLabel.font.fontName, size: 14)
                self.titleLabelTopSpaceConstraint.constant = 25
                self.finalTimeLabel.isHidden = true
                self.leftTimeLabel.isHidden = true
                self.reservedTimeLabel.isHidden = true
                self.button.setTitle("예약하기", for: .normal)
                self.button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.button.layer.borderWidth = 1
                self.button.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
                self.button.setTitleColor(UIColor(red: 17.0 / 255.0, green: 103.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0), for: .normal)
            }
            
            self.imgBackgroundView.layer.cornerRadius = self.imgBackgroundHeightConstraint.constant / 2
            self.button.layer.cornerRadius = 15
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let _ = delegate else { return }
        self.delegate?.reservationCell(self)
    }
}

class ReservationHeaderView: UICollectionReusableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(sectionTitleString: String) {
        DispatchQueue.main.async {
            self.sectionTitleLabel.text = sectionTitleString
        }
    }
}

protocol ReservationCellDelegate: AnyObject {
    func reservationCell(_ reservationCell: ReservationCell)
}
