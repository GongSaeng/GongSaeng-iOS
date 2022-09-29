//
//  Community.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import Foundation

struct Community: Decodable {
    var index: Int
    var code: String
    var validStatus: Int?
    var title: String
    var contents: String
    var writerImageFilename: String?
    var writerId: String
    var writerNickname: String
    var uploadedTime: String
    var numberOfComments: Int
    var thumbnailImageFilename: String?
    var category: String?
    var price: String?
    
    enum CodingKeys: String, CodingKey {
        case index = "idx"
        case code, title, contents, category, price
        case writerId = "id"
        case writerNickname = "name"
        case numberOfComments = "comment_cnt"
        case uploadedTime = "time"
        case validStatus = "status"
        case gather_status
        case thumbnailImageFilename = "image_url"
        case writerImageFilename = "writer_profile_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(Int.self, forKey: .index)
        self.code = try container.decode(String.self, forKey: .code)
        
        if let decodedStatus = try container.decodeIfPresent(Int.self, forKey: .validStatus) {
            self.validStatus = decodedStatus
        } else if let decodedStatus = try container.decodeIfPresent(Int.self, forKey: .gather_status) {
            self.validStatus = decodedStatus
        }
        
        self.title = try container.decode(String.self, forKey: .title)
        self.contents = try container.decode(String.self, forKey: .contents)
        self.writerImageFilename = try container.decodeIfPresent(String.self, forKey: .writerImageFilename)
        self.writerId = try container.decode(String.self, forKey: .writerId)
        self.writerNickname = try container.decode(String.self, forKey: .writerNickname)
        self.uploadedTime = try container.decode(String.self, forKey: .uploadedTime)
        self.numberOfComments = try container.decode(Int.self, forKey: .numberOfComments)
        
        do {
            self.thumbnailImageFilename = try container.decodeIfPresent(String.self, forKey: .thumbnailImageFilename)
        } catch {
            self.thumbnailImageFilename = try container.decodeIfPresent([String].self, forKey: .thumbnailImageFilename)?.first
        }
        
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.price = try container.decodeIfPresent(String.self, forKey: .price)
    }
}
