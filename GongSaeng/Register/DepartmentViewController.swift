//
//  DepartmentViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/22.
//

import UIKit

class DepartmentViewController: UIViewController {

    let viewModel: DepartmentViewModel = DepartmentViewModel()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var departmentTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noResultView: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueway를 수행하기 직전 준비단계에서 데이터를 넘겨주자 를 여기서 작성한다.
        // 즉, perform이 수행되기 직전에 호출되는 함수이다.
        // DetailViewController에게 데이터를 줄 것이다.
        if segue.identifier == "member" {
            let vc = segue.destination as? MemberViewController
            if let department = sender as? String {
                vc?.department = department
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noResultView.isHidden = true
        nextButton.layer.cornerRadius = 8
        viewModel.loadDatas()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
    }
    
    private func searchDepartment(_ textField: UITextField) {
        // 키보드가 올라와 있을때 내려가도록 처리
        textField.resignFirstResponder()
        
        // 검색어가 있는지 확인, optional 안전하게 해제
        guard let searchTerm = textField.text, !searchTerm.isEmpty else { return }
        
        SearchAPI.search(searchTerm) { [weak self] departments in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.viewModel.searchedDepartments = departments
                self.departmentTableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonHandler(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonHandler(_ sender: Any) {
        // DepartmentViewModel갖고 가자잉
        if viewModel.isDoneDepartment() {
            performSegue(withIdentifier: "member", sender: viewModel.isDoneName)
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchDepartment(searchTextField)
    }
}

extension DepartmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numOfSearchDepartment == 0 {
            noResultView.isHidden = false
        } else {
            noResultView.isHidden = true
        }
        return viewModel.numOfSearchDepartment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell", for: indexPath) as? DepartmentCell else {
            return UITableViewCell()
        }
        cell.updateUI(department: viewModel.searchDepartmentOfIndex(at: indexPath.row))
        return cell
    }
}

extension DepartmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.searchDepartmentOfIndex(at: indexPath.row).isDone {
            viewModel.searchedDepartments[indexPath.row].isDone = false
            nextButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        } else {
            nextButton.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
            if viewModel.isDoneDepartment() {
                viewModel.changeIsDoneToFalse()
                guard let index = viewModel.returnIsDoneIndex(), let cell = tableView.cellForRow(at: IndexPath(row: index, section: indexPath.section)) as? DepartmentCell else { return }
                cell.updateUI(department: viewModel.searchDepartmentOfIndex(at: index))
            }
            viewModel.searchedDepartments[indexPath.row].isDone = true
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? DepartmentCell else { return }
        cell.updateUI(department: viewModel.searchDepartmentOfIndex(at: indexPath.row))
    }
}

class DepartmentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    func updateUI(department: Department) {
        DispatchQueue.main.async {
            self.titleLabel.text = department.nameOfDepartment
            self.addressLabel.text = department.addressOfDepartment
            if department.isDone {
                self.checkImage.image = UIImage(named: "departmentOn")
            } else {
                self.checkImage.image = UIImage(named: "departmentOff")
            }
        }
    }
}

extension DepartmentViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        viewModel.loadDatas()
        departmentTableView.reloadData()
        nextButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchDepartment(textField)
        return true
    }
}

class SearchAPI {
    static func search(_ term: String, complete: @escaping ([Department]) -> Void) {
        // firebase에서 데이터를 어떻게 받는가에 따라 검색의 방식이 달라진다.
        let viewModel: DepartmentViewModel = DepartmentViewModel()
        let departments = viewModel.departments
        let searchedDepartments = departments.filter { department in
            department.nameOfDepartment.contains(term) || department.addressOfDepartment.contains(term)
        }
        complete(searchedDepartments)
    }
}
