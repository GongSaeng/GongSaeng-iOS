//
//  GatheringBoardDetialHeaderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit

struct BoardDetialHeaderViewModel {
    var isValid: Bool
    var hasImages: Bool
    var category: String?
    var numberOfImages: Int?
    var canCompletePost: Bool
    
    var title: String
    var contents: String
    var writerNickname: String
    var uploadedTime: String
    var numberOfCommentsText: String
    
    var writerImageFilename: String?
    var postingImageFilenames: [String]?
    
    var price: String?
    
    var writerImageUrl: URL? {
        writerImageFilename.flatMap { URL(string: SERVER_IMAGE_URL + $0) }
    }
    
    var postingImageUrls: [URL]? {
        guard let postingImageFilenames = postingImageFilenames else { return nil }
        return postingImageFilenames.compactMap { URL(string: SERVER_IMAGE_URL + $0) }
    }
    
    var uploadedTimeText: String {
        let beforeFormat = DateFormatter()
        let afterFormat = DateFormatter()
        beforeFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        afterFormat.dateFormat = "M월 dd일 HH:mm"
        return beforeFormat.date(from: uploadedTime)
            .map { afterFormat.string(from: $0) } ?? ""
    }
    
    init(post: Post, userID: String) {
        self.title = post.title
        self.contents = post.contents
        self.writerNickname = post.writerNickname
        self.uploadedTime = post.uploadedTime
        self.numberOfCommentsText = "댓글 \(post.numberOfComments)"
        self.writerImageFilename = post.writerImageFilename
        self.postingImageFilenames = post.postingImagesFilename
        self.numberOfImages = post.postingImagesFilename.map { $0.count }
        self.isValid = (post.status ?? 1) == 0 ? true : false
        self.hasImages = !(post.postingImagesFilename ?? []).isEmpty
        self.canCompletePost = (userID == post.writerId && self.isValid)
        self.category = post.category
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.price = numberFormatter.number(from: post.price ?? "")
            .flatMap { numberFormatter.string(from: $0) }
            .map { "\(String(describing: $0))원" }
    }
}
