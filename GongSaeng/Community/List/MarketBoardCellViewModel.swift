//
//  MarketBoardCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/17.
//

import UIKit

struct MarketBoardCellViewModel {
    var thumbnailIamgeFilename: String?
    var title: String
    var price: String
    var uploadedTime: String
    var numberOfComments: String
    var isOnSale: Bool
    
    var uploadedTimeText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let secondsInterval = dateFormatter.date(from: uploadedTime)
            .map { Calendar.current.dateComponents([.second], from: $0, to: Date()).second }
            .flatMap { $0 } ?? 0
        switch secondsInterval {
        case ..<60: // 초 단위
            return "방금"
        case 60 ..< 3600: // 분 단위 [1분~60분]
            return "\(secondsInterval / 60)분 전"
        case 3600 ..< 86400: // 시간 단위 [1시간~24시간]
            return "\(secondsInterval / 3600)시간 전"
        case 86400 ..< 2592000: // 일 단위 [1일~30일]
            return "\(secondsInterval / 86400)일 전"
        case 2592000 ..< 31536000: // 월 단위 [1개월~12개월]
            return "\(secondsInterval / 2592000)개월 전"
        default:
            return "\(secondsInterval / 31536000)년 전"
        }
    }
    
    var thumbnailImageUrl: URL? {
        thumbnailIamgeFilename.flatMap { URL(string: SERVER_IMAGE_URL + $0) }
    }
    
    init(community: Community) {
        self.thumbnailIamgeFilename = community.thumbnailImageFilename
        self.title = community.title
        self.uploadedTime = community.uploadedTime
        self.numberOfComments = (community.numberOfComments > 99) ? "99+" : "\(community.numberOfComments)"
        self.isOnSale = community.validStatus == 0 ? true : false
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.price = numberFormatter.number(from: community.price ?? "")
            .flatMap { numberFormatter.string(from: $0) }
            .map { "\(String(describing: $0))원" }!
    }
}
