//
//  PlaceListCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/07.
//

import UIKit
import SnapKit

class PlaceListCell: UITableViewCell {
    
    // MARK: Properties
    var viewModel: PlaceListCellViewModel? {
        didSet {
            configure()
            layout()
        }
    }
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = UIColor(white: 0, alpha: 0.8)
        return label
    }()
    
    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        placeLabel.text = viewModel.placeName
        addressLabel.text = viewModel.addressName
    }
    
    private func layout() {
        [placeLabel, addressLabel].forEach { contentView.addSubview($0) }
        placeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.leading.equalToSuperview().inset(18.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(10.0)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(7.0)
            $0.leading.equalTo(placeLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(10.0)
            $0.bottom.equalToSuperview().inset(15.0)
        }
    }
}
