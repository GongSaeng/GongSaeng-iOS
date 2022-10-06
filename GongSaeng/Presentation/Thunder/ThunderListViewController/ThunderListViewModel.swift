//
//  ThunderList2ViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/14.
//

import Foundation
import RxSwift
import RxCocoa
import simd

enum SortingOrder: String {
    case closingOrder
    case registeringOrder
}

final class ThunderListViewModel {
    private let disposeBag = DisposeBag()
    
    let myThunders = BehaviorSubject<[ThunderDetailInfo]?>(value: nil)
    
    // Subview's ViewModel
    let thunderListTopViewModel = ThunderListTopViewModel()
    let thunderListTableViewModel = ThunderListTableViewModel()
    
    // Related Input
    let currentPage = BehaviorRelay<Int>(value: 1)
    let sortingOrder = BehaviorRelay<SortingOrder>(value: .closingOrder)
    let selectedRegion = BehaviorRelay<String?>(value: UserDefaults.standard.string(forKey: "region"))
    let writeButtonTapped = PublishRelay<Void>()
    let myThunderButtonTapped = PublishRelay<Void>()
    
    // Related Output
    let pushLocaleView: Signal<String?>
    let pushMyThunderView: Signal<[ThunderDetailInfo]>
    let pushWriteView: Signal<Void>
    let pushThunderView: Driver<Int>
    
    init(_ model: ThunderListModel = ThunderListModel()) {
        let thundersResult = Observable
            .combineLatest(currentPage, sortingOrder, selectedRegion)
            .distinctUntilChanged { $0 == $1 }
            .map(model.fetchThunders)
            .flatMap { $0 }
            .share()
        
        let thundersValue = thundersResult
            .compactMap(model.getThundersValue)
        print("얍",thundersValue)
        // 에러 처리
//        let thundersError = thundersResult
//            .compactMap(model.getThundersError)
        
        thundersValue
            .map(model.getThunderListCellData)
            .bind(to: thunderListTableViewModel.thunderCellData)
            .disposed(by: disposeBag)

        let myThundersResult = model.fetchMyThunders()
        let myThundersValue = myThundersResult
            .map(model.getMyThundersValue)
            .asObservable()
        
        myThundersValue
            .bind(to: myThunders)
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
        
        thunderListTopViewModel.lookMyThundersButtonTapped
            .bind(to: self.myThunderButtonTapped)
            .disposed(by: disposeBag)
        
        self.pushLocaleView = thunderListTopViewModel.localeButtonTapped
            .withLatestFrom(selectedRegion)
            .asSignal(onErrorSignalWith: .empty())
        
        // Input -> Output
        self.pushWriteView = writeButtonTapped
            .asSignal()
        
        self.pushThunderView = thunderListTableViewModel.selectedIndex
        
        self.pushMyThunderView = myThunderButtonTapped
            .withLatestFrom(myThunders)
            .compactMap { $0 }
            .asSignal(onErrorJustReturn: [])
    }
}
