//
//  SearchPlaceViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/07.
//

import UIKit
import SnapKit
import SwiftUI

protocol SearchPlaceViewControllerDelegate: AnyObject {
    func setPlace(placeDocument: PlaceDocument)
}

final class SearchPlaceViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: SearchPlaceViewControllerDelegate?
    
    private let reuseIdentifier: String = "PlaceListCell"
    private var searchedPlace: String = ""
    private var placeList: [PlaceDocument] = []
    private var fetchedPageList = [Int]()
    private var currentPage = 1
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("검색", for: .normal)
        button.setAttributedTitle(
            NSAttributedString(string: "검색",
                               attributes: [
                                .font: UIFont.systemFont(ofSize: 16.0,
                                                         weight: .semibold),
                                .foregroundColor: UIColor(named: "colorBlueGreen")!.cgColor
                               ]),
            for: .normal)
        button.addTarget(self, action: #selector(searchButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        configureTableView()
    }
    
    // MARK: API
    private func fetchPlaceList(of page: Int, query: String) {
        guard fetchedPageList.firstIndex(of: currentPage) == nil else { return }
        fetchedPageList.append(page)
        SearchPlaceNetwork.searchPlace(of: page, query: query) { [weak self] place in
            guard let self = self else { return }
            self.searchedPlace = query
            self.placeList += place.documents
            self.currentPage += 1
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Actions
    @objc
    private func searchButtonHandler(_ sender: UISearchBar) {
        guard let query = searchBar.searchTextField.text, !query.isEmpty, searchedPlace != query else { return }
        currentPage = 1
        placeList = []
        fetchedPageList = []
        fetchPlaceList(of: 1, query: query)
        sender.endEditing(true)
    }
    
    // MARK: Helpers
    private func configureTableView() {
        tableView.register(PlaceListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18.0, bottom: 0, right: 18.0)
    }
    
    private func attribute() {
        title = "장소 검색"
        view.backgroundColor = .white
        searchBar.delegate = self
        searchBar.searchTextField.placeholder = "장소를 입력해주세요."
        tableView.keyboardDismissMode = .interactive
    }
    
    private func layout() {
        searchBar.addSubview(searchButton)
        searchBar.searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12.0)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12.0)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12.0)
        }
        
        [searchBar, tableView].forEach { view.addSubview($0) }
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: UITableView DataSource
extension SearchPlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PlaceListCell else { return PlaceListCell() }
        cell.viewModel = PlaceListCellViewModel(placeDocument: placeList[indexPath.row])
        return cell
    }
}

// MARK: UITableView DataSourcePrefetching
extension SearchPlaceViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            if ($0.row + 1) / 15 + 1 == currentPage { // 15개씩 불러올 때 숫자 값
                self.fetchPlaceList(of: currentPage, query: searchedPlace)
            }
        }
    }
}

// MARK: UITableView Delegate
extension SearchPlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setPlace(placeDocument: placeList[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UISearchBar Delegate
extension SearchPlaceViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchButtonHandler(searchBar)
    }
}
