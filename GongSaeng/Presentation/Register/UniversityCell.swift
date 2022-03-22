//
//  UniversityCell.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/09.
//

import UIKit

class UniversityCell: UITableViewCell {
    
    // MARK: Properties
    var viewModel: UniversityCellViewModel? {
        didSet { configure() }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!

    // MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        checkImage.image = viewModel.isSelected ? UIImage(named: "departmentOn") : UIImage(named: "departmentOff")
    }
}
