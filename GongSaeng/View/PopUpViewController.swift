//
//  PopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/06.
//

import UIKit
import SnapKit

enum PopUpButtonType {
    case none
    case cancel
    case cancelAndAction
}

protocol PopUpViewControllerDelegate: AnyObject {
    func didTapActionButton()
}

class PopUpViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: PopUpViewControllerDelegate?
    
    var descriptionText: String? {
        didSet {
            guard buttonType != .none, let description = descriptionText else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.descriptionLabel.text = description
            }
        }
    }
    
    var cancelButtonTitle: String?
    var actionButtonTitle: String?
    
    private let buttonType: PopUpButtonType
    private let popUpContents: String
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8.0
        return contentView
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 0, alpha: 0.87)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "colorBlueGreen"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(named: "colorBlueGreen")?.cgColor
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "확인", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]), for: .normal)
        button.setTitleColor(UIColor(named: "colorPinkishOrange"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(named: "colorPinkishOrange")?.cgColor
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = UIColor(named: "colorPinkishOrange")
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: Lifecycle
    init(buttonType: PopUpButtonType = .none, contents: String) {
        self.buttonType = buttonType
        self.popUpContents = contents
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if buttonType == .none {
            dismiss(animated: false)
        }
    }
    
    // MARK: Actions
    @objc
    private func didTapCancelButton() {
        print("DEBUG: Did tap cancelButton..")
        dismiss(animated: false)
    }
    
    @objc
    private func didTapActionButton() {
        print("DEBUG: Did tap actionButton..")
        delegate?.didTapActionButton()
    }
    
    // MARK: Helpers
    private func layout() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18.0)
        }
        
        contentView.addSubview(contentsLabel)
        
        switch buttonType {
        case .none: // 버튼 0개
            contentsLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(24.0) }
            
        case .cancel: // 버튼 1개
            var cancelButtonWidth = 74.0
            if let title = cancelButtonTitle, !title.isEmpty {
                cancelButtonWidth = Double(title.count * 13 + 48)
            }
            contentView.addSubview(cancelButton)
            contentsLabel.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview().inset(24.0) }
            
            cancelButton.snp.makeConstraints {
                $0.top.equalTo(contentsLabel.snp.bottom).offset(17.0)
                $0.bottom.trailing.equalToSuperview().inset(24.0)
                $0.height.equalTo(36.0)
                $0.width.equalTo(cancelButtonWidth)
            }
            
        case .cancelAndAction: // 버튼 2개
            var actionButtonWidth = 51.0
            if let title = actionButtonTitle, !title.isEmpty {
                actionButtonWidth = Double(title.count * 13 + 25)
            }
            
            var cancelButtonWidth = 51.0
            if let title = cancelButtonTitle, !title.isEmpty {
                cancelButtonWidth = Double(title.count * 13 + 25)
            }
            
            [actionButton, cancelButton].forEach { contentView.addSubview($0) }
            contentsLabel.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview().inset(24.0) }
            
            actionButton.snp.makeConstraints {
                $0.top.equalTo(contentsLabel.snp.bottom).offset(17.0)
                $0.bottom.trailing.equalToSuperview().inset(24.0)
                $0.height.equalTo(36.0)
                $0.width.equalTo(actionButtonWidth)
            }
            
            cancelButton.snp.makeConstraints {
                $0.centerY.equalTo(actionButton)
                $0.trailing.equalTo(actionButton.snp.leading).offset(-14.0)
                $0.height.equalTo(36.0)
                $0.width.equalTo(cancelButtonWidth)
            }
        }
        
        if buttonType != .none {
            contentView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints {
                $0.centerY.equalTo(cancelButton)
                $0.leading.equalTo(contentsLabel)
                $0.trailing.greaterThanOrEqualTo(cancelButton.snp.leading).offset(-5.0)
            }
        }
    }
    
    private func configure() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
//        paragraphStyle.lineBreakMode = .byTruncatingTail
        contentsLabel.attributedText = NSAttributedString(
                                                string: popUpContents,
                                                attributes: [.paragraphStyle: paragraphStyle,
                                                             .font: UIFont.systemFont(ofSize: 14.0),
                                                             .foregroundColor: UIColor(white: 0, alpha: 0.87).cgColor])
        
        switch buttonType {
        case .none:
            return
            
        case .cancel:
            let cancelButtonTitle = cancelButtonTitle ?? "확인"
            cancelButton.setAttributedTitle(NSAttributedString(string: cancelButtonTitle, attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]), for: .normal)
        case .cancelAndAction:
            let actionButtonTitle = actionButtonTitle ?? "확인"
            let cancelButtonTitle = cancelButtonTitle ?? "취소"
            actionButton.setAttributedTitle(NSAttributedString(string: actionButtonTitle, attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]), for: .normal)
            cancelButton.setAttributedTitle(NSAttributedString(string: cancelButtonTitle, attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]), for: .normal)
        }
    }
}
