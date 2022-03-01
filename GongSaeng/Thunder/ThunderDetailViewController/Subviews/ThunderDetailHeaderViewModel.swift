//
//  ThunderDetailHeaderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/23.
//

import Foundation

struct ThunderDetailHeaderViewModel {
    var attachedImageURLs: [URL?]
    var title: String
    var writerImageURL: URL?
    var writerNickname: String
    var uploadedTime: String
    
    var meetingTime: String
    var placeName: String
    var address: String
    var placeURL: URL?
    var totalNumber: Int
    var totalNumText: String
    var contents: String
    
    var participantImageURLs: [URL?]
    var participantIDs: [String]
    
    var numOfCommentsText: String
     
    init(thunderDetail: ThunderDetail) {
        self.attachedImageURLs = (thunderDetail.postingImagesFilename ?? [])
            .map { URL(string: $0) }
        self.title = thunderDetail.title
        self.writerImageURL = thunderDetail.writerImageFilename
            .flatMap { URL(string: $0) }
        self.writerNickname = thunderDetail.writerNickname
        self.uploadedTime = thunderDetail.uploadedTime
            .toAnotherDateString(form: "M월 d일 HH:mm") ?? ""
        
        self.meetingTime = thunderDetail.meetingTime
            .toAnotherDateString(form: "M월 d일 (E) a h:mm") ?? ""
        self.placeName = thunderDetail.placeName
        self.address = thunderDetail.address
        self.placeURL = URL(string: thunderDetail.placeURL)
        self.totalNumber = thunderDetail.totalNum
        self.totalNumText = "\(thunderDetail.totalNum)명"
        self.contents = thunderDetail.contents
        
        self.participantImageURLs = (thunderDetail.participantImageURLs ?? [])
            .map { URL(string: $0) }
        self.participantIDs = thunderDetail.participantIDs
        self.numOfCommentsText = "댓글 \(thunderDetail.numberOfComments)"
    }
}
