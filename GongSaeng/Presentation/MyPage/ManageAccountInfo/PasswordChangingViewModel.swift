//
//  PasswordChangingViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/09.
//

import UIKit

struct PasswordChangingViewModel {
    var password: String?
    var passwordCheck: String?
    
    var formIsValid: Bool {
        guard let password = password, let passwordCheck = passwordCheck else { return false }
        return password.count >= 8 && passwordCheck.count >= 8 && password.count <= 22 && passwordCheck.count <= 22
    }
    
    var isSecureMode: Bool = true
}
