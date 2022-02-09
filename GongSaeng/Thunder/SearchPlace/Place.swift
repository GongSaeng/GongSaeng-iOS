//
//  Place.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/07.
//

import Foundation

struct Place: Decodable {
    let documents: [PlaceDocument]
}

struct PlaceDocument: Decodable {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
    }
}
