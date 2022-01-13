//
//  PopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/06.
//

import UIKit
import SnapKit

class PopUpViewController: UIViewController {
    
    // MARK: Properties
    var detailText: String? {
        didSet { detailsLabel.text = detailText }
    }
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8.0
        return contentView
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 0, alpha: 0.87)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var confirmationButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "확인", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]), for: .normal)
        button.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
        button.addTarget(self, action: #selector(didTapConfirmationButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        configure()
    }
    
    // MARK: Actions
    @objc func didTapConfirmationButton() {
        print("DEBUG: Did tap confirmationButton..")
        dismiss(animated: false)
    }
    
    // MARK: Helpers
    private func layout() {
        view.addSubview(contentView)
        [detailsLabel, confirmationButton].forEach {
            contentView.addSubview($0)
        }
        
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(17.0)
        }
        
        detailsLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        confirmationButton.snp.makeConstraints {
            $0.top.equalTo(detailsLabel.snp.bottom).offset(17.0)
            $0.bottom.trailing.equalToSuperview().inset(24.0)
            $0.width.equalTo(74.0)
            $0.height.equalTo(36.0)
        }
    }
    
    private func configure() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
    }
}
