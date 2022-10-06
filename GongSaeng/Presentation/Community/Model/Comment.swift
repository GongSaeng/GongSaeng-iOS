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
    var writerNickname: String = ""
    var uploadedTime: String = ""
    
    enum CodingKeys: String, CodingKey {
        case contents
        case writerNickname = "nickname"
        case m_nickname
        case uploadedTime = "time"
        case regdate
        case writerImageFilename = "profile_image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let decodedNickname = try container.decodeIfPresent(String.self, forKey: .writerNickname) {
            self.writerNickname = decodedNickname
        } else if let decodedNickname = try container.decodeIfPresent(String.self, forKey: .m_nickname) {
            self.writerNickname = decodedNickname
        }
        
        if let decodedTime = try container.decodeIfPresent(String.self, forKey: .uploadedTime) {
            self.uploadedTime = decodedTime.convertEnToKo()
        } else if let decodedTime = try container.decodeIfPresent(String.self, forKey: .regdate) {
            self.uploadedTime = decodedTime.convertEnToKo()
        }
        
        self.contents = try container.decode(String.self, forKey: .contents)
        self.writerImageFilename = try container.decodeIfPresent(String.self, forKey: .writerImageFilename)
        
    }
}
