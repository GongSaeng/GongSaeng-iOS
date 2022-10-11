//
//  MyComment.swift
//  GongSaeng
//
//  Created by Yujin Cha on 2022/10/11.
//

struct MyCommentData: Decodable {
    var data: [MyComment]
}

struct MyComment: Decodable, MyWritten {
    var postingTime: String
    var code: String
    var content: String
    var postIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case postingTime = "co_regdate"
        case code = "bc_code"
        case content = "co_contents"
        case postIndex = "b_idx"
    }
}
