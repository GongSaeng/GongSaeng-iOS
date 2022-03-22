//
//  ThunderList2ViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/14.
//

import Foundation
import RxSwift
import RxCocoa

enum SortingOrder: String {
    case closingOrder
    case registeringOrder
}

final class ThunderList2ViewModel {
    private let disposeBag = DisposeBag()
    
    // Subview's ViewModel
    let thunderListTopViewModel = ThunderList2TopViewModel()
    let thunderListTableViewModel = ThunderList2TableViewModel()
    
    // Related Input
    let currentPage = BehaviorRelay<Int>(value: 1)
    let sortingOrder = BehaviorRelay<SortingOrder>(value: .closingOrder)
    let selectedRegion = BehaviorRelay<String?>(value: UserDefaults.standard.string(forKey: "region"))
    let writeButtonTapped = PublishRelay<Void>()
    
    // Related Output
    let pushLocaleView: Signal<String?>
//    let pushMyThunderView: Signal<String>
    let pushWriteView: Signal<Void>
    let pushThunderView: Driver<Int>
    
//    let shouldFetchThunders: Observable<String>
    
    init(_ model: ThunderList2Model = ThunderList2Model()) {
        let thundersResult = Observable
            .combineLatest(currentPage, sortingOrder, selectedRegion)
            .distinctUntilChanged { $0 == $1 }
            .map { page, order, region in
                model.fetchThunders(region: region, by: order, page: page)
            }
            .flatMap { $0 }
            .share()
        
        let thundersValue = thundersResult
            .compactMap(model.getThundersValue)
        
        // 에러 처리
//        let thundersError = thundersResult
//            .compactMap(model.getThundersError)
        
        thundersValue
            .map(model.getThunderListCellData)
            .bind(to: thunderListTableViewModel.thunderCellData)
            .disposed(by: disposeBag)
        
        // UserDefaults(Singletone) -> ViewModel
        UserDefaults.standard.rx
            .observe(String.self, "region")
            .bind(to: selectedRegion)
            .disposed(by: disposeBag)
        
        
        // ViewModel -> ThunderListTopViewModel
        self.sortingOrder
            .bind(to: thunderListTopViewModel.sortingOrder)
            .disposed(by: disposeBag)
        
        self.selectedRegion
            .map { $0 ?? "서울/서울" }
            .map { $0.split(separator: "/") }
            .map { String($0[1]) }
            .bind(to: thunderListTopViewModel.selectedRegion)
            .disposed(by: disposeBag)
        
        // ThunderListTopViewModel -> ViewModel
        thunderListTopViewModel.orderButtonTapped
            .bind(to: self.sortingOrder)
            .disposed(by: disposeBag)
        
//        thunderListTopViewModel
        
        self.pushLocaleView = thunderListTopViewModel.localeButtonTapped
            .withLatestFrom(selectedRegion)
            .asSignal(onErrorSignalWith: .empty())
        
        // Input -> Output
        self.pushWriteView = writeButtonTapped
            .asSignal()
        
        self.pushThunderView = thunderListTableViewModel.selectedIndex
    }
    
    private func bind(_ model: ThunderList2Model) {
        
    }
        // ThunderTopViewModel
//        self.shouldFetchThunders = UserDefaults.standard.rx
//            .observe(String.self, "region")
//            .map { $0 ?? "서울/전체" }
//            .distinctUntilChanged()
        
        // ThunderListViewModel
//        let b = model.fetchThunders(metropolis: "", region: "", by: .closingOrder, page: 1)
    
    /*
     - ThunderListViewController -> ThunderListViewModel -> ThunderListModel
        ㄴ ThunderListTopView -> UserDefaults 지역
        ㄴ ThuderListTopView
     
     */
}
