//
//  freeWriteViewController.swift
//  community
//
//  Created by 유경민 on 2021/12/28.
//

import UIKit

class freeWriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//        navigationController?.isNavigationBarHidden = false
        configureNavigationView()
    }
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var contentsField: UITextView!
    
    
    
    
    
    
    @objc func writeButtonTap() {
        print("write button tapped")
        let titleText = titleField.text ?? "test title"
        let contentsText = contentsField.text ?? "test contents"
        freeNetwork.freeWrite(titleText: titleText, contentsText: contentsText)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func backload() {
        print("write button tapped")
        let titleText = titleField.text ?? "test title"
        let contentsText = contentsField.text ?? "test contents"
        freeNetwork.freeWrite(titleText: titleText, contentsText: contentsText)
//        freeNetwork.freeWrite(titleText : titleField.text ?? "test title", contentsText : contentsField.text ?? "test contents", completion: nil )ddd
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func configureNavigationView() {
//        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "자유게시판"
        navigationController?.navigationBar.tintColor = UIColor(named: "colorPaleOrange")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(writeButtonTap))
        
        let backBarButton = UIBarButtonItem(title: "게시글목록", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], for: .normal)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButton
    }
   


}



