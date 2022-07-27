//
//  ThunderDetail.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/23.
//

import Foundation

struct ThunderDetail: Decodable {
    var postingImagesFilename: [String]
    var title: String
    var writerImageFilename: String?
//    var writerId: String
    var writerNickname: String
    var uploadedTime: String
    
    var meetingTime: String
    var placeName: String
    var address: String
    var placeURL: String
    var totalNum: Int
    var contents: String
    var participantsProfile: [Profile] {
        let numOfParticipants = participantsImageFilename.count
        var profiles: [Profile] = []
        for index in 0..<numOfParticipants {
            profiles.append(Profile(
                profileImageURL: participantsImageFilename[index],
                nickname: participantsNickname[index],
                job: participantsDepartment[index],
                email: participantsEmail[index],
                introduce: participantsIntroduce[index]))
        }
        return profiles
    }
    var status: Bool
    var numberOfComments: Int = 3
    
    private var participantsImageFilename: [String] = ["3"]
    private var participantsNickname: [String]
    private var participantsDepartment: [String]
    private var participantsEmail: [String]
    private var participantsIntroduce: [String]
    
    enum CodingKeys: String, CodingKey {
        case postingImagesFilename = "contents_image"
        case title, contents, status
        case writerImageFilename = "writer_image"
//        case writerId: String
        case writerNickname = "writer_nickname"
        case uploadedTime = "register_time"
        
        case meetingTime = "meet_time"
        case placeName = "location"
        case address = "detail_location"
        case placeURL = "location_url"
        case totalNum = "total_num"
        
//        case participantsImageFilename = "participants_image"
        case participantsNickname = "participants_nickname"
        case participantsDepartment = "participants_department"
        case participantsEmail = "participants_mail"
        case participantsIntroduce = "participants_profile"
//        case numberOfComments: Int
    }
}
