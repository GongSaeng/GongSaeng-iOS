//
//  ManageAccountViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/09.
//

import Foundation

struct ManageAccountViewModel {
    var user: User
    
    var namePlaceholder: String { user.name }
    var emailPlaceholder: String {
        if let email = user.email {
            return email
        } else {
            return "이메일을 남겨보세요!"
        }
    }

    var phoneNumberPlaceholder: String { user.phoneNumber }
    
    var name: String?
    var email: String?
    var phoneNumber: String?
    
    init(user: User) {
        self.user = user
    }
}
