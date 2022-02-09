//
//  PlaceListCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/07.
//

import Foundation

struct PlaceListCellViewModel {
    let placeName: String
    let addressName: String
    
    init(placeDocument: PlaceDocument) {
        self.placeName = placeDocument.placeName
        self.addressName = placeDocument.roadAddressName.isEmpty ? placeDocument.addressName : placeDocument.roadAddressName
    }
}
