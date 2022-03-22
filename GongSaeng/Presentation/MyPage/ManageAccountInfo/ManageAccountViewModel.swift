//
//  ManageAccountViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/09.
//

import Foundation

struct ManageAccountViewModel {
    
    var previousName: String
    var previousEmail: String?
    var previousPhoneNumber: String
    
    var namePlaceholder: String { previousName }
    var emailPlaceholder: String { previousEmail ?? "이메일을 남겨보세요!" }
    var phoneNumberPlaceholder: String { previousPhoneNumber }
    
    init(user: User) {
        self.previousName = user.name
        self.previousEmail = user.email
        self.previousPhoneNumber = user.phoneNumber
    }
}
