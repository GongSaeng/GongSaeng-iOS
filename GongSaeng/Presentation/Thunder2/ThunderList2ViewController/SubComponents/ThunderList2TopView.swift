//
//  ThunderList2TopView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/15.
//

import UIKit
import RxSwift
import RxCocoa

final class ThunderList2TopView: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let thunderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.text = "번개"
        return label
    }()
    
    private let localeButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 13.0, weight: .bold)
        let image = UIImage(systemName: "chevron.down")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .right
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
    
    private let closingOrderButton = UIButton(type: .system)
    
    private let registeringOrderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textAlignment = .center
        label.text = "등록순"
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        return label
    }()
    
    private let registeringOrderButton = UIButton(type: .system)
    
    private let lookMyThundersButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "thunder")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "colorPinkishOrange")
        button.imageEdgeInsets = .init(top: 30.0, left: -15, bottom: 30.0, right: 40)
        button.titleEdgeInsets = .init(top: 0, left: -40, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        button.setAttributedTitle(
            NSAttributedString(
                string: "참여번개보기",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12.0, weight: .heavy),
                    .foregroundColor: UIColor(named: "colorPinkishOrange")!
                ])
            , for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    func updateLocale() {
        localeButton.setAttributedTitle(
            NSAttributedString(
                string: "\(UserDefaults.standard.string(forKey: "region") ?? "서울") " ,
                attributes: [.font: UIFont.systemFont(ofSize: 17.0,
                                                      weight: .semibold)]),
            for: .normal)
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        [thunderLabel, localeButton,
         closingOrderButton, registeringOrderButton,
         lookMyThundersButton, dividingView]
            .forEach { addSubview($0) }
        thunderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        localeButton.snp.makeConstraints {
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
        
        lookMyThundersButton.snp.makeConstraints {
            $0.centerY.equalTo(registeringOrderButton)
            $0.trailing.equalToSuperview().inset(14.0)
            $0.width.equalTo(90)
            $0.height.equalTo(44.0)
        }
        
        dividingView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}

// MARK: Bind
extension ThunderList2TopView {
    func bind(_ viewModel: ThunderList2TopViewModel) {
        // View -> ViewModel
        closingOrderButton.rx.tap
            .map { SortingOrder.closingOrder }
            .bind(to: viewModel.closingOrderButtonTapped)
            .disposed(by: disposeBag)
        
        registeringOrderButton.rx.tap
            .map { SortingOrder.registeringOrder }
            .bind(to: viewModel.registeringOrderButtonTapped)
            .disposed(by: disposeBag)
        
        localeButton.rx.tap
            .bind(to: viewModel.localeButtonTapped)
            .disposed(by: disposeBag)
        
        lookMyThundersButton.rx.tap
            .bind(to: viewModel.lookMyThundersButtonTapped)
            .disposed(by: disposeBag)
        
        // ViewModel -> View
        viewModel.sortingOrder
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] order in
                switch order {
                case .closingOrder:
                    self?.closingOrderLabel.textColor = UIColor(named: "colorBlueGreen")
                    self?.closingOrderLabel.backgroundColor = UIColor(named: "colorBlueGreen")?.withAlphaComponent(0.1)
                    self?.registeringOrderLabel.textColor = .black
                    self?.registeringOrderLabel.backgroundColor = .clear
                    
                case .registeringOrder:
                    self?.closingOrderLabel.textColor = .black
                    self?.closingOrderLabel.backgroundColor = .clear
                    self?.registeringOrderLabel.textColor = UIColor(named: "colorBlueGreen")
                    self?.registeringOrderLabel.backgroundColor = UIColor(named: "colorBlueGreen")?.withAlphaComponent(0.1)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedRegion
            .asDriver()
            .drive(onNext: { [weak self] region in
                self?.localeButton.setAttributedTitle(
                    NSAttributedString(
                        string: region ,
                        attributes: [.font: UIFont.systemFont(ofSize: 17.0,
                                                              weight: .semibold)]),
                    for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
