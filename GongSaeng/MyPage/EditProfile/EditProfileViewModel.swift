//
//  EditProfileViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/05.
//

import UIKit

struct EditProfileViewModel {
    var user: User
    
    var profileImage: UIImage? { user.image }
    var isChangedUserImage: Bool = false
    
    var nickNamePlaceholder: String { user.nickName }
    var jobPlaceholder: String {
        if let job = user.job {
            return job
        } else {
            return "어떤 직업을 갖고 있으신가요?"
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
    var introduce: String?
    
    init(user: User) {
        self.user = user
    }
}
