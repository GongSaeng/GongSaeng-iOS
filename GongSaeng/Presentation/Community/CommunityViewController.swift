//
//  CommunityViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/29.
//

import UIKit

enum CommunityType: Int {
    case free = 0, emergency, suggestion, gathering, market
}

class CommunityViewController: UIViewController {
    
    // MARK: Properties
    var user: User?
    
    var postDictionary: [[String: String]] = [
        ["title": "자유게시판", "introduction": "자유롭게 소통해요", "imageName": "free_community"],
        ["title": "고민게시판", "introduction": "혼자 고민하지 말아요", "imageName": "emergency_community"],
        ["title": "맛집게시판", "introduction": "우리나라 맛집을 알아 보아요", "imageName": "suggest_community"],
        ["title": "챌린지게시판", "introduction": "함께할 챌린지 팀원을 모집해보세요", "imageName": "with_community"],
        ["title": "장터게시판", "introduction": "중고거래,공생메이트님들과 해보세요", "imageName": "buy_community"]
    ]
    
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
        return postDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as? CommunityCell else { return CommunityCell() }
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.boardTitleLabel.text = postDictionary[indexPath.row]["title"]
        cell.boardIntroduceLabel.text = postDictionary[indexPath.row]["introduction"]
        cell.boardImageView.image = UIImage(named: postDictionary[indexPath.row]["imageName"]!)
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
        guard let user = user, let communityType = CommunityType(rawValue: indexPath.row) else { return }
        let viewController = BoardListViewController(withUser: user, communityType: communityType)
        viewController.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        let backBarButton = UIBarButtonItem(title: "게시판목록", style: .plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.pushViewController(viewController, animated: true)
    }
}

class CommunityCell: UITableViewCell {
    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet weak var boardTitleLabel: UILabel!
    @IBOutlet weak var boardIntroduceLabel: UILabel!
}
