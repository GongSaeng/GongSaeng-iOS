//
//  CommunityViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/29.
//

import UIKit

class CommunityViewController: UIViewController {
    var postDataList: [(String, String, String)] =
    [("자유게시판","자유롭게 소통해요","free_community")
     ,("긴급게시판","바로 해결해야하는 건의사항이 있나요?","emergency_community")
     ,("건의게시판","불편한 일이 생겼다면 건의해보세요!","suggest_community")
     ,("함께게시판","나눔,대여,거래하고 싶은 것이 있나요?","with_community")
     ,("장터게시판","중고거래,공생메이트님들과 해보세요!","buy_community")
     ]
    
    
    var viewcons: [String] =
    ["NoticeListViewController","emergencycommunity","suggestcommunity","withcommunity","marketcommunity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
}

extension CommunityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as? CommunityCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.boardTitleLabel.text = postDataList[indexPath.row].0
        cell.boardIntroduceLabel.text = postDataList[indexPath.row].1
        cell.boardImageView.image = UIImage(named: postDataList[indexPath.row].2)
        
        
        return cell
    }
}

extension CommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 82.0
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "free", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "freeListViewController")
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case 1:
            let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "emergencycommunity")
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case 2:
            let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "suggestcommunity")
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case 3:
            let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "withcommunity")
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case 4:
            let storyboard = UIStoryboard(name: "free", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "freeListViewController")
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        default:
            return
        }
    }
}

class CommunityCell: UITableViewCell {
    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet weak var boardTitleLabel: UILabel!
    @IBOutlet weak var boardIntroduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("DEBUG: Cell height:", self.frame.height)
    }
}
