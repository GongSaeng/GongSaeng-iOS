//
//  BannerButtonInputAccessoryView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/19.
//

import UIKit
import SnapKit

enum ButtonColor {
    case white
    case green
}

protocol BannerButtonInputAccessoryViewDelegate: AnyObject {
    func didTapBannerButton()
}

class BannerButtonInputAccessoryView: UIView {
    
    // MARK: Properties
    weak var delegate: BannerButtonInputAccessoryViewDelegate?
    
    var isActivated: Bool = true {
        didSet { changeButtonState() }
    }
    
    private var buttonTitle: String
    private var buttonColor: ButtonColor
    
    private lazy var bannerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBannerButton), for: .touchUpInside)
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: Lifecycle
    init(frame: CGRect, buttonTitle: String, buttonColor: ButtonColor) {
        self.buttonTitle = buttonTitle
        self.buttonColor = buttonColor
        
        super.init(frame: frame)
        layout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func didTapBannerButton() {
        delegate?.didTapBannerButton()
    }
    
    private func changeButtonState() {
        guard buttonColor == .green else { return }
        let greenColor = UIColor(named: "colorBlueGreen")!
        let grayColor = UIColor(white: 0, alpha: 0.2)
        
        if isActivated {
            bannerButton.backgroundColor = greenColor
            bannerButton.isEnabled = true
        } else {
            bannerButton.backgroundColor = grayColor
            bannerButton.isEnabled = false
        }
    }
    
    // MARK: Helpers
    private func configure() {
        backgroundColor = .white
        
        let greenColor = UIColor(named: "colorBlueGreen")!
        let whiteColor = UIColor.white
        bannerButton.setAttributedTitle(NSAttributedString(string: buttonTitle, attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold)]), for: .normal)
        
        bannerButton.layer.cornerRadius = 8
        
        if buttonColor == .white {
            bannerButton.setTitleColor(greenColor, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = greenColor.cgColor
            bannerButton.backgroundColor = whiteColor
        } else if buttonColor == .green {
            bannerButton.setTitleColor(whiteColor, for: .normal)
            bannerButton.backgroundColor = greenColor
        }
    }
    
    private func layout() {
        autoresizingMask = .flexibleHeight
        
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        [bannerButton, dividingView].forEach { addSubview($0) }
        
        dividingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        bannerButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(48.0)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
    }
}
