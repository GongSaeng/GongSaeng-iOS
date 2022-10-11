//
//  MyComment.swift
//  GongSaeng
//
//  Created by Yujin Cha on 2022/10/11.
//

struct MyComment: Decodable, MyWritten {
    var postingTime: String
    var boardName: String
    var content: String
    var postIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case postingTime = "co_regdate"
        case boardName = "board_name"
        case content = "co_contents"
        case postIndex = "b_index"
    }
}
