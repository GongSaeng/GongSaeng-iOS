//
//  Gathering.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import Foundation

struct Gathering: Codable {
    var index: Int
    var gatheringStatus: Int
    var title: String
    var contents: String
    var writerImageUrl: String?
    var writerId: String
    var writerNickname: String
    var uploadedTime: String
    var numberOfComments: Int
    var postingImagesUrl: [String]?
    
    enum CodingKeys: String, CodingKey {
        case index = "idx"
        case title, contents
        case writerId = "id"
        case writerNickname = "nickname"
        case numberOfComments = "comment_cnt"
        case uploadedTime = "time"
        case gatheringStatus = "gather_status"
//        case postingImagesUrl = "image_url"
        case writerImageUrl = "writer_profile_image"
    }
}
