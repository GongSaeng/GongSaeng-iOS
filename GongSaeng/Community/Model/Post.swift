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
    var writerImageFilename: String?
    var writerId: String
    var writerNickname: String
    var uploadedTime: String
    var numberOfComments: Int
    var postingImagesFilename: [String]?
    var status: Int?
    var category: String?
    var price: String? // Int??
    
    enum CodingKeys: String, CodingKey {
        case title, contents
        case writerId = "id"
        case writerNickname = "nickname"
        case numberOfComments = "comment_num"
        case uploadedTime = "time"
        case postingImagesFilename = "contents_images_url"
        case writerImageFilename = "profile_image_irl"
        case status, category, price
    }
    
    mutating func updateNumberOfComments(numberOfComments: Int) {
        self.numberOfComments = numberOfComments
    }
}
