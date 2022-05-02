//
//  ThunderDetail2NavigationView.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/31.
//

import UIKit
import RxSwift
import RxCocoa

final class ThunderDetail2NavigationView: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .medium)
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: configuration), for: .normal)
        return button
    }()
    
    private let topGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.3).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0, 1]
        let frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topPadding + 40.0)
        gradientLayer.frame = frame
        return gradientLayer
    }()
    
    private let remainingDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "colorPinkishOrange")
        return label
    }()
    private let contentView = UIView()
    private let dividingView = UIView()
    
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
    private func attribute() {
        backgroundColor = .clear
        dividingView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        // 임시
        remainingDaysLabel.font = .systemFont(ofSize: 18.0, weight: .bold)//
        remainingDaysLabel.text = "D-2"
    }
    
    private func layout() {
        [contentView, backwardButton].forEach { addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backwardButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(7.0)
            $0.width.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(1.0)
        }
        
        [remainingDaysLabel, dividingView].forEach { contentView.addSubview($0) }
        
        remainingDaysLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backwardButton)
        }
        
        dividingView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}

// MARK: Bind
extension ThunderDetail2NavigationView {
    func bind(_ viewModel: ThunderDetail2NavigationViewModel) {
        viewModel.shouldMakeTransparent
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] should in
                guard let self = self else { return }
                if should {
                    self.contentView.backgroundColor = .clear
                    self.backwardButton.tintColor = .white
                    self.remainingDaysLabel.isHidden = true
                    self.dividingView.isHidden = true
                    self.contentView.layer.addSublayer(self.topGradientLayer)
                } else {
                    self.contentView.backgroundColor = .white
                    self.backwardButton.tintColor = .black
                    self.remainingDaysLabel.isHidden = false
                    self.dividingView.isHidden = false
                    self.topGradientLayer.removeFromSuperlayer()
                }
            })
            .disposed(by: disposeBag)
        
        backwardButton.rx.tap
            .bind(to: viewModel.backButtonTapped)
            .disposed(by: disposeBag)
    }
}
