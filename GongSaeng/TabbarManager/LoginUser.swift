//
//  LoginUser.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/07/01.
//

import UIKit

class LoginUser: NSObject {
    static var loginUser: User?
    
    static var isLoginUser: Bool {
        if self.loginUser != nil {
            return true
        } else {
            return false
        }
    }
    
    static func loginUserReplacement(loginUser: User) {
        self.loginUser = loginUser
    }
    
    static func logoutUser() {
        self.loginUser = nil
    }
}


