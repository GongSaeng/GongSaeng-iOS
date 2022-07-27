//
//  Mate.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import Foundation

struct Mate: Decodable, Equatable {
    
    var nickname: String
    var job: String?
    var email: String?
    var introduce: String?
    var profileImageFilename: String?

    enum CodingKeys: String, CodingKey {
        case nickname = "name"
        case job
        case email = "mail"
        case introduce = "profile"
        case profileImageFilename = "profile_image_url"
    }
    
    mutating func update(nickname: String? = nil, job: String? = nil, email: String? = nil, introduce: String? = nil) {
        if let nickname = nickname { self.nickname = nickname }
        if let job = job { self.job = job }
        if let email = email { self.email = email }
        if let introduce = introduce { self.introduce = introduce }
    }
}
