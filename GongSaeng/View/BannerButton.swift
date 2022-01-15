//
//  BannerButton.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/04.
//

import UIKit
enum ButtonColor {
    case white
    case green
}

class BannerButton: UIButton {
    var buttonTitle: String
    var buttonColor: ButtonColor
    var isActivated: Bool = true {
        didSet { changeButtonState() }
    }
    
    required init(title: String, backgroundColor: ButtonColor) {
        self.buttonTitle = title
        self.buttonColor = backgroundColor
        
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let greenColor = UIColor(named: "colorBlueGreen")!
        let whiteColor = UIColor.white
        setAttributedTitle(NSAttributedString(string: buttonTitle, attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold)]), for: .normal)
        
        layer.cornerRadius = 8
        
        if buttonColor == .white {
            setTitleColor(greenColor, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = greenColor.cgColor
            backgroundColor = whiteColor
        } else if buttonColor == .green {
            setTitleColor(whiteColor, for: .normal)
            backgroundColor = greenColor
        }
    }
    
    private func changeButtonState() {
        guard buttonColor == .green else { return }
        let greenColor = UIColor(named: "colorBlueGreen")!
        let grayColor = UIColor(white: 0, alpha: 0.2)
        
        if isActivated {
            backgroundColor = greenColor
            isEnabled = true
        } else {
            backgroundColor = grayColor
            isEnabled = false
        }
    }
}
