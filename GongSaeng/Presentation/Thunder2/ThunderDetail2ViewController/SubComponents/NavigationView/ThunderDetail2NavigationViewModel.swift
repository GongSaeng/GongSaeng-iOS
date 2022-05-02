//
//  ThunderDetail2NavigationViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/31.
//

import Foundation
import RxSwift
import RxCocoa

final class ThunderDetail2NavigationViewModel {
    
    // SuperViewModel -> SubViewModel
    let shouldMakeTransparent = BehaviorRelay<Bool>(value: true)
    
    // View -> ViewModel
    let backButtonTapped = PublishRelay<Void>()
}
