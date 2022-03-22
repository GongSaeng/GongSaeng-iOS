//
//  TableHeaderView.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/17.
//

import UIKit

class TableHeaderView: UIView {
    var title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor(white: 0, alpha: 0.87)
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
