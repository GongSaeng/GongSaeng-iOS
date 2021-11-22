//
//  Immediation.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/18.
//

import Foundation

struct Immediation: Codable {
    var usingUser: String
    var kindOfEquipment: String
    var nameOfEquipment: String
    var isUsing: Bool
    var startTime: String?
    var endTime: String?
    
    mutating func update(usingUser: String, kindOfEquipment: String, nameOfEquipment: String, isUsing: Bool, startTime: String?, endTime: String?) {
        self.usingUser = usingUser
        self.kindOfEquipment = kindOfEquipment
        self.nameOfEquipment = nameOfEquipment
        self.isUsing = isUsing
        self.startTime = startTime
        self.endTime = endTime
    }
}

