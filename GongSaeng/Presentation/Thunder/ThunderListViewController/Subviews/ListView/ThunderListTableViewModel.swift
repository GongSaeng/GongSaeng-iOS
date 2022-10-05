//
//  ThunderList2TableViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/15.
//

import RxSwift
import RxCocoa
import SwiftUI

final class ThunderListTableViewModel {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    let thunderCellData = PublishSubject<[ThunderListCellViewModel]>()
    let tableViewItems: Driver<[ThunderSectionItem]>
    let itemSelected = PublishRelay<Int>()
    
    let selectedIndex: Driver<Int>
    
    // MARK: Bind
    init() {
        self.tableViewItems = thunderCellData
            .map { viewMoels -> [ThunderSectionItem] in
                var available = [ThunderListCellViewModel]()
                var completed = [ThunderListCellViewModel]()
                viewMoels.forEach {
                    if $0.validStatus { available.append($0) }
                    else { completed.append($0) }
                }
                let availableSection = ThunderSectionItem(sectionType: .available, items: available)
                let completedSection = ThunderSectionItem(sectionType: .completed, items: completed)
                return [availableSection, completedSection]
            }
            .asDriver(onErrorJustReturn: [])
        
        self.selectedIndex = self.itemSelected
            .asDriver(onErrorJustReturn: 0)
    }
}
