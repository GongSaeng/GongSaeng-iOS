//
//  Thunder.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/15.
//

import Foundation

struct Thunder: Decodable {
    var index: Int
    var validStatus: Int
    var title: String
    var thumbnailImageName: String
    var meetingTime: String
    var placeName: String
    var remainingNum: Int
    var totalNum: Int
    
//    enum CodingKeys: String, CodingKey {
//        case index = "idx"
//        case title
//        case validStatus = "status"
//    }
}
