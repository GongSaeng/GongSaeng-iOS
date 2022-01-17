//
//  CommunityViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/29.
//

import UIKit

enum CommunityType: Int {
    case gathering = 0
    case market = 1
    case free = 2
    case emergency = 3
    case suggestion = 4
}

class CommunityViewController: UIViewController {
    
    // MARK: Properties
    var user: User?
    
    var postDataList: [(String, String, String)] =
    [("자유게시판","자유롭게 소통해요","free_community")
     ,("긴급게시판","바로 해결해야하는 건의사항이 있나요?","emergency_community")
     ,("건의게시판","불편한 일이 생겼다면 건의해보세요!","suggest_community")
     ,("함께게시판","나눔,대여,거래하고 싶은 것이 있나요?","with_community")
     ,("장터게시판","중고거래,공생메이트님들과 해보세요!","buy_community")
     ]
    
    
//    var viewcons: [String] =
//    ["NoticeListViewController","emergencycommunity","suggestcommunity","withcommunity","marketcommunity"]
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
}

// MARK: UITableViewDataSource
extension CommunityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as? CommunityCell else { return CommunityCell() }
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.boardTitleLabel.text = postDataList[indexPath.row].0
        cell.boardIntroduceLabel.text = postDataList[indexPath.row].1
        cell.boardImageView.image = UIImage(named: postDataList[indexPath.row].2)
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension CommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 83.0
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = user else { return }
        switch indexPath.row {
        case 0: // 자유게시판
            let storyboard = UIStoryboard(name: "free", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "freeListViewController")
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case 1: // 긴급게시판
            let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "emergencycommunity")
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case 2: // 건의게시판
            let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "suggestcommunity")
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case 3: // 함께게시판
            let viewController = GatheringBoardViewController(withUser: user)
            viewController.navigationItem.title = "함께게시판"
            viewController.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
            let backBarButton = UIBarButtonItem(title: "게시판목록", style: .plain, target: self, action: nil)
            backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
            navigationItem.backBarButtonItem = backBarButton
            navigationController?.pushViewController(viewController, animated: true)
            
        case 4: // 장터게시판
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
}
