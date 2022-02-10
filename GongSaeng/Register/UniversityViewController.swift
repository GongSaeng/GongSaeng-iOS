//
//  UniversityViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/09.
//

import UIKit

class UniversityViewController: UIViewController {
    
    // MARK: Properties
    var viewModel = UniversityViewModel()
    
    private var selectedIndex: IndexPath?
    
    private var universities = [University]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noResultView: UIView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUniversities()
        searchTextField.addTarget(self, action: #selector(bindText), for: .editingChanged)
        nextButton.layer.cornerRadius = 8
    }
    
    // MARK: API
    private func fetchUniversities() {
        universities = viewModel.searchedUniversities
        viewModel.cellViewModelList = universities.map { UniversityCellViewModel(university: $0) }
    }
    
    // MARK: Actions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        guard searchUniversities() else { return }
    }
    
    private func showNoResultView(_ willShow: Bool) {
        noResultView.isHidden = !willShow
    }
    
    private func activateNextButton(_ shouldActivated: Bool) {
        nextButton.isEnabled = shouldActivated
        nextButton.backgroundColor = shouldActivated ? UIColor(named: "colorBlueGreen") : UIColor(white: 0, alpha: 0.2)
    }
    
    @IBAction func didTapBackwardButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Register", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MemberViewController") as! MemberViewController
        viewController.register = Register(university: viewModel.selectedUniversity)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Helpers
    @objc
    private func bindText(_ sender: UITextField) {
        print("DEBUG: sender.text -> \(sender.text ?? "")")
        viewModel.searchBarText = sender.text ?? ""
    }
    
    private func searchUniversities() -> Bool {
        self.view.endEditing(true)
        guard viewModel.canSearch else { return false }
        viewModel.searchedText = viewModel.searchBarText
        universities = viewModel.searchedUniversities
        viewModel.updateCellViewModels()
        activateNextButton(viewModel.shouldActivateButton)
        return true
    }
}

// MARK: UITextFieldDelegate
extension UniversityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return searchUniversities()
    }
}

// MARK: UITableViewDataSource
extension UniversityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hasNoResult = universities.isEmpty
        showNoResultView(hasNoResult)
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell", for: indexPath) as? UniversityCell else { return UniversityCell() }
        cell.viewModel = viewModel.cellViewModelList[indexPath.row]
        return cell
    }
}

// MARK: UITableViewDelegate
extension UniversityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell", for: indexPath) as? UniversityCell else { return }
        viewModel.didSelectCell(at: indexPath.row)
        cell.viewModel = viewModel.cellViewModelList[indexPath.row]
        let indexPaths = viewModel.changedRowList.map { IndexPath(row: $0, section: 0) }
        tableView.reloadRows(at: indexPaths, with: .fade)
        activateNextButton(viewModel.shouldActivateButton)
    }
}
