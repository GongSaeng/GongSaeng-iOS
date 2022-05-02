//
//  ThunderList2TopViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/15.
//

import UIKit
import RxSwift
import RxCocoa

final class ThunderList2TopViewModel {
    
    // View -> ViewModel
    let localeButtonTapped = PublishRelay<Void>()
    let closingOrderButtonTapped = PublishRelay<SortingOrder>()
    let registeringOrderButtonTapped = PublishRelay<SortingOrder>()
    let lookMyThundersButtonTapped = PublishRelay<Void>()
    
    // ThunderList2TopViewModel -> ThunderList2ViewModel
    let orderButtonTapped: Observable<SortingOrder>
//    let shouldFetchThunders: Observable<String>
    
    // ThunderListViewModel -> ThunderListTopViewModel
    let sortingOrder = BehaviorRelay<SortingOrder>(value: .closingOrder)
    let selectedRegion = BehaviorRelay<String>(value: "서울")
    
    init() {
        self.orderButtonTapped = Observable
            .merge(
                closingOrderButtonTapped.asObservable(),
                registeringOrderButtonTapped.asObservable()
            )
            .distinctUntilChanged()
    
//        self.shouldFetchThunders =
    }
}
