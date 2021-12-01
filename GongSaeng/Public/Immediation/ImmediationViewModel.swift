//
//  ImmediationViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/18.
//

import Foundation

struct ImmediationViewModel: Codable {
    var user: User?
    var Immediations: [Immediation] = [
        Immediation(usingUser: "banana", kindOfEquipment: "세탁기", nameOfEquipment: "세탁기1", isUsing: false)
    ]
    
    var numOfMyUsingImmediation: Int {
        return 10//임시
    }
}
