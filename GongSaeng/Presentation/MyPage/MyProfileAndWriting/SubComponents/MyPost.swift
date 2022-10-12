//
//  MyPost.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/05/09.
//

import Foundation

struct MyPostData: Decodable {
    var data: [MyPost]
}

struct MyPost: Decodable, MyWritten {
    var title: String
    var code: String
    var postingTime: String
    var numOfComment: Int
    var postIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case code = "code"
        case postingTime = "time"
        case numOfComment = "comment_cnt"
        case postIndex = "idx"
    }
}
