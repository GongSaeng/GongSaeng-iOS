//
//  ThunderListCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/16.
//

import UIKit
import Kingfisher

struct ThunderListCellViewModel {
    var index: Int
    var validStatus: Bool
    var title: String
    var thumnailImage: URL?
    var meetingTime: String
    var placeName: String
    var totalNum: String
    var remainingDays: String
    var remainingNum: NSMutableAttributedString
    
    init(thunder: Thunder) {
        self.index = thunder.index
        self.title = thunder.title
        self.thumnailImage = URL(string: SERVER_IMAGE_URL + (thunder.thumbnailImageName ?? ""))
        self.meetingTime = thunder.meetingTime
            .toAnotherDateString(form: "M월 d일 (E) a h:mm") ?? ""
        self.placeName = thunder.placeName
        self.totalNum = "\(thunder.totalNum)명"
        self.remainingDays = thunder.meetingTime.toRemainingDays()
        self.remainingNum = NSMutableAttributedString(
            string: "\(thunder.remainingNum)",
            attributes: [.font: UIFont.systemFont(ofSize: 26.0,
                                                  weight: .bold),
                         .foregroundColor: UIColor(named: "colorPinkishOrange")!])
        self.remainingNum.append(NSAttributedString(
            string: " 명",
            attributes: [.font: UIFont.systemFont(ofSize: 14.0,
                                                  weight: .semibold),
                         .foregroundColor: UIColor.black]))
        
        self.validStatus = thunder.remainingNum > 0 // && !remainingDays.hasPrefix("D+")
    }
}
