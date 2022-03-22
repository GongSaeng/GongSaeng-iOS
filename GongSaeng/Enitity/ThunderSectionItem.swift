//
//  ThunderSectionItem.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/17.
//

import Foundation
import RxDataSources

struct ThunderSectionItem {
    public enum SectionType: Int {
        case available
        case completed
    }
    
    var sectionType: SectionType
    var items: [ThunderListCellViewModel]
    
    static func getSectionType(_ rawValue: Int) -> SectionType {
        return (rawValue == 0) ? .available : .completed
    }
}

extension ThunderSectionItem: SectionModelType {
    typealias Item = ThunderListCellViewModel
    
    init(original: ThunderSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
