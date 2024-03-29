//
//  MyThunderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/02.
//

import Foundation

struct MyThunderViewModel {
    private var myThunders: [ThunderDetailInfo]
    private var isCanceledArr: [Bool]
    var index: Int = 0
    
    var isOwner: Bool { myThunders[index].thunder.writerId == user?.id }
    var isCanceled: Bool { isCanceledArr[index] }
    var numOfMyThunder: Int { myThunders.count }
    var numOfParticipants: Int { participantsImageURL.count }
    
    var postIndex: Int { myThunders[index].thunder.idx }
    var postingImageURLs: [URL?] {
        myThunders
            .map { $0.thunder.postingImagesFilename.first ?? "" }
            .map { URL(string: SERVER_IMAGE_URL + $0) }
    }
    var title: String { myThunders[index].thunder.title }
    
    var meetingTime: String {
        myThunders[index].thunder.meetingTime
        .toAnotherDateString(form: "M월 d일 (E) a h:mm") ?? "" }
    var placeName: String { myThunders[index].thunder.placeName }
    var address: String { myThunders[index].thunder.address }
    var placeURL: URL? {
        URL(string: myThunders[index].thunder.placeURL)
    }
    var totalNum: Int { myThunders[index].thunder.totalNum }
    var totalNumText: String { "\(totalNum)명" }
    
    var contents: String { myThunders[index].thunder.contents }
    
    var participantsImageURL: [URL?] {
        myThunders[index].participants
            .map { URL(string: SERVER_IMAGE_URL + $0.profileImageURL) }
    }
    
    var numberOfComments: Int { myThunders[index].thunder.numberOfComments }
    
    var shouldShowButtons: Bool { numOfMyThunder > 1 }
    var isPreviousButtonEnabled: Bool { shouldShowButtons && index > 0 }
    var isNextButtonEnabled: Bool { shouldShowButtons && index < numOfMyThunder - 1 }
    
    var user: User?
    
    init(myThunders: [ThunderDetailInfo]) {
        self.myThunders = myThunders
        self.isCanceledArr = [Bool](repeating: false, count: myThunders.count)
        
        guard let data = UserDefaults.standard.object(forKey: "loginUser") as? Data, let user = try? PropertyListDecoder().decode(User.self, from: data) else { return }
        self.user = user
    }
    
    mutating func setCancel() {
        isCanceledArr[index] = true
    }
}
