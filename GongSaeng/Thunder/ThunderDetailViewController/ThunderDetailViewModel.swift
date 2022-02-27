//
//  ThunderDetailViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/24.
//

import UIKit

struct ThunderDetailViewModel {
    var isNavigationViewHidden: Bool = true
    
    var navigationViewColor: UIColor {
        isNavigationViewHidden ? .clear : .white
    }
    
    var dividingViewColor: UIColor {
        isNavigationViewHidden ? .clear : UIColor(white: 0, alpha: 0.2)
    }
    
    var backwardButtonColor: UIColor {
        isNavigationViewHidden ? .white : .black
    }
    
    var remainingDays: String
    
    init(thunderDetail: ThunderDetail) {
        self.remainingDays = thunderDetail.meetingTime.toRemainingDays()
    }
}
