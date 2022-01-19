//
//  Community.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import Foundation

struct Community: Decodable {
    var index: Int
    var validStatus: Int?
    var title: String
    var contents: String
    var writerImageUrl: String?
    var writerId: String
    var writerNickname: String
    var uploadedTime: String
    var numberOfComments: Int
    var thumbnailImageUrl: String?
    var category: String?
    var price: String?
    
    enum CodingKeys: String, CodingKey {
        case index = "idx"
        case title, contents, category, price
        case writerId = "id"
        case writerNickname = "nickname"
        case numberOfComments = "comment_cnt"
        case uploadedTime = "time"
        case validStatus = "status"
        case thumbnailImageUrl = "image_url"
        case writerImageUrl = "writer_profile_image"
    }
}
