//
//  GatheringBoardDetialHeaderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/10.
//

import UIKit

struct GatheringBoardDetialHeaderViewModel {
    private let gathering: Gathering
    
    var isGathering: Bool? {
        guard gathering.gatheringStatus == "true" else { return false }
        return true
    }
    var hasImages: Bool? {
        return !(gathering.postingImagesUrl ?? []).isEmpty
    }
    var numberOfImages: Int? {
        guard let imagesUrl = gathering.postingImagesUrl else { return nil }
        return imagesUrl.count
    }
    
    var title: String? { gathering.title }
    var contents: String? { gathering.contents }
    var writerNickname: String? { gathering.writerNickname }
    var uploadedTime: String? { gathering.uploadedTime }
    var numberOfComments: String? { "댓글 \(gathering.numberOfComments)" }
    var writerImage: UIImage? {
        guard let fileName = gathering.writerImageUrl else { return nil }
        let semaphore = DispatchSemaphore(value: 0)
        var cachedImage = UIImage()
        ImageCacheManager.getCachedImage(fileName: fileName) { image in
            cachedImage = image
            print("DEBUG: cachedImage = image")
            semaphore.signal()
        }
        semaphore.wait()
        print("DEBUG: return cachedImage")
        return cachedImage
    }
    
    var postingImages: [UIImage]? {
        guard let fileNames = gathering.postingImagesUrl else { return nil }
        let semaphore = DispatchSemaphore(value: 0)
        var cachedImages = [UIImage]()
        for fileName in fileNames {
            ImageCacheManager.getCachedImage(fileName: fileName) { image in
                cachedImages.append(image)
                print("DEBUG: cachedImages.append(image)")
                if cachedImages.count == fileNames.count {
                    semaphore.signal()
                }
            }
        }
        semaphore.wait()
        return cachedImages
    }
    
    init(gathering: Gathering) {
        self.gathering = gathering
    }
}
