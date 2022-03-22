//
//  EditProfileViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/05.
//

import UIKit

struct EditProfileViewModel {
    var hasChangedUserImage: Bool = false
    
    var profileImageUrl: URL?
    var previousNickname: String
    var previousJob: String?
    var previousIntroduce: String?
    
    var nicknamePlaceholder: String {
        return previousNickname
    }
    var jobPlaceholder: String {
        return previousJob ?? "어떤 직업을 갖고 있으신가요?"
    }
    var introducePlaceholder: String {
        return previousIntroduce ?? "이웃에게 본인을 소개해보세요!"
    }
    
    init(user: User) {
        self.profileImageUrl = user.profileImageUrl
        self.previousNickname = user.nickname
        self.previousJob = user.job
        self.previousIntroduce = user.introduce
    }
}
