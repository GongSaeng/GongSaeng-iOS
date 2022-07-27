//
//  ParticipantProfileViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/01.
//

import Foundation

struct ParticipantProfileViewModel {
    private let profiles: [Profile]
    
    var index: Int
    // 5, (1, 2, 3, 4, 5), 1
    var profileList: [Profile] {
        if profiles.count <= 1 { return profiles }
        return [profiles[profiles.count - 1]] + profiles + [profiles[0]]
    }
    
    var imageURLs: [URL?] {
        return profileList.map { $0.profileImageURL }
            .compactMap { $0 }
            .map { URL(string: SERVER_IMAGE_URL + $0) }
    }
    
    private var profile: Profile {
        profileList[index]
    }
    
    var nickname: String { profile.nickname }
    var job: String { profile.job }
    var email: String { profile.email }
    var introduce: String { profile.introduce }
    
    init(index: Int, profiles: [Profile]) {
        self.index = profiles.count <= 1 ? index : index + 1
        self.profiles = profiles
    }
}
