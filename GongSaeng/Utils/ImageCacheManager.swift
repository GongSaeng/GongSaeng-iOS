//
//  ImageCacheManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/06.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
    
    static func getCachedImage(fileName: String, completion: @escaping(UIImage) -> Void) {
        let cacheKey = NSString(string: fileName)
        if let cachedImage = shared.object(forKey: cacheKey) {
            completion(cachedImage)
        } else {
            ImageService.getImage(fileName: fileName) { image in
                shared.setObject(image.downSize(newWidth: 400), forKey: cacheKey)
                completion(image)
            }
        }
    }
}
