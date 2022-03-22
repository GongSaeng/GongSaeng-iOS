//
//  BannerButton.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/19.
//

import UIKit

class BannerButton: UIButton {
    
    // MARK: Properties
    var isActivated: Bool = true {
        didSet { changeButtonState() }
    }
    
    private var buttonTitle: String
    private var buttonColor: ButtonColor
    
    // MARK: Lifecycle
    init(title: String, backgroundColor: ButtonColor) {
        self.buttonTitle = title
        self.buttonColor = backgroundColor
        
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    private func changeButtonState() {
        guard buttonColor == .green else { return }
        let greenColor = UIColor(named: "colorBlueGreen")!
        let grayColor = UIColor(white: 0, alpha: 0.2)
        
        if isActivated {
            self.backgroundColor = greenColor
            self.isEnabled = true
        } else {
            self.backgroundColor = grayColor
            self.isEnabled = false
        }
    }
    
    // MARK: Helpers
    private func configure() {
        backgroundColor = .white
        
        let greenColor = UIColor(named: "colorBlueGreen")!
        let whiteColor = UIColor.white
        self.setAttributedTitle(NSAttributedString(string: buttonTitle, attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold)]), for: .normal)
        
        layer.cornerRadius = 8
        
        if buttonColor == .white {
            self.setTitleColor(greenColor, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = greenColor.cgColor
            self.backgroundColor = whiteColor
        } else if buttonColor == .green {
            self.setTitleColor(whiteColor, for: .normal)
            self.backgroundColor = greenColor
        }
    }
}
