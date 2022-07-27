//
//  ThunderList2ViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/14.
//

import UIKit
import RxSwift
import RxCocoa

final class ThunderList2ViewController: UIViewController {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let viewModel: ThunderList2ViewModel
    
    private let reuseIdentifier1 = "AvailableThunderCell"
    private let reuseIdentifier2 = "CompletedThunderCell"
    
    private let topView = ThunderList2TopView()
    private let tableView = ThunderList2TableView(frame: .zero, style: .grouped)
    
    private let writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "write_2"), for: .normal)
        button.tintColor = UIColor(named: "colorPinkishOrange")
        button.backgroundColor = .white
        button.layer.cornerRadius = 55.0 / 2.0
        return button
    }()
    
    // MARK: Lifecycle
    init(viewModel: ThunderList2ViewModel = ThunderList2ViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
        bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    private func attribute() {
        view.backgroundColor = .white
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints {
            $0.width.height.equalTo(55.0)
            $0.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15.0)
        }
    }
}

// MARK: Bind
extension ThunderList2ViewController {
    func bind(_ viewModel: ThunderList2ViewModel) {
        // View -> ViewModel
        topView.bind(viewModel.thunderListTopViewModel)
        tableView.bind(viewModel.thunderListTableViewModel)
        writeButton.rx.tap
            .bind(to: viewModel.writeButtonTapped)
            .disposed(by: disposeBag)
        
        
        // ViewModel -> View
        viewModel.pushWriteView
            .emit(onNext: { [weak self] in
                let viewController = ThunderWriteViewController()
                // + ViewModel 생성
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushLocaleView
            .emit(onNext: { [weak self] region in
                let region = region ?? "서울/서울"
                let regionArr = region.split(separator: "/").map { String($0)}
                let viewModel = Locale2ViewModel(metropolis: regionArr[0], region: regionArr[1])
                let viewController = LocalePopUp2ViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .overCurrentContext
                self?.present(viewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushThunderView
            .drive(onNext: { [weak self] index in
                print("DEBUG: Thunder index -> \(index)")
                self?.tableView.deselectRow(at: IndexPath(index: index), animated: true)
                let viewController = ThunderDetailViewController(index: index)
                viewController.modalPresentationStyle = .fullScreen
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.pushMyThunderView
            .emit(onNext: { [weak self] myThunders in
                print("DEUBG: myThunders -> \(myThunders)")
                let viewController = MyThunderViewController(myThunders: myThunders)
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.delegate = self
                self?.tabBarController?.tabBar.isHidden = true
                self?.present(viewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: UITableViewDelegate
extension ThunderList2ViewController: UITableViewDelegate {
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

// MARK: MyThunderViewControllerDelegate
extension ThunderList2ViewController: MyThunderViewControllerDelegate {
    func showDetailViewController(index: Int) {
        let viewController = ThunderDetailViewController(index: index)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
}
