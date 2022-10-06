//
//  ThunderDetail.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/23.
//

import Foundation

struct ThunderDetailData: Decodable {
    var data: ThunderDetailInfo
}

struct ThunderDetailInfo: Decodable {
    var participants: [ParticipantProfile]
    var thunder: ThunderDetail
}

struct ParticipantProfile: Decodable {
    var id: String
    var profileImageURL: String
    var nickname: String
    var department: String
    var email: String?
    var introduce: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "m_id"
        case profileImageURL = "profile_image_url"
        case nickname = "m_nickname"
        case department = "m_department"
        case email = "m_mail"
        case introduce = "m_profile"
    }
}


struct ThunderDetail: Decodable {
    var idx: Int
    var postingImagesFilename: [String] = []
    var title: String
    var writerImageFilename: String?
    var writerId: String
    var writerNickname: String
    var uploadedTime: String
    
    var meetingTime: String
    var placeName: String
    var address: String
    var placeURL: String
    var totalNum: Int
    var contents: String
    var numberOfComments: Int = 3
    
    enum CodingKeys: String, CodingKey {
        case idx = "thunder_idx"
        case postingImagesFilename = "contents_image"
        case title, contents
        case writerImageFilename = "profile_image_url"
        case writerId = "m_id"
        case writerNickname = "m_nickname"
        case uploadedTime = "register_time"
        
        case meetingTime = "meet_time"
        case placeName = "location"
        case address = "detail_location"
        case placeURL = "location_url"
        case totalNum = "total_num"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.idx = try container.decode(Int.self, forKey: .idx)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.contents = try container.decode(String.self, forKey: .contents)
        self.writerImageFilename = try container.decodeIfPresent(String.self, forKey: .writerImageFilename)
        self.writerId = try container.decode(String.self, forKey: .writerId)
        self.writerNickname = try container.decode(String.self, forKey: .writerNickname)
        self.uploadedTime = try container.decode(String.self, forKey: .uploadedTime)
        self.meetingTime = try container.decode(String.self, forKey: .meetingTime)
        // self.numberOfComments = try container.decode(Int.self, forKey: .numberOfComments)
        
        self.placeName = try container.decode(String.self, forKey: .placeName)
        self.address = try container.decode(String.self, forKey: .address)
        self.placeURL = try container.decode(String.self, forKey: .placeURL)
        self.totalNum = try container.decode(Int.self, forKey: .totalNum)
        do {
            if let decodedFileName = try container.decodeIfPresent(String.self, forKey: .postingImagesFilename) {
                self.postingImagesFilename = decodedFileName.components(separatedBy: ",")
            }
        } catch {
            if let decodedFileName = try container.decodeIfPresent([String].self, forKey: .postingImagesFilename) {
                self.postingImagesFilename = decodedFileName
            } else {
                self.postingImagesFilename = []
            }
        }
    }
}
