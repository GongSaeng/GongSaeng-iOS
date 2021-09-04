//
//  DepartmentViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/22.
//

import UIKit

class DepartmentViewController: UIViewController {

    let viewModel: DepartmentViewModel = DepartmentViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var departmentTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
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
        viewModel.loadDatas()
    }
    
    @IBAction func backButtonHandler(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonHandler(_ sender: Any) {
        // DepartmentViewModel갖고 가자잉
        if viewModel.isDoneDepartment() {
            performSegue(withIdentifier: "member", sender: viewModel.isDoneName)
        }
    }
}

extension DepartmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        var isSelect: Bool = false
        if viewModel.searchDepartmentOfIndex(at: indexPath.row).isDone {
           // 해재하는 걸 만든다.
            viewModel.searchedDepartments[indexPath.row].isDone = false
        } else {
            // 전부 false인것을 확인했다면 진행
            if viewModel.isDoneDepartment() { return } // print
            isSelect = !viewModel.searchedDepartments[indexPath.row].isDone
            viewModel.searchedDepartments[indexPath.row].isDone = isSelect
        }
        
        if isSelect {
            nextButton.imageView?.image = UIImage(named: "nextButtonFill")
        } else {
            nextButton.imageView?.image = UIImage(named: "nextButton")
        }
        departmentTableView.reloadData()
    }
}

class DepartmentCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    func updateUI(department: Department) {
        DispatchQueue.main.async {
            self.titleLabel.text = department.nameOfDepartment
            self.addressLabel.text = department.addressOfDepartment
            if department.isDone {
                self.checkButton.isSelected = true
                self.checkButton.tintColor = UIColor.systemOrange
            } else {
                self.checkButton.isSelected = false
                self.checkButton.tintColor = UIColor.systemGray
            }
        }
    }
}

extension DepartmentViewController: UISearchBarDelegate {
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 키보드가 올라와 있을때 내려가도록 처리
        dismissKeyboard()
        
        // 검색어가 있는지 확인, optional 안전하게 해제
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
        SearchAPI.search(searchTerm) { (departments) in
            DispatchQueue.main.async {
                self.viewModel.searchedDepartments = departments
                self.departmentTableView.reloadData()
            }
        }
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
