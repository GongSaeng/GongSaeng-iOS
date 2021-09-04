//
//  MateDetailViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class MateDetailViewController: UIViewController {

    var selectMate: Mate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let mate = self.selectMate {
            self.updateUI(at: mate)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI(at index: Mate) {
        DispatchQueue.main.async {
            self.profileImageView.image = UIImage(named: "profileImage_\(index.id).png")
            self.nickNameLabel.text = index.nickName
            self.emailLabel.text = index.email
            self.introduceLabel.text = index.introduce
        }
    }
}
