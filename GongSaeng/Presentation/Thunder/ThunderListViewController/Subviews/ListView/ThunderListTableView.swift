//
//  ThunderList2TableView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ThunderListTableView: UITableView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let reuseIdentifier1 = "AvailableThunderCell"
    private let reuseIdentifier2 = "CompletedThunderCell"
    
//    private let dataSource: RxTableViewSectionedReloadDataSource<ThunderSectionItem>!
    
    // MARK: Lifecycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func attribute() {
        self.register(AvailableThunderCell.self, forCellReuseIdentifier: reuseIdentifier1)
        self.register(CompletedThunderCell.self, forCellReuseIdentifier: reuseIdentifier2)
        self.separatorInset = UIEdgeInsets(top: 0, left: 18.0, bottom: 0, right: 18.0)
        self.rowHeight = 110.0

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 1.0
        }
        
        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .darkGray
        refreshControl?.attributedTitle =  NSAttributedString(string: "당겨서 새로고침")
    }
    
}

extension ThunderListTableView {
    func bind(_ viewModel: ThunderListTableViewModel) {
        refreshControl?.rx.controlEvent(.valueChanged)
            .map { true }
            .bind(to: viewModel.thunderListRefreshNeeded)
            .disposed(by: disposeBag)
        
        viewModel.thunderCellData
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    self.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<ThunderSectionItem> { [weak self] _, tableView, indexPath, data in
            guard let self = self else { return UITableViewCell() }
            if data.validStatus {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier1, for: indexPath) as! AvailableThunderCell
                cell.configure(data: data)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier2, for: indexPath) as! CompletedThunderCell
                cell.configure(data: data)
                cell.selectionStyle = .none
                return cell
            }
        }
        
        viewModel.tableViewItems
            .drive(self.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.rx.itemSelected
            .filter { $0.section == 0 }
            .map { [weak self] indexPath in
                self?.deselectRow(at: indexPath, animated: true)
                return indexPath.row
            }
            .withLatestFrom(viewModel.thunderCellData) { row, viewModels -> Int in
                return viewModels[row].index
            }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
}
