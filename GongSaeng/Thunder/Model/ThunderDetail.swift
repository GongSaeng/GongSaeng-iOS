//
//  ThunderDetail.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/23.
//

import Foundation

struct ThunderDetail: Decodable {
    var postingImagesFilename: [String]?
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
    
    var participantImageURLs: [String]?
    var participantIDs: [String]
    
    var status: Int
    
    var numberOfComments: Int
    
//    enum CodingKeys: String, CodingKey {
//
//    }
}
