//
//  District.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/02.
//

import Foundation

struct DistrictJSON: Decodable {
    let data: [District]
}

struct District: Decodable {
    let metropolisList: String
    let localList: [String]

    enum CodingKeys: String, CodingKey {
        case metropolisList = "metropolitan_government"
        case localList = "local_government"
    }
}
