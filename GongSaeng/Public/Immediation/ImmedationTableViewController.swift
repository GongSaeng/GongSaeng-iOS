//
//  ImmedationTableViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/17.
//

import UIKit

class ImmediationTableViewController: UITableViewController {
    
    var loginUser: User? // 로그인 유저
    let viewModel: PublicViewModel = PublicViewModel()
    
    private lazy var tableFooterView: UIView = {
        let contentView = UIView()
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        contentView.addSubview(seperatorView)
        seperatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
        
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginUser = LoginUser.loginUser
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(observerTime), userInfo: nil, repeats: true)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkToUse" {
            let viewController = segue.destination as? EnterUsageTimeViewController
            if let publicItem = sender as? Public {
                viewController?.selectedPublic = publicItem
            }
        }
    }
    
    @objc func observerTime() { // 30초마다 실행되는 함수
        
    }
}

class UsingImmediationTableViewCell: UITableViewCell {
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var completeUsingButton: UIButton!
    
    func configureUI() {
        imageContentView.layer.cornerRadius = imageContentView.frame.height / 2
        completeUsingButton.layer.cornerRadius = 15.0
    }
    
    @IBAction func didTapUsingButton(_ sender: UIButton) {
//        let storyBoard = UIStoryboard.init(name: "ReservationPopUp", bundle: nil)
//        let popUpViewController = storyBoard.instantiateViewController(identifier: "FinishUsingPopUpViewController") as! FinishUsingPopUpViewController
//        popUpViewController.modalPresentationStyle = .overCurrentContext
//        self.present(popUpViewController, animated: false, completion: nil)
    }
    
}

class ToUseImmediationTableViewCell: UITableViewCell {
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var useButton: UIButton!
    
    func configureUI() {
        imageContentView.layer.cornerRadius = imageContentView.frame.height / 2
        useButton.layer.cornerRadius = 15.0
        useButton.layer.borderWidth = 1.0
        useButton.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
    }
    
    @IBAction func didTapToUseButton(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "checkToUse", sender: viewModel.availablePublics(loginUser: self.loginUser)[indexPath.item])
    }
    
}

// MARK: TableView DataSource, Delegate
extension ImmediationTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = TableHeaderView(title: "사용중")
            return headerView
        case 1:
            let headerView = TableHeaderView(title: "사용하기")
            return headerView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return tableFooterView
        } // 사용중, 사용하기 둘 다 존재할 때만으로 수정해야함
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UsingImmediationTableViewCell", for: indexPath) as! UsingImmediationTableViewCell
            cell.configureUI()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToUseImmediationTableViewCell", for: indexPath) as! ToUseImmediationTableViewCell
            cell.configureUI()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return CGFloat(95.0)
        case 1:
            return CGFloat(82.0)
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 12.0
        }
        return 0
    }
}
