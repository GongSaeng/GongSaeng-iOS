//
//  Comment.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/15.
//

import Foundation

struct Comment: Decodable {
    var contents: String
    var writerImageFilename: String?
    var writerNickname: String
    var uploadedTime: String
    
    enum CodingKeys: String, CodingKey {
        case contents
        case writerNickname = "nickname"
        case uploadedTime = "time"
        case writerImageFilename = "profile_image_url"
    }
}
