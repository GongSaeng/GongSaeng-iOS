//
//  LocalePopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/14.
//

import UIKit
import SnapKit

class LocalePopUpViewController: UIViewController {
    
    // MARK: Properties
    let tempView = UIView()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        tempView.backgroundColor = .white
        
        view.addSubview(tempView)
        tempView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18.0)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.width.equalTo(80)
            $0.height.equalTo(150)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DEBUG: animated -> \(animated)")
    }
    
    // MARK: Actions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }
}
