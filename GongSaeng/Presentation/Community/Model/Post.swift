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
        case status = "status"
        case gather_status
        case category, price
    }
    
    mutating func updateNumberOfComments(numberOfComments: Int) {
        self.numberOfComments = numberOfComments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let decodedStatus = try container.decodeIfPresent(Int.self, forKey: .status) {
            self.status = decodedStatus
        } else if let decodedStatus = try container.decodeIfPresent(Int.self, forKey: .gather_status) {
            self.status = decodedStatus
        }
        
        self.title = try container.decode(String.self, forKey: .title)
        self.contents = try container.decode(String.self, forKey: .contents)
        self.writerImageFilename = try container.decodeIfPresent(String.self, forKey: .writerImageFilename)
        self.writerId = try container.decode(String.self, forKey: .writerId)
        self.writerNickname = try container.decode(String.self, forKey: .writerNickname)
        self.uploadedTime = try container.decode(String.self, forKey: .uploadedTime)
        self.numberOfComments = try container.decode(Int.self, forKey: .numberOfComments)
        
        do {
            if let decodedFileName = try container.decodeIfPresent(String.self, forKey: .postingImagesFilename) {
                self.postingImagesFilename = decodedFileName.components(separatedBy: ",")
            }
        } catch {
            self.postingImagesFilename = try container.decodeIfPresent([String].self, forKey: .postingImagesFilename)
        }
        
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        
        if let decodedPrice = try container.decodeIfPresent(Int.self, forKey: .price) {
            self.price = String(decodedPrice)
        }
    }
}
