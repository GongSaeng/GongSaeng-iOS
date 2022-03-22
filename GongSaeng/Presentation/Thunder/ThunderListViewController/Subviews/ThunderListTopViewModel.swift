//
//  ThunderListTopViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/14.
//

import UIKit

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
    
    var lookThunderButtonTitle: String = "참여번개보기"
}
