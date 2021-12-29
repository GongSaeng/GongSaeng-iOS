//
//  LoginViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/29.
//

import UIKit

struct LoginViewModel {
    var id: String?
    var password: String?
    
    var formIsValid: Bool {
        return id?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgoundColor: UIColor {
        return formIsValid ? UIColor(named: "colorBlueGreen")! : UIColor(white: 0, alpha: 0.2)
    }
    
    var isEditingId: Bool = false
    
    var idUnderlineColor: UIColor {
        return isEditingId ? UIColor(named: "colorBlueGreen")! : UIColor(white: 0, alpha: 0.2)
    }
    
    var isEditingPassword: Bool = false
    
    var passwordUnderlineColor: UIColor {
        return isEditingPassword ? UIColor(named: "colorBlueGreen")! : UIColor(white: 0, alpha: 0.2)
    }
}
