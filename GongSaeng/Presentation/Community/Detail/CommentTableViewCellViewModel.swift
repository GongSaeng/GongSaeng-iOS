//
//  CommentTableViewCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/15.
//

import UIKit

struct CommentTableViewCellViewModel {
    var contentsText: String
    var writerNicknameText: String
    var uploadedTime: String
    var writerImageFilename: String?
    var shouldBeAnonymous: Bool
    
    var writerImageUrl: URL? {
        return writerImageFilename.flatMap { URL(string: SERVER_IMAGE_URL + $0) }
    }
    
    var uploadedTimeText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
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
    
    init(comment: Comment, shouldBeAnonymous: Bool = false) {
        self.contentsText = comment.contents
        self.writerNicknameText = comment.writerNickname
        self.uploadedTime = comment.uploadedTime
        self.writerImageFilename = comment.writerImageFilename
        self.shouldBeAnonymous = shouldBeAnonymous
    }
}
