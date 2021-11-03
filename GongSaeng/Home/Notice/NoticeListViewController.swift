//
//  NoticeListViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/25.
//

import UIKit

class NoticeListViewController: UIViewController {
    
    let colorBlack20: UIColor = UIColor(white: 0, alpha: 0.2)
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var cermonyButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [allButton, noticeButton, cermonyButton, etcButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
            $0?.layer.cornerRadius = 18
        }
        
        // 분류버튼 전체버튼으로 초기화
        classficationButtonTapped(button: allButton)
    }
    
    func classficationButtonTapped(button: UIButton) {
        [allButton, noticeButton, cermonyButton, etcButton].forEach {
            if $0 == button {
                $0?.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
                $0?.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
                $0?.isEnabled = false
            } else {
                $0?.setTitleColor(colorBlack20, for: .normal)
                $0?.layer.borderColor = colorBlack20.cgColor
                $0?.isEnabled = true
            }
        }
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
    
    @IBAction func noticeButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
    
    @IBAction func cermonyButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
    
    @IBAction func etcButtonTapped(_ sender: UIButton) {
        classficationButtonTapped(button: sender)
    }
}

extension NoticeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as? NoticeTableViewCell else { return NoticeTableViewCell() }
        return cell
    }
}

extension NoticeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Notice", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NoticeDetailViewController") as! NoticeDetailViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}

class NoticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var managerImageView: UIImageView!
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        managerImageView.layer.cornerRadius = managerImageView.frame.height / 2
        thumnailImageView.layer.cornerRadius = 4
    }
}
