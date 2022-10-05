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
    //var participatnsNum: Int
    // var remainingNum: Int { totalNum - participatnsNum }
    var remainingNum: Int = 5
    
    enum CodingKeys: String, CodingKey {
        case index = "thunder_idx"
        case title
        case thumbnailImageName = "contents_image"
        case meetingTime = "meet_time"
        case placeName = "location"
        case totalNum = "total_num"
        // case participatnsNum = "participants_num"
    }
    
    // participants_num 주세요
    // m_id, m_nickname, writer_id, register_time, contents, metapolis, region, detail_location, location_url 빼도 돼요
    
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
