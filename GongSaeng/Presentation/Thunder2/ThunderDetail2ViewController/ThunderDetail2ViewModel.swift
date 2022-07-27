//
//  ThunderDetail2ViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/30.
//

//import UIKit
//import RxSwift
//import RxCocoa
//
//final class ThunderDetail2ViewModel {
//    private let disposeBag = DisposeBag()
//    
//    // Subview's ViewModel
//    let thunderListNavigationViewModel = ThunderDetail2NavigationViewModel()
//    let thunderListHeaderViewModel = ThunderDetail2HeaderViewModel()
//    
//    // Related Input
//    let postIndex: BehaviorRelay<Int>
//    let currentPage = BehaviorRelay<Int>(value: 1)
//    let keyboardHeight = BehaviorRelay<CGFloat>(value: 0)
//    
//    // Related Output
//    let pop: Signal<Void>
//    
//    // Bind
//    init(_ model: ThunderDetail2Model = ThunderDetail2Model(), index: Int) {
//        self.postIndex = BehaviorRelay<Int>(value: index)
//        
//        self.pop = thunderListNavigationViewModel.backButtonTapped
//            .asSignal()
//        
//        let thunderResult = postIndex
//            .flatMap(model.fetchThunderDetail)
//            .share()
//        
//        let thunderDetail = thunderResult
//            .compactMap(model.getThunderDetailValue)
//        
//        thunderDetail
//            .bind(to: thunderListHeaderViewModel.thunderData)
//            .disposed(by: disposeBag)
//    }
//    
//    deinit {
//        print("DEBUG: deinit")
//    }
//}
