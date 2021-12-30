//
//  free.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/29.
//

import Foundation

struct free: Codable, Equatable {
    let title: String
    let contents: String
    let time: String
    let writer: String
    let index: Int
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.contents = dictionary["contents"] as? String ?? ""
        self.time = dictionary["time"] as? String ?? ""
        self.writer = dictionary["writer"] as? String ?? ""
        self.index = dictionary["b_idx"] as? Int ?? 0
    }
}
