//
//  ThunderListViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/14.
//

import UIKit
import SnapKit

final class ThunderListViewController: UIViewController {
    
    // MARK: Properties
    private let reuseIdentifier1 = "AvailableThunderCell"
    private let reuseIdentifier2 = "CompletedThunderCell"
    
    private var availableThunders: [Thunder] = [
        Thunder(index: 0, validStatus: 1, title: "간단하게 맥주마셔요~", thumbnailImageName: TEST_IMAGE1_URL, meetingTime: "2022-03-05 17:00:00", placeName: "온천천", remainingNum: 3, totalNum: 4),
        Thunder(index: 0, validStatus: 1, title: "같이 코노가요!", thumbnailImageName: TEST_IMAGE2_URL, meetingTime: "2022-03-06 17:30:00", placeName: "동전노래연습장", remainingNum: 2, totalNum: 4),
        Thunder(index: 0, validStatus: 1, title: "보드게임 할 사람~~", thumbnailImageName: TEST_IMAGE3_URL, meetingTime: "2022-03-07 18:00:00", placeName: "두기보드게임", remainingNum: 4, totalNum: 6),
        Thunder(index: 0, validStatus: 1, title: "간단하게 맥주마셔요~", thumbnailImageName: TEST_IMAGE1_URL, meetingTime: "2022-03-08 17:00:00", placeName: "온천천", remainingNum: 3, totalNum: 4),
        Thunder(index: 0, validStatus: 1, title: "같이 코노가요!", thumbnailImageName: TEST_IMAGE2_URL, meetingTime: "2022-03-09 17:30:00", placeName: "동전노래연습장", remainingNum: 2, totalNum: 4),
        Thunder(index: 0, validStatus: 1, title: "보드게임 할 사람~~", thumbnailImageName: TEST_IMAGE3_URL, meetingTime: "2022-03-10 18:00:00", placeName: "두기보드게임", remainingNum: 4, totalNum: 6)
    ]
    
    private var completedThunders: [Thunder] = [
        Thunder(index: 0, validStatus: 0, title: "간단하게 맥주마셔요~", thumbnailImageName: TEST_IMAGE1_URL, meetingTime: "2022-02-23 17:00:00", placeName: "온천천", remainingNum: 0, totalNum: 4),
        Thunder(index: 0, validStatus: 0, title: "같이 코노가요!", thumbnailImageName: TEST_IMAGE2_URL, meetingTime: "2022-02-24 17:30:00", placeName: "동전노래연습장", remainingNum: 0, totalNum: 4),
        Thunder(index: 0, validStatus: 0, title: "보드게임 할 사람~~", thumbnailImageName: TEST_IMAGE3_URL, meetingTime: "2022-02-25 18:00:00", placeName: "두기보드게임", remainingNum: 0, totalNum: 6),
        Thunder(index: 0, validStatus: 0, title: "간단하게 맥주마셔요~", thumbnailImageName: TEST_IMAGE1_URL, meetingTime: "2022-02-23 17:00:00", placeName: "온천천", remainingNum: 0, totalNum: 4),
        Thunder(index: 0, validStatus: 0, title: "같이 코노가요!", thumbnailImageName: TEST_IMAGE2_URL, meetingTime: "2022-02-24 17:30:00", placeName: "동전노래연습장", remainingNum: 0, totalNum: 4),
        Thunder(index: 0, validStatus: 0, title: "보드게임 할 사람~~", thumbnailImageName: TEST_IMAGE3_URL, meetingTime: "2022-02-25 18:00:00", placeName: "두기보드게임", remainingNum: 0, totalNum: 6)
    ]
    
    private lazy var topView: ThunderListTopView = {
        let topView = ThunderListTopView()
        topView.delegate = self
        return topView
    }()
    
    private lazy var writeButton: UIButton = {
        let button = UIButton(type: .system)
        let imageView = UIImageView(image: UIImage(named: "write_1"))
        button.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(1.0)
            $0.centerY.equalToSuperview().offset(-1.0)
            $0.width.height.equalTo(25.0)
        }
        button.backgroundColor = UIColor(named: "colorPinkishOrange")
        button.layer.cornerRadius = 55.0 / 2.0
        button.addTarget(self, action: #selector(DidTapWriteButton), for: .touchUpInside)
        return button
    }()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureTableView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Actions
    @objc
    private func DidTapWriteButton() {
        let viewController = ThunderWriteViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helpers
    private func configureTableView() {
        tableView.register(AvailableThunderCell.self, forCellReuseIdentifier: reuseIdentifier1)
        tableView.register(CompletedThunderCell.self, forCellReuseIdentifier: reuseIdentifier2)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18.0, bottom: 0, right: 18.0)

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 1.0
        }
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        [topView, tableView, writeButton]
            .forEach { view.addSubview($0) }
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100.0)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        writeButton.snp.makeConstraints {
            $0.width.height.equalTo(55.0)
            $0.trailing.bottom.equalToSuperview().inset(35.0)
        }
    }
}

// MARK: LocalePopUpViewControllerDelegate
extension ThunderListViewController: LocalePopUpViewControllerDelegate {
    func updateTableView() {
        topView.updateLocale()
        tableView.reloadData()
    }
}

// MARK: ThunderListTopViewDelegate
extension ThunderListViewController: ThunderListTopViewDelegate {
    func localeSelectionHandler() {
        let viewController = LocalePopUpViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension ThunderListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return availableThunders.count
        case 1:
            return completedThunders.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier1, for: indexPath) as? AvailableThunderCell else { return AvailableThunderCell() }
            let thunder = availableThunders[indexPath.row]
            cell.viewModel = ThunderListCellViewModel(thunder: thunder)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as? CompletedThunderCell else { return CompletedThunderCell() }
            let thunder = completedThunders[indexPath.row]
            cell.viewModel = ThunderListCellViewModel(thunder: thunder)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: UITableViewDelegate
extension ThunderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let viewController = ThunderDetailViewController(index: 35)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
}
