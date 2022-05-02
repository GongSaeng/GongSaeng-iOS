//
//  ThunderDetail2ViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ThunderDetail2ViewController: UIViewController {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let navigationView = ThunderDetail2NavigationView()
    
    private let tableView = UITableView()
    private let headerView = ThunderDetail2HeaderView()
    
    private let commentInputView = CommentInputView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55.0))
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    // MARK: Gesture
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        view.endEditing(true)
    }
    
    // MARK: Helpers
    private func attribute() {
        view.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
//        tableView.showsVerticalScrollIndicator = false
    }
    
    private func layout() {
        [tableView, navigationView, commentInputView]
            .forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40.0)
        }

        commentInputView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: Bind
extension ThunderDetail2ViewController {
    func bind(_ viewModel: ThunderDetail2ViewModel) {
        navigationView.bind(viewModel.thunderListNavigationViewModel)
        viewModel.pop
            .emit { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        headerView.bind(viewModel.thunderListHeaderViewModel)
        
        //----
//        RxKeyboard.instance.visibleHeight
//            .drive(viewModel.keyboardHeight)
//            .disposed(by: disposeBag)
//
//        viewModel.keyboardHeight
//            .skip(1)
//            .map { $0 != 0 ? bottomPadding - $0 : 0 }
//            .asDriver(onErrorJustReturn: 0)
//            .drive(onNext: { [weak self] offset in
//                print("DEBUG: dfasdfsf")
//                guard let self = self else { return }
//                UIView.animate(withDuration: 0.25) {
//                    self.commentInputView.snp.updateConstraints {
//                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(offset)
//                    }
//                    self.tableView.contentOffset.y -= offset
//                    self.view.layoutIfNeeded()
//                }
//                print("DEBUG: keyboardHeight -> \(offset)")
//            })
//            .disposed(by: disposeBag)
        
        //-------
        
        
        
        
        
//        tableView.rx.contentOffset
//            .map { $0.y }
//            .bind(onNext: { print($0) })
//            .disposed(by: disposeBag)
        
//        RxKeyboard.instance.visibleHeight
//                 .drive(onNext: { [weak self] keyboardVisibleHeight in
//                     guard let self = self else { return }
//                     let offset = (keyboardVisibleHeight != 0) ? bottomPadding - keyboardVisibleHeight : 0
//                     UIView.animate(withDuration: 0.25) {
//                         self.commentInputView.snp.updateConstraints {
//                             $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(offset)
//                         }
//                         self.view.layoutIfNeeded()
//                     }
//                     print("DEBUG: keyboardHeight -> \(keyboardVisibleHeight)")
//                 })
//                 .disposed(by: disposeBag)
    }
}
