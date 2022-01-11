//
//  Gathering.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import Foundation

struct Gathering: Codable {
    
    var index: String
    var gatheringStatus: String
    var title: String
    var contents: String
    var writerImageUrl: String?
    var writerNickname: String
    var uploadedTime: String
    var numberOfComments: String
    var postingImagesUrl: [String]?
    
    enum CodingKeys: String, CodingKey {
        case index = "idx"
        case title, contents
        case writerNickname = "nickname"
        case numberOfComments = "comments_cnt"
        case uploadedTime = "time"
        case gatheringStatus = "gather_status"
        case postingImagesUrl = "image_url"
    }
}
