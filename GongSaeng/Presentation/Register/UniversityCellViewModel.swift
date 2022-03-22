//
//  UniversityCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/09.
//

import Foundation

struct UniversityCellViewModel {
    var isSelected: Bool = false
    var name: String
    
    init(university: University) {
        self.name = university.name
    }
    
    mutating func toggleSelectedState() {
        isSelected = !isSelected
    }
}
