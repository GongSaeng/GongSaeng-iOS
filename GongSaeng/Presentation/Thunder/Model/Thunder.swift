//
//  Thunder.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/15.
//

import Foundation

struct Thunder: Decodable {
    var index: Int
    var validStatus: Int = 1
    var title: String
    var thumbnailImageName: String
    var meetingTime: String
    var placeName: String
    var totalNum: Int
    var participatnsNum: Int
    var remainingNum: Int { totalNum - participatnsNum }
    
    enum CodingKeys: String, CodingKey {
        case index = "idx"
        case title
        case thumbnailImageName = "contents_image"
        case meetingTime = "meet_time"
        case placeName = "location"
        case totalNum = "total_num"
        case participatnsNum = "participants_num"
//        case validStatus = "status"
    }
    
    /*
     1. status 필요
     2. contents_image가 리스트랑 디테일이 서로 뒤바뀜
     3. participants_num이 0인데 글쓴이가 일단 포함되니까 1로 해야할 듯
     4. 리스트 데이터에서
필요 없는 것들 = [
     writer_nickname,
     writer_image,
     metapoils,
     contents,
     register_time,
     detail_location,
     location_url,
     participants_image,
     region
     ]
     */
}
