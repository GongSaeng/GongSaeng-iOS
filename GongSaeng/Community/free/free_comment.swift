//
//  free_comment.swift
//  GongSaeng
//
//  Created by 유경민 on 2021/12/30.
//

import Foundation

struct free_comment: Decodable, Equatable {
    let comment: String
    let writer: String
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case writer = "name"
        case comment = "contents"
        case time = "regdate"
    }
    
}
