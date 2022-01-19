//
//  Register.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/05.
//

import Foundation

struct Register {
    var department, name, dateOfBirth, phoneNumber, id, password, nickname: String?
    
    mutating func updateRegister(department: String? = nil, name: String? = nil, dateOfBirth: String? = nil, phoneNumber: String? = nil, id: String? = nil, password: String? = nil, nickname: String? = nil) {
        if let department = department { self.department = department }
        if let name = name { self.name = name }
        if let dateOfBirth = dateOfBirth { self.dateOfBirth = dateOfBirth }
        if let phoneNumber = phoneNumber { self.phoneNumber = phoneNumber }
        if let id = id { self.id = id }
        if let password = password { self.password = password }
        if let nickname = nickname { self.nickname = nickname }
    }
}
