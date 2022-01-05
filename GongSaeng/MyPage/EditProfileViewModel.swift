//
//  EditProfileViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/05.
//

import UIKit

struct EditProfileViewModel {
    var user: User
    
    var profileImageUrl: String?
    var isChangedUserIamge: Bool = false
    
    var nickNamePlaceholder: String { user.nickName }
    var jobPlaceholder: String {
        if let job = user.job {
            return job
        } else {
            return "어떤 일을 하고 있으신가요?"
        }
    }
    var emailPlaceholder: String {
        if let email = user.email {
            return email
        } else {
            return "사용중이신 메일을 입력해주세요!"
        }
    }
    var introducePlaceholder: String {
        if let introduce = user.introduce {
            return introduce
        } else {
            return "이웃에게 본인을 소개해보세요!"
        }
    }
    
    var nickName: String?
    var job: String?
    var email: String?
    var introduce: String?
    
    
    init(user: User) {
        self.user = user
    }
//    var id: String?
//    var password: String?
//    
//    var formIsValid: Bool {
//        return id?.isEmpty == false && password?.isEmpty == false
//    }
//    
//    var buttonBackgoundColor: UIColor {
//        return formIsValid ? UIColor(named: "colorBlueGreen")! : UIColor(white: 0, alpha: 0.2)
//    }
//    
//    var isEditingId: Bool = false
//    
//    var idUnderlineColor: UIColor {
//        return isEditingId ? UIColor(named: "colorBlueGreen")! : UIColor(white: 0, alpha: 0.2)
//    }
//    
//    var isEditingPassword: Bool = false
//    
//    var passwordUnderlineColor: UIColor {
//        return isEditingPassword ? UIColor(named: "colorBlueGreen")! : UIColor(white: 0, alpha: 0.2)
//    }
}
