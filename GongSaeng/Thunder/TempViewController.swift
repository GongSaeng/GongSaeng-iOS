//
//  TempViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/21.
//

import UIKit
import SnapKit
import Kingfisher

class TempViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonContentView: UIView!
    
    @IBOutlet weak var thumbnailImageView1: UIImageView!
    @IBOutlet weak var thumbnailImageView2: UIImageView!
    @IBOutlet weak var thumbnailImageView3: UIImageView!
    @IBOutlet weak var thumbnailImageView4: UIImageView!
    @IBOutlet weak var thumbnailImageView5: UIImageView!
    @IBOutlet weak var thumbnailImageView6: UIImageView!
    @IBOutlet weak var thumbnailImageView7: UIImageView!

    @IBOutlet weak var pinImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = contentView.frame.height / 2
        buttonContentView.layer.cornerRadius = buttonContentView.frame.height / 2
//        buttonContentView.layer.borderWidth = 1.0
        buttonContentView.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
//        buttonContentView.shadow
//        partiContent.layer.cornerRadius = 4.0
        
        pinImage.layer.masksToBounds = false
        pinImage.layer.shadowColor = UIColor.black.cgColor
        pinImage.layer.shadowOffset = CGSize(width: 0, height: 0.05)
        pinImage.layer.shadowOpacity = 0.2
        pinImage.layer.shadowRadius = 0.5
        
        [thumbnailImageView1, thumbnailImageView2, thumbnailImageView3, thumbnailImageView4, thumbnailImageView5, thumbnailImageView6, thumbnailImageView7].forEach {
            $0?.layer.cornerRadius = thumbnailImageView1.frame.height / 8
            $0?.layer.borderWidth = 1.0
            $0?.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
            $0?.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "33"))
            
            if $0 == thumbnailImageView4 || $0 == thumbnailImageView5 ||  $0 == thumbnailImageView6 || $0 == thumbnailImageView7 {
                let completedView = UIView()
                completedView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                $0?.addSubview(completedView)
                completedView.snp.makeConstraints { $0.edges.equalTo(0) }
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("DEBUG: touch..")
        let storyboard = UIStoryboard(name: "Temp", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TempDetail2ViewController")
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0)], for: .normal)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func writeButtonTapped(_ sender: UIButton) {
        
        let viewController = ThunderWriteViewController()
//        let storyboard = UIStoryboard(name: "Temp", bundle: .main)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "TempWriteViewController") as! TempWriteViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}
