//
//  GatheringBoardViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit
import SnapKit

final class GatheringBoardViewController: UITableViewController {
    
    // MARK: Properties
    private let reuseIdentifier = "GatheringBoardCell"
    let gatherings = [Gathering(index: "0", gatheringStatus: "true", title: "오늘 저녁 같이 시키실분?", contents: "배달음식 같이 시켜서 나누실분 구합니다.\n배송비 아껴요~", writerImageUrl: "10", writerNickname: "함께러버공", uploadedTime: "4분 전", numberOfComments: "0", postingImagesUrl: nil),
                      Gathering(index: "1", gatheringStatus: "false", title: "저녁에 떡볶이 같이 드실분??", contents: "엽떡 시킬건데 떡볶이 혼자 다 먹기 힘들어서.. 같이 드실분 구합니다~ 엽떡 3단계 이상으로 주문하고 싶어서 매운거 잘 드시는 분이면 좋겠어요!ㅎㅎ 사이드도 협의 후에 시킬 예정입니다~ 부담없이 댓글남겨주세요! 최대 4명까지만 선착순으로 구하겠습니다~", writerImageUrl: "35", writerNickname: "떡볶이가좋아", uploadedTime: "1시간 전", numberOfComments: "5", postingImagesUrl: ["10"]),
                      Gathering(index: "0", gatheringStatus: "true", title: "오늘 저녁 같이 시키실분?", contents: "배달음식 같이 시켜서 나누실분 구합니다. 배송비 아껴요~", writerImageUrl: "10", writerNickname: "함께러버공", uploadedTime: "4분 전", numberOfComments: "0", postingImagesUrl: ["10", "10"]),
                      Gathering(index: "1", gatheringStatus: "false", title: "저녁에 떡볶이 같이 드실분??", contents: "떡볶이 혼자 다 먹기 힘들어서 같이 드실분 구합니다. 매운거 잘 드시는 분이면 좋겠어요!ㅎㅎ 부담없이 댓글...", writerImageUrl: "35", writerNickname: "떡볶이가좋아", uploadedTime: "1시간 전", numberOfComments: "5", postingImagesUrl: nil)]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigationBar()
        layout()
    }
    
    // MARK: Actions
    @objc func didTapCompleteButton() {
        print("DEBUG: Did tap completeButton..")
    }
    
    // MARK: Helpers
    private func configureTableView() {
        tableView.register(GatheringBoardCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "write"), style: .plain, target: self, action: #selector(didTapCompleteButton))
    }
    
    private func layout() { }
    
}

// MARK: UITableViewDataSource
extension GatheringBoardViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gatherings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? GatheringBoardCell else { return UITableViewCell() }
        cell.viewModel = GatheringBoardCellViewModel(gathering: gatherings[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: UITableViewDelegate
extension GatheringBoardViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = GatheringBoardDetailViewController()
        viewController.navigationItem.title = "함께게시판"
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        let backBarButton = UIBarButtonItem(title: "목록", style: UIBarButtonItem.Style.plain, target: self, action: nil)
//            backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
        viewController.navigationItem.backBarButtonItem = backBarButton
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
