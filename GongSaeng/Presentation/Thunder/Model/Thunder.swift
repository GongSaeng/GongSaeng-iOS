//
//  Thunder.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/15.
//

import Foundation

struct ThunderData: Decodable {
    var data: [Thunder]
}

struct Thunder: Decodable {
    var thumbnailImageName: String?
    var placeName: String
    var meetingTime: String
    var index: Int
    var title: String
    var totalNum: Int
    var participatnsNum: Int = 0
    var remainingNum: Int { totalNum - participatnsNum }
    
    enum CodingKeys: String, CodingKey {
        case index = "thunder_idx"
        case title
        case thumbnailImageName = "contents_image"
        case meetingTime = "meet_time"
        case placeName = "location"
        case totalNum = "total_num"
        case participatnsNum = "participants"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.index = try container.decode(Int.self, forKey: .index)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.meetingTime = try container.decode(String.self, forKey: .meetingTime)
        
        self.placeName = try container.decode(String.self, forKey: .placeName)
        self.totalNum = try container.decode(Int.self, forKey: .totalNum)
        
        if let decodedParticipants = try container.decodeIfPresent(String.self, forKey: .participatnsNum) {
            self.participatnsNum = decodedParticipants.components(separatedBy: ",").count
        }
        
        do {
            if let decodedFileName = try container.decodeIfPresent(String.self, forKey: .thumbnailImageName) {
                self.thumbnailImageName = decodedFileName.components(separatedBy: ",").first
            }
        } catch {
            if let decodedFileName = try container.decodeIfPresent([String].self, forKey: .thumbnailImageName) {
                self.thumbnailImageName = decodedFileName.first
            }
        }
    }
}
