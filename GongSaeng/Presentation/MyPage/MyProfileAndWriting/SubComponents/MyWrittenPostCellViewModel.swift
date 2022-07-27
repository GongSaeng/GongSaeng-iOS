//
//  MyWrittenPostCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/05/06.
//

import Foundation

struct MyWrittenPostCellViewModel {
    var title: String
    var boardName: String
    var postingTime: String
    var numOfComment: String
    var postIndex: Int
    
    init(myPost: MyPost) {
        self.title = myPost.title
        self.boardName = myPost.boardName
        self.postingTime = myPost.postingTime
            .toAnotherDateString(form: "MM/dd HH:mm")!
        self.numOfComment = myPost.numOfComment > 99 ? "99+" : "\(myPost.numOfComment)"
        self.postIndex = myPost.postIndex
    }
}
