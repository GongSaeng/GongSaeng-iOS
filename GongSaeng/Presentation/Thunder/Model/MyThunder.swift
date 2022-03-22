//
//  MyThunder.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/03.
//

import Foundation

struct MyThunder: Decodable {
    var postIndex: Int
    var postingImageFilename: String
    var title: String
    
    var meetingTime: String
    var placeName: String
    var address: String
    var placeURL: String
    var totalNum: Int
    
    var contents: String
    
    var participantsProfile: [Profile]
    
    var status: Int
    
    var numberOfComments: Int
}
