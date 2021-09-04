//
//  MateDetailTableViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/08.
//

import UIKit

class MateDetailTableViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // select default index 0
    }
    
    @IBAction func segmentedControlPressed(_ sender: Any) {
        self.tableView.reloadData()
    }
}

extension MateDetailTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 작성 글, 작성 댓글이 완성되지 않은 상태에서 데이터를 들고오는 것은 무리라 판단.
        // 글, 댓글의 ViewModel이 만들어 지면 user name을 작성자로 저장된 글을 filtering하여 데이터를 가져와서 띄우도록 하자.
        return UITableViewCell()
    }
}

extension MateDetailTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("몇번째 클릭? \(indexPath.row)")
    }
}
