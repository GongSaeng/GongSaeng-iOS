//
//  HomeViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/17.
//

import UIKit

class HomeViewController: UIViewController {
    
    var user: User? {
        didSet {
            print("DEBUG: HomeViewController get user property")
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let user = self.user else { return }
                self.affiliationLabel.text = user.department
            }
        }
    }
    
    @IBOutlet weak var affiliationLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
