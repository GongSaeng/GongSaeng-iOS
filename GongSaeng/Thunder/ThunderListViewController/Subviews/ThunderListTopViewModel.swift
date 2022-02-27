//
//  ThunderListTopViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/14.
//

import UIKit

enum SortingOrder: String {
    case closingOrder
    case registeringOrder
}

enum ThunderLookingStatus: String {
    case allThunder
    case myThunder
}

struct ThunderListTopViewModel {
    var order: SortingOrder = .closingOrder
    var isClosingOrderButtonEnabled: Bool { order != .closingOrder }
    
    var isRegisteringOrderButtonEnabled: Bool { order != .registeringOrder }
    
    var closingTitleColor: UIColor {
        (order == .closingOrder) ? UIColor(named: "colorBlueGreen")! : .black
    }
    
    var registeringTitleColor: UIColor {
        (order == .registeringOrder) ? UIColor(named: "colorBlueGreen")! : .black
    }
    
    var closingBackgroundColor: UIColor {
        (order == .closingOrder) ? UIColor(named: "colorBlueGreen")!.withAlphaComponent(0.1) : .clear
    }
    
    var registeringBackgroundColor: UIColor {
        (order == .registeringOrder) ? UIColor(named: "colorBlueGreen")!.withAlphaComponent(0.1) : .clear
    }
    
    var thunderLookingStatus: ThunderLookingStatus = .allThunder
    
    var lookThunderButtonTitle: String {
        switch thunderLookingStatus {
        case .allThunder:
            return "참여번개보기"
        case .myThunder:
            return "전체번개보기"
        }
    }
}
