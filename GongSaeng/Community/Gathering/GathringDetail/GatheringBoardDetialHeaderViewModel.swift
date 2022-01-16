//
//  GatheringBoardDetialHeaderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit

struct GatheringBoardDetialHeaderViewModel {
    var isGathering: Bool
    var hasImages: Bool

    var numberOfImages: Int?
    var canCompleteGathering: Bool
    
    var title: String
    var contents: String
    var writerNickname: String
    var uploadedTime: String
    var numberOfCommentsText: String
    
    var writerImageUrl: String?
    var postingImagesUrl: [String]?
    
    var writerImage: UIImage {
        guard let fileName = writerImageUrl else { return UIImage(named: "3")! }
        let semaphore = DispatchSemaphore(value: 0)
        var cachedImage = UIImage()
        ImageCacheManager.getCachedImage(fileName: fileName) { image in
            cachedImage = image
            semaphore.signal()
        }
        semaphore.wait()
        return cachedImage
    }
    
    var postingImages: [UIImage] {
        guard let fileNames = postingImagesUrl else { return [] }
        let semaphore = DispatchSemaphore(value: 0)
        var cachedImages = [UIImage]()
        for fileName in fileNames {
            ImageCacheManager.getCachedImage(fileName: fileName) { image in
                cachedImages.append(image)
                if cachedImages.count == fileNames.count {
                    semaphore.signal()
                }
            }
        }
        semaphore.wait()
        return cachedImages
    }
    
    var uploadedTimeText: String {
        let beforeFormat = DateFormatter()
        let afterFormat = DateFormatter()
        beforeFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        afterFormat.dateFormat = "M월 dd일 HH:mm"
        return beforeFormat.date(from: uploadedTime)
            .map { afterFormat.string(from: $0) } ?? ""
    }
    
    init(post: Post, userID: String, gatheringStatus: Int) {
        self.title = post.title
        self.contents = post.contents
        self.writerNickname = post.writerNickname
        self.uploadedTime = post.uploadedTime
        self.numberOfCommentsText = "댓글 \(post.numberOfComments)"
        self.writerImageUrl = post.writerImageUrl
        self.postingImagesUrl = post.postingImagesUrl
        self.numberOfImages = post.postingImagesUrl.map { $0.count }
        self.isGathering = (gatheringStatus == 0)
        self.hasImages = !(post.postingImagesUrl ?? []).isEmpty
        self.canCompleteGathering = (userID == post.writerId && self.isGathering)
    }
}
