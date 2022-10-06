//
//  Profile.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/01.
//

import Foundation

struct Profile: Decodable {
    var id: String
    var profileImageURL: String
    var nickname: String
    var job: String
    var email: String
    var introduce: String
}
