//
//  ThunderListTopView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/14.
//

import UIKit
import SnapKit

protocol ThunderListTopViewDelegate: AnyObject {
    func localeSelectionHandler()
    func lookMyThunderList()
}

final class ThunderListTopView: UIView {
    
    // MARK: Properties
    weak var delegate: ThunderListTopViewDelegate?
    
    private var viewModel = ThunderListTopViewModel()
    
    private let thunderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.text = "번개"
        return label
    }()
    
    private lazy var localeSelectionButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 13.0, weight: .bold)
        let image = UIImage(systemName: "chevron.down")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.setAttributedTitle(
            NSAttributedString(
                string: "\(UserDefaults.standard.string(forKey: "region") ?? "서울") " ,
                attributes: [.font: UIFont.systemFont(ofSize: 17.0,
                                                      weight: .semibold)]),
            for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(didTapLocaleSelectionButton), for: .touchUpInside)
        return button
    }()
    
    private let closingOrderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textAlignment = .center
        label.text = "마감순"
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var closingOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(sortingOrderHandler), for: .touchUpInside)
        return button
    }()
    
    private let registeringOrderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textAlignment = .center
        label.text = "등록순"
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var registeringOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(sortingOrderHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var lookMyThunderButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapLookMyThunderButton), for: .touchUpInside)
        return button
    }()
    
    private let lookThunderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .heavy)
        label.textColor = UIColor(named: "colorPinkishOrange")
        return label
    }()
    
    private let lookThunderImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "thunder")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "colorPinkishOrange")
        return imageView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
        updateSortingOrder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func didTapLocaleSelectionButton() {
        delegate?.localeSelectionHandler()
    }
    
    @objc
    private func didTapLookMyThunderButton() {
        delegate?.lookMyThunderList()
    }
    
    @objc
    private func sortingOrderHandler(_ sender: UIButton) {
        viewModel.order = (sender == closingOrderButton) ? .closingOrder : .registeringOrder
        updateSortingOrder()
    }
    
    // MARK: Helpers
    func updateLocale() {
        localeSelectionButton.setAttributedTitle(
            NSAttributedString(
                string: "\(UserDefaults.standard.string(forKey: "region") ?? "서울") " ,
                attributes: [.font: UIFont.systemFont(ofSize: 17.0,
                                                      weight: .semibold)]),
            for: .normal)
    }
    
    private func updateSortingOrder() {
        closingOrderLabel.textColor = viewModel.closingTitleColor
        closingOrderLabel.backgroundColor = viewModel.closingBackgroundColor
        closingOrderButton.isEnabled = viewModel.isClosingOrderButtonEnabled
        
        registeringOrderLabel.textColor = viewModel.registeringTitleColor
        registeringOrderLabel.backgroundColor = viewModel.registeringBackgroundColor
        registeringOrderButton.isEnabled = viewModel.isRegisteringOrderButtonEnabled
    }
    
    private func configure() {
        backgroundColor = .white
        lookThunderLabel.text = viewModel.lookThunderButtonTitle
    }
    
    private func layout() {
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        [thunderLabel, localeSelectionButton,
         closingOrderButton, registeringOrderButton,
         lookMyThunderButton, dividingView]
            .forEach { addSubview($0) }
        thunderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        localeSelectionButton.snp.makeConstraints {
            $0.centerY.equalTo(thunderLabel)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.width.equalTo(86.0)
            $0.height.equalTo(44.0)
        }
        
        closingOrderButton.snp.makeConstraints {
            $0.top.equalTo(thunderLabel.snp.bottom).offset(16.0)
            $0.leading.equalTo(thunderLabel)
            $0.width.equalTo(55.0)
            $0.height.equalTo(44.0)
        }
        
        registeringOrderButton.snp.makeConstraints {
            $0.centerY.equalTo(closingOrderButton)
            $0.leading.equalTo(closingOrderButton.snp.trailing).offset(3.0)
            $0.width.equalTo(55.0)
            $0.height.equalTo(44.0)
        }
        
        closingOrderButton.addSubview(closingOrderLabel)
        closingOrderLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30.0)
        }
        
        registeringOrderButton.addSubview(registeringOrderLabel)
        registeringOrderLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30.0)
        }
        
        lookMyThunderButton.snp.makeConstraints {
            $0.centerY.equalTo(registeringOrderButton)
            $0.trailing.equalToSuperview().inset(14.0)
            $0.width.equalTo(78.0)
            $0.height.equalTo(44.0)
        }
        
        [lookThunderImageView, lookThunderLabel]
            .forEach { lookMyThunderButton.addSubview($0) }
        lookThunderImageView.snp.makeConstraints {
            $0.width.height.equalTo(14.0)
            $0.leading.centerY.equalToSuperview()
        }
        
        lookThunderLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        
        dividingView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
//        button.addSubview(imageView)
//        imageView.snp.makeConstraints {
            
//        }
    }
}

