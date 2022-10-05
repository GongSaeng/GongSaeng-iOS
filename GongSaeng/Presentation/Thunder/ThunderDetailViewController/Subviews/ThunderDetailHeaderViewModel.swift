//
//  ThunderDetailHeaderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/23.
//

import Foundation

struct ThunderDetailHeaderViewModel {
    var idx: Int
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
    
    var participantsProfile: [Profile]
    var participantImageURLs: [URL?] {
        return participantsProfile
            .compactMap { $0.profileImageURL }
            .map { URL(string: SERVER_IMAGE_URL + $0) }
    }
    
    enum JoinStatus {
        case owner
        case canJoin
        case canCancel
    }
    var joinStatus: JoinStatus
//    var participantIDs: [String] {
//        return participantsProfile.map { $0.id }
//    }
    
    var numOfCommentsText: String
     
    init(user: User, thunderDetail: ThunderDetail) {
        self.idx = thunderDetail.idx
        self.attachedImageURLs = (thunderDetail.postingImagesFilename)
            .map { URL(string: SERVER_IMAGE_URL + $0) }
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
        
        self.participantsProfile = thunderDetail.participantsProfile
        self.numOfCommentsText = "댓글 \(thunderDetail.numberOfComments)"
        
        if user.nickname == thunderDetail.writerNickname {
            self.joinStatus = .owner
        } else if participantsProfile.contains(where: { profile in
            user.nickname == profile.nickname
        }){
            self.joinStatus = .canCancel
        } else {
            self.joinStatus = .canJoin
        }
    }
}
