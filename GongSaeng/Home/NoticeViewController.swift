//
//  NoticeViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class NoticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? NoticeCell else {
            return UITableViewCell()
        }
        cell.updateUI()
        return cell
    }
}

extension NoticeViewController: UITableViewDelegate {
    
}

class NoticeCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func updateUI() {
        DispatchQueue.main.async {
            self.dateLabel.text = "어제어제"
            self.titleLabel.text = "긴급 소방점검으로 인해 출입문을 개방하면서 앞으로는 통금에 대한 제한이 없어집니다."
        }
    }
}
