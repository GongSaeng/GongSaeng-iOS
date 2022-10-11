//
//  MyPost.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/05/09.
//

import Foundation

struct MyPost: Decodable, MyWritten {
    var title: String
    var boardName: String
    var postingTime: String
    var numOfComment: Int
    var postIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case boardName = "board_name"
        case postingTime = "time"
        case numOfComment = "comment_num"
        case postIndex = "post_index"
    }
}
