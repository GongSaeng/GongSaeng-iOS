//
//  MyThunderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/02.
//

import Foundation

struct MyThunderViewModel {
    private var myThunders: [MyThunder]
    var index: Int = 0
    
    var numOfMyThunder: Int { myThunders.count }
    var numOfParticipants: Int { participantsImageURL.count }
    
    var postIndex: Int { myThunders[index].postIndex }
    var postingImageURLs: [URL?] {
        myThunders
            .map { $0.postingImageFilename }
            .map { URL(string: $0) }
    }
    var title: String { myThunders[index].title }
    
    var meetingTime: String {
        myThunders[index].meetingTime
        .toAnotherDateString(form: "M월 d일 (E) a h:mm") ?? "" }
    var placeName: String { myThunders[index].placeName }
    var address: String { myThunders[index].address }
    var placeURL: URL? {
        URL(string: myThunders[index].placeURL)
    }
    var totalNum: Int { myThunders[index].totalNum }
    var totalNumText: String { "\(totalNum)명" }
    
    var contents: String { myThunders[index].contents }
    
    var participantsImageURL: [URL?] {
        myThunders[index].participantsProfile
            .map { URL(string: $0.profileImageURL) }
    }
    
    var status: Int { myThunders[index].status }
    
    var numberOfComments: Int { myThunders[index].numberOfComments }
    
    var shouldShowButtons: Bool { numOfMyThunder > 1 }
    var isPreviousButtonEnabled: Bool { shouldShowButtons && index > 0 }
    var isNextButtonEnabled: Bool { shouldShowButtons && index < numOfMyThunder - 1 }
    
    init(myThunders: [MyThunder]) {
        self.myThunders = myThunders
    }
}
