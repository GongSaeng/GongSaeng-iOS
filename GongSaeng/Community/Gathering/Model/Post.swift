//
//  Post.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/14.
//

import UIKit

struct Post: Decodable {
    var title: String
    var contents: String
    var writerImageUrl: String?
    var writerId: String
    var writerNickname: String
    var uploadedTime: String
    var numberOfComments: Int
    var postingImagesUrl: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title, contents
        case writerId = "id"
        case writerNickname = "nickname"
        case numberOfComments = "comment_num"
        case uploadedTime = "time"
        case postingImagesUrl = "contents_images_url"
        case writerImageUrl = "profile_image_irl"
    }
    
    mutating func updateNumberOfComments(numberOfComments: Int) {
        self.numberOfComments = numberOfComments
    }
}
