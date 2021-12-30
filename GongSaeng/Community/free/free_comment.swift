//
//  comment.swift
//  GongSaeng
//
//  Created by 유경민 on 2021/12/30.
//



import Foundation

struct free_comment: Codable, Equatable {
    let comment: String
    let writer: String
    //let category: String
    let time: String
    //let writer: String
    //let index: Int
    
//    init(dictionary: [String: Any]) {
//
//       // self.title = dictionary["title"] as? String ?? ""
//        self.writer = dictionary["name"] as? String ?? ""
//        self.comment = dictionary["contents"] as? String ?? ""
//        //self.category = dictionary["category"] as? String ?? ""
//        self.time = dictionary["regdate"] as? String ?? ""
//
//        //self.index = dictionary["bd_idx"] as? Int ?? 0
//
//
//
//    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case writer = "name"
        case comment = "contents"
        case time = "regdate"
    }
}
